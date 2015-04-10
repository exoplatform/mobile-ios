//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "HomeSidebarViewController_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "JTTableViewDatasource.h"
#import "JTTableViewCellModal.h"
#import "JTTableViewCellFactory.h"
#import "DashboardViewController_iPhone.h"
#import "ActivityStreamBrowseViewController_iPhone.h"
#import "DocumentsViewController_iPhone.h"
#import "SettingsViewController.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"
#import "UserProfileViewController.h"
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "AccountSwitcherViewController_iPhone.h"

#define kUserProfileViewHeight    70.0
#define kFooterViewHeight         60.0
#define kFooterViewWidth         270.0
#define kFooterButtonLeftMargin    6.0
#define kFooterButtonTopMargin    15.0
#define kCoverViewTag               10
@interface UIFooterView : UIView 

@end

@implementation UIFooterView 

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = [UIColor colorWithRed:40./255 green:40./255 blue:40./255 alpha:1].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:20./255 green:20./255 blue:20./255 alpha:1].CGColor;

    // draw gradient 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id) startColor, (id) endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

@end

@interface HomeSidebarViewController_iPhone (UITableView) <JTTableViewDatasourceDelegate>

@end

// = Interface for private method
@interface HomeSidebarViewController_iPhone (PrivateMethods)

- (void)initAndSelectDocumentsViewController;

@end

@interface HomeSidebarViewController_iPhone ()
@property (nonatomic, retain) UIButton* accountSwitcherButton;
@end

@implementation HomeSidebarViewController_iPhone

@synthesize accountSwitcherButton = _accountSwitcherButton;
@synthesize contentNavigationItem;
@synthesize contentNavigationBar;
@synthesize tableView = _tableView;
@synthesize userProfileViewController = _userProfileViewController;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    [_viewControllers release];
    [_revealView release];
    [_tableView release];
    [_userProfileViewController release];
    self.accountSwitcherButton = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewControllers = [[NSMutableArray alloc] init];
        _datasource = [[JTTableViewDatasource alloc] init];
        _datasource.sourceInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"root", @"url", nil];
        _datasource.delegate   = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // set background color 
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeMenuBg.png"]];
    
    // Create a default style RevealSidebarView
    _revealView = [[JTRevealSidebarView defaultViewWithFrame:self.view.bounds] retain];

    // This hack to handle the navigation actions.
    _revealView.contentView.navigationBar.delegate = self;
    
    CGRect sidebarBounds = _revealView.sidebarView.bounds;
    UIView *containerView = [[[UIView alloc] initWithFrame:sidebarBounds] autorelease];
    containerView.backgroundColor = [UIColor clearColor];

    [_revealView.sidebarView pushView:containerView animated:NO];
    
    CGRect profileFrame = CGRectZero;
    profileFrame.size.width = sidebarBounds.size.width;
    profileFrame.size.height = kUserProfileViewHeight;
    if (!_userProfileViewController) {
        _userProfileViewController = [[UserProfileViewController alloc] initWithFrame:profileFrame];
    }
    _userProfileViewController.username = [[ApplicationPreferencesManager sharedInstance] getSelectedAccount].username;
    [_userProfileViewController startUpdateCurrentUserProfile];
    [containerView addSubview:_userProfileViewController.view];
    
    // Setup a view to be the rootView of the sidebar
    CGRect tableFrame = CGRectOffset(sidebarBounds, 0, profileFrame.size.height);
    tableFrame.size.height -= profileFrame.size.height;
    self.tableView = [[[UITableView alloc] initWithFrame:tableFrame] autorelease];
    self.tableView.scrollsToTop = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = [UIImage imageNamed:@"HomeMenuFeatureSelectedBg.png"].size.height;
    self.tableView.delegate   = _datasource;
    self.tableView.dataSource = _datasource;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [containerView addSubview:self.tableView];
    //Add the ActivityStream as main view
    ActivityStreamBrowseViewController_iPhone* _activityStreamBrowseViewController_iPhone = [[ActivityStreamBrowseViewController_iPhone alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPhone" bundle:nil];
    
    
    [self setRootViewController:_activityStreamBrowseViewController_iPhone animated:YES];
    [_activityStreamBrowseViewController_iPhone release];
    [_revealView revealSidebar:NO];
    
    
    
    //Add the footer of the view for Logout and Account Switcher buttons
    UIFooterView *footer = [[UIFooterView alloc] initWithFrame:CGRectMake(0,
                                                                          self.view.frame.size.height-kFooterViewHeight,
                                                                          self.view.frame.size.width,
                                                                          kFooterViewHeight)];
    CGRect footerBounds = footer.bounds;
    
    // Create the Logout button
    UIButton *buttonLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogout.frame = CGRectMake(footerBounds.origin.x+kFooterButtonLeftMargin,
                                    footerBounds.origin.x+kFooterButtonTopMargin,
                                    31,
                                    34);
    buttonLogout.showsTouchWhenHighlighted = YES;
    
    _disconnectLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_disconnectLabel setTitle:Localize(@"Disconnect") forState:UIControlStateNormal];
    _disconnectLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _disconnectLabel.showsTouchWhenHighlighted = YES;
    [_disconnectLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_disconnectLabel setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.25] forState:UIControlStateNormal];
    _disconnectLabel.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [_disconnectLabel.titleLabel setTextAlignment:UITextAlignmentLeft];
    [_disconnectLabel addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    CGSize disLabelSize = [_disconnectLabel.titleLabel.text sizeWithFont:_disconnectLabel.titleLabel.font];
    _disconnectLabel.frame =  CGRectMake(buttonLogout.frame.origin.x + buttonLogout.frame.size.width + kFooterButtonLeftMargin,
                                         kFooterButtonTopMargin,
                                         disLabelSize.width,
                                         34);
    [footer addSubview:_disconnectLabel];

    // Load the logout icon and create the image view
    UIImage *image = [UIImage imageNamed:@"Ipad_logout.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,31,34)];
    [imageView setImage:image];
    
    [buttonLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [buttonLogout addSubview:imageView];
    [footer addSubview:buttonLogout];
    
    // Create the Account Switcher button
    self.accountSwitcherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.accountSwitcherButton.frame = CGRectMake(kFooterViewWidth-31-kFooterButtonLeftMargin, // right of the parent frame
                                             footerBounds.origin.y+kFooterButtonTopMargin,
                                             31,
                                             34);
    self.accountSwitcherButton.showsTouchWhenHighlighted = YES;
    UIImage *switcherImg = [UIImage imageNamed:@"Ipad_Switcher.png"];
    UIImageView *switcherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,31,34)];
    [switcherImageView setImage:switcherImg];
    [self.accountSwitcherButton addTarget:self action:@selector(openAccountSwitcher) forControlEvents:UIControlEventTouchUpInside];
    [self.accountSwitcherButton addSubview:switcherImageView];
    [footer addSubview:self.accountSwitcherButton];
    [self setAccountSwitcherVisibility];
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFooterViewWidth, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
    [footer addSubview:topLine];
    [topLine release];
    
    [_revealView.sidebarView addSubview:footer];
    
    rowType = eXoActivityStream;
    
    // Create a custom Menu button    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barButtonImage = [UIImage imageNamed:@"NavbarMenuButton.png"];
    tmpButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
    [tmpButton setImage:barButtonImage forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(toggleButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    _revealView.contentView.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:tmpButton] autorelease];
      
    [self.view addSubview:_revealView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithNewLanguage) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    
    UIButton *topScrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topScrollButton.frame = CGRectMake(self.view.center.x - 50, 0, 100,20);
    [topScrollButton addTarget:self action:@selector(topScrollButtonAction:) forControlEvents: UIControlEventTouchUpInside];
    topScrollButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topScrollButton];
    
}
-(void) topScrollButtonAction:(id) sender {
    if (! [_revealView isSidebarShowing]){
        [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_SCROLL_TO_TOP object:nil];
        NSLog(@"coucou touché");
    }
}

- (void)setAccountSwitcherVisibility
{
    if ([[ApplicationPreferencesManager sharedInstance] twoOrMoreAccountsExist]) {
        self.accountSwitcherButton.hidden = NO;
    } else {
        // Hide the button if only 1 account exists
        self.accountSwitcherButton.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - getters & setters 
- (UINavigationItem *)contentNavigationItem {
    return _revealView.contentView.navigationItem;
}

- (JTNavigationBar *)contentNavigationBar {
    return _revealView.contentView.navigationBar;
}

#pragma mark Actions

-(void)logout {
    [UserPreferencesManager sharedInstance].autoLogin = NO;
    [[AppDelegate_iPhone instance] onBtnSigtOutDelegate];
}

-(void)openAccountSwitcher {
    AccountSwitcherViewController_iPhone* accountSwitcher = [[AccountSwitcherViewController_iPhone alloc] initWithStyle:UITableViewStyleGrouped];
    accountSwitcher.accountSwitcherDelegate = self;
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:accountSwitcher] autorelease];
    [accountSwitcher release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didCloseAccountSwitcher {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleButtonPressed:(id)sender {
    [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
    if ([_revealView isSidebarShowing]){
        UIView * coverView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
        UITapGestureRecognizer * tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftMenu:)] autorelease];
        tapGesture.numberOfTapsRequired =1;
        [coverView addGestureRecognizer:tapGesture];
        coverView.backgroundColor = [UIColor clearColor];
        
        UISwipeGestureRecognizer * swipeGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeLeftMenu:)] autorelease];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [coverView addGestureRecognizer:swipeGesture];

        [_revealView.contentView addSubview:coverView];
        
        coverView.tag = kCoverViewTag;
        
    }
}

-(void) closeLeftMenu:(id) sender {
    [self toggleButtonPressed:sender];
    UIView * coverView =[_revealView.contentView viewWithTag:kCoverViewTag];
    if (coverView){
        [coverView removeFromSuperview];
    }
    
}
- (void)pushContentView:(id)sender {
    UIView *subview = [[UIView alloc] initWithFrame:CGRectZero];
    subview.backgroundColor = [UIColor blueColor];
    subview.title           = @"Pushed Subview";
    [_revealView.contentView pushView:subview animated:YES];
    [subview release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma - Settings Delegate Methods

-(void)doneWithSettings {
    // We have to display/hide the account switcher button if the number of accounts is more/less than 2
    [self setAccountSwitcherVisibility];
    // Reload menu view by setting changes
    [self.tableView reloadData];
    // Jump to last selected menu item
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    // Update title for content view by selected menu item
    _revealView.contentView.navigationItem.title = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0]] textLabel] text];
    // Reload the Documents page it is currently selected
    if (rowType == eXoDocuments) {
        [self initAndSelectDocumentsViewController];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initAndSelectDocumentsViewController {
    DocumentsViewController_iPhone *documentsViewController = [[[DocumentsViewController_iPhone alloc] initWithNibName:@"DocumentsViewController_iPhone" bundle:nil] autorelease];
    documentsViewController.isRoot = YES;
    [self setRootViewController:documentsViewController animated:NO];
}

#pragma mark Helper

- (void)simulateDidSucceedFetchingDatasource:(JTTableViewDatasource *)datasource {
    NSString *url = [datasource.sourceInfo objectForKey:@"url"];
    if ([url isEqualToString:@"root"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObjects:
          [JTTableViewCellModalSimpleType modalWithTitle:@"News" type:eXoActivityStream],
          [JTTableViewCellModalSimpleType modalWithTitle:@"Documents" type:eXoDocuments],
          [JTTableViewCellModalSimpleType modalWithTitle:@"Dashboard" type:eXoDashboard],
          [JTTableViewCellModalSimpleType modalWithTitle:@"Settings" type:eXoSettings],

          nil]
         ];
    } else {
        NSAssert(NO, @"not handled!", nil);
    }
}

- (void)loadDatasourceSection:(JTTableViewDatasource *)datasource {
    [self performSelector:@selector(simulateDidSucceedFetchingDatasource:)
               withObject:datasource
               afterDelay:1];
}

#pragma mark - navigation view controllers management

- (void)setScrollToTopForViewController:(UIViewController*)viewC withScroll:(BOOL)scroll {
    if ([viewC isKindOfClass:[ActivityStreamBrowseViewController class]])
        [(ActivityStreamBrowseViewController*)viewC tblvActivityStream].scrollsToTop = scroll;
    else if ([viewC isKindOfClass:[DocumentsViewController class]])
        [(DocumentsViewController*)viewC tblFiles].scrollsToTop = scroll;
    else if ([viewC isKindOfClass:[DashboardViewController class]])
        [(DashboardViewController*)viewC tblGadgets].scrollsToTop = scroll;
}

- (void)setContentNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [_revealView.contentView setNavigationBarHidden:hidden animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // * the viewcontroller must not be already on the navigation stack
    if ([_viewControllers containsObject:viewController])
        return;
    // Disable scroll to top on the soon to be hidden view controller
    UIViewController *lastViewController = [_viewControllers lastObject];
    [self setScrollToTopForViewController:lastViewController withScroll:NO];
    // No need to activate the scroll to top on the new view controller, it is by default
    // Push view controller
    [_viewControllers addObject:viewController];
    [_revealView.contentView pushView:viewController.view animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *lastViewController = [_viewControllers lastObject];
    [_viewControllers removeLastObject];
    [_revealView.contentView popViewAnimated:animated];
    return lastViewController;
}

- (void)setRootViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [_viewControllers removeAllObjects];
    [_viewControllers addObject:viewController];
    [_revealView.contentView setRootView:viewController.view];
}

#pragma mark - JTNavigationBarDelegate
- (void)willPopNavigationItemAnimated:(BOOL)animated {
    [_viewControllers removeLastObject];
    // No need to disable top to scroll on the previous top view controller, it is hidden
    // Enable scroll to top on the new top view controller
    UIViewController *topViewController = [_viewControllers lastObject];
    [self setScrollToTopForViewController:topViewController withScroll:YES];
    // Pop view controller
    [_revealView.contentView willPopNavigationItemAnimated:animated];
}


#pragma mark - change language management

- (void)updateLabelsWithNewLanguage {
    // Update the label of the button
    [_disconnectLabel setTitle:Localize(@"Disconnect") forState:UIControlStateNormal];
    // Calculate the new size and apply it
    CGSize disLabelSize = [_disconnectLabel.titleLabel.text sizeWithFont:_disconnectLabel.titleLabel.font];
    _disconnectLabel.frame = CGRectMake(_disconnectLabel.frame.origin.x,
                                        _disconnectLabel.frame.origin.y,
                                        disLabelSize.width,
                                        _disconnectLabel.frame.size.height);
}

@end

#pragma mark -


@implementation HomeSidebarViewController_iPhone (UITableView)

- (BOOL)datasourceShouldLoad:(JTTableViewDatasource *)datasource {
    if ([datasource.sourceInfo objectForKey:@"url"]) {
        [self loadDatasourceSection:datasource];
        return YES;
    } else {
        return NO;
    }
}

#define kMenuTableViewCellHeight 60

- (UITableViewCell *)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView cellForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalLoadingIndicator)]) {
        static NSString *cellIdentifier = @"loadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [JTTableViewCellFactory loaderCellWithIdentifier:cellIdentifier];
        }
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModal)]) {
        static NSString *cellIdentifier = @"titleCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
           
            cell.clipsToBounds = YES;
            
            UIView* bgView = [[UIView alloc] init];
            bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeMenuFeatureSelectedBg.png"]];
            cell.selectedBackgroundView = bgView;
            [bgView release];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
            cell.textLabel.shadowOffset = CGSizeMake(0, 2);
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
            
            cell.imageView.contentMode = UIViewContentModeCenter;
            cell.textLabel.textColor = [UIColor whiteColor];
            
            // add bottom line
            UIImage *lineImg = [UIImage imageNamed:@"HomeFeatureSeparator.png"];
            lineImg = [lineImg stretchableImageWithLeftCapWidth:(lineImg.size.width / 2) topCapHeight:0];
            UIImageView *bottomLine = [[UIImageView alloc] initWithImage:lineImg];
            bottomLine.frame = CGRectMake(0, cell.bounds.size.height - lineImg.size.height, cell.bounds.size.width, lineImg.size.height);
            bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [cell addSubview:bottomLine];
            [bottomLine release];
        }
        if ([[datasource.sections objectAtIndex:0] indexOfObject:object] == 0) {
            // Generate the top separator line for the first cell 
            UIImage *lineImg = [UIImage imageNamed:@"HomeFeatureSeparator.png"];
            lineImg = [lineImg stretchableImageWithLeftCapWidth:(lineImg.size.width / 2) topCapHeight:0];
            UIImageView *topLine = [[UIImageView alloc] initWithImage:lineImg];
            topLine.tag = 999;
            topLine.frame = CGRectMake(0, 0, cell.bounds.size.width, lineImg.size.height);
            topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            [cell addSubview:topLine];
            [topLine release];
        } else {
            [[cell viewWithTag:999] removeFromSuperview];
        }
        
        cell.textLabel.text = Localize([(id <JTTableViewCellModal>)object title]);
        // set accessory view for cells except Setting cell
        if ([(JTTableViewCellModalSimpleType *)object type] == eXoSettings) {
            cell.accessoryView = nil;
        } else {
            cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeFeatureAccessory.png"]] autorelease];
        }
        
        switch ([(JTTableViewCellModalSimpleType *)object type]) {
            case eXoActivityStream:
            {
                cell.imageView.image = [UIImage imageNamed:@"HomeActivityStreamsIconiPhone.png"];

            }
                break;
            case eXoDashboard:
            {
                cell.imageView.image = [UIImage imageNamed:@"HomeDashboardIconiPhone.png"];

            }
                break;
            case eXoSettings:
            {
                
                cell.imageView.image = [UIImage imageNamed:@"HomeSettingsIconiPhone.png"];

            }
                break;
            case eXoDocuments:
            {
                cell.imageView.image = [UIImage imageNamed:@"HomeDocumentsIconiPhone.png"];

            }
                break;
            default:
                break;
        }

        CGPoint middleCell = cell.imageView.center;
        CGRect tmpFrame = cell.imageView.frame;
        tmpFrame.size.width = tmpFrame.size.width/2;
        tmpFrame.size.height = tmpFrame.size.height/2;
        cell.imageView.frame = tmpFrame;
        cell.imageView.center = middleCell;
        
        
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            static NSString *cellIdentifier = @"datasourceCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[custom info] objectForKey:@"title"];
            return cell;
        }
    }
    return nil;
}

- (void)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView didSelectObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            UITableView *tableView = [[[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds] autorelease];
            tableView.delegate   = datasource;
            tableView.dataSource = datasource;
            tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_revealView.sidebarView pushView:tableView animated:YES];
        }
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalSimpleType)]) {  
        
        switch ([(JTTableViewCellModalSimpleType *)object type]) {
            case eXoActivityStream:
            {
                ActivityStreamBrowseViewController_iPhone* _activityStreamBrowseViewController_iPhone = [[ActivityStreamBrowseViewController_iPhone alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPhone" bundle:nil];
                
                
                [self setRootViewController:_activityStreamBrowseViewController_iPhone animated:YES];
                [_activityStreamBrowseViewController_iPhone release];
                [self closeLeftMenu:nil];
                rowType = [(JTTableViewCellModalSimpleType *)object type];
            }
                break;
            case eXoDashboard:
            {
                DashboardViewController_iPhone *dashboardController = [[[DashboardViewController_iPhone alloc] initWithNibName:@"DashboardViewController_iPhone" bundle:nil] autorelease];
                [self setRootViewController:dashboardController animated:NO];
                [self closeLeftMenu:nil];
                rowType = [(JTTableViewCellModalSimpleType *)object type];
            }
                break;
            case eXoSettings:
            {
                SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                settingsViewController.settingsDelegate = self;
                [settingsViewController startRetrieve];
                UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
                [settingsViewController release];
                
                navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                
                [self presentViewController:navController animated:YES completion:nil];
            }
                break;
            case eXoDocuments:
            {
                // Same code is used at the end of the method doneWithSettings
                // Hence it's put in the separate method initAndSelectDocumentsViewController
                [self initAndSelectDocumentsViewController];
                [self closeLeftMenu:nil];
                rowType = [(JTTableViewCellModalSimpleType *)object type];
            }
                break;
            default:
                break;
        }
    }
}

- (void)datasource:(JTTableViewDatasource *)datasource sectionsDidChanged:(NSArray *)oldSections {
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}


@end

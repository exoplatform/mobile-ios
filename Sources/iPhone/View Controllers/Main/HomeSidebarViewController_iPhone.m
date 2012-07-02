//
//  HomeSidebarViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan on 15/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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

#define kUserProfileViewHeight 70.0

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


@implementation HomeSidebarViewController_iPhone

@synthesize contentNavigationItem;
@synthesize contentNavigationBar;
@synthesize tableView = _tableView;
@synthesize userProfileViewController = _userProfileViewController;

- (void)dealloc {
    [_viewControllers release];
    [_revealView release];
    [_tableView release];
    [_userProfileViewController release];
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
    _userProfileViewController.username = [SocialRestConfiguration sharedInstance].username;
    [_userProfileViewController startUpdateCurrentUserProfile];
    [containerView addSubview:_userProfileViewController.view];
    
    // Setup a view to be the rootView of the sidebar
    CGRect tableFrame = CGRectOffset(sidebarBounds, 0, profileFrame.size.height);
    tableFrame.size.height -= profileFrame.size.height;
    self.tableView = [[[UITableView alloc] initWithFrame:tableFrame] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeFeatureSeparator.png"]].CGColor;
//    self.tableView.layer.borderWidth = 1.0;
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
    
    
    
    //Add the footer of the View
    //For Settings and Logout
    UIFooterView *footer = [[UIFooterView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width,60)];
    
    // Create the button
    UIButton *buttonLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogout.frame = CGRectMake(6, 15, 31, 34);
    buttonLogout.showsTouchWhenHighlighted = YES;
    
    UIButton *disconnectLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    disconnectLabel.frame =  CGRectMake(buttonLogout.frame.origin.x + buttonLogout.frame.size.width + 7, 15, 80, 34);
    
    [disconnectLabel setTitle:Localize(@"Disconnect") forState:UIControlStateNormal];

    disconnectLabel.showsTouchWhenHighlighted = YES;
    [disconnectLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disconnectLabel setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.25] forState:UIControlStateNormal];
    
    disconnectLabel.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    [disconnectLabel.titleLabel setTextAlignment:UITextAlignmentLeft];

    [disconnectLabel addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:disconnectLabel];

    
    // Now load the image and create the image view
    UIImage *image = [UIImage imageNamed:@"Ipad_logout.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,31,34)];
    [imageView setImage:image];
    
    [buttonLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    
    [buttonLogout addSubview:imageView];
    
    [footer addSubview:buttonLogout];
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 1)];
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
}

-(void)logout {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"NO" forKey:EXO_AUTO_LOGIN];
    [userDefaults synchronize];
    [[AppDelegate_iPhone instance] onBtnSigtOutDelegate];
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

- (void)toggleButtonPressed:(id)sender {
    [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
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
    // Reload menu view by setting changes
    [self.tableView reloadData];
    // Jump to last selected menu item
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    // Update title for content view by selected menu item
    _revealView.contentView.navigationItem.title = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0]] textLabel] text];
    [self dismissModalViewControllerAnimated:YES];
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
- (void)setContentNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [_revealView.contentView setNavigationBarHidden:hidden animated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // * the viewcontroller must not be already on the navigation stack
    if ([_viewControllers containsObject:viewController])
        return;
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
    [_revealView.contentView willPopNavigationItemAnimated:animated];
}

@end


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
                [_revealView revealSidebar:NO];
                rowType = [(JTTableViewCellModalSimpleType *)object type];
            }
                break;
            case eXoDashboard:
            {
                DashboardViewController_iPhone *dashboardController = [[DashboardViewController_iPhone alloc] initWithNibName:@"DashboardViewController_iPhone" bundle:nil];
                //[self.navigationController pushViewController:dashboardController animated:YES];
                //[dashboardController release];
                
                [_revealView.contentView setRootView:dashboardController.view];
                //[dashboardController release];
                [_revealView revealSidebar:NO];
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
                
                [self presentModalViewController:navController animated:YES];
            }
                break;
            case eXoDocuments:
            {
                DocumentsViewController_iPhone *documentsViewController = [[DocumentsViewController_iPhone alloc] initWithNibName:@"DocumentsViewController_iPhone" bundle:nil];
                documentsViewController.isRoot = YES;
                [_revealView.contentView setRootView:documentsViewController.view];
                //[documentsViewController release];
                [_revealView revealSidebar:NO];
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

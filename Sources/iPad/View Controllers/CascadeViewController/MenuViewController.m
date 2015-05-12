//
//  MenuViewController.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "MenuViewController.h"
#import "RootViewController.h"
#import "ExoStackScrollViewController.h"
#import "AppDelegate_iPad.h"
#import "LanguageHelper.h"
#import "UserProfileViewController.h"
#import "AccountSwitcherViewController_iPad.h"
#import "ActivityStreamBrowseViewController_iPad.h"
#import "DocumentsViewController_iPad.h"
#import "DashboardViewController_iPad.h"
#import "ApplicationPreferencesManager.h"


#define kCellText @"CellText"
#define kCellImage @"CellImage"

#define kHeightForFooter 60.0
#define kMenuViewHeaderHeight 70.0
#define kMenuViewWidth  200.0
#define kFooterButtonWidth 40.0
#define kFooterButtonLeftRightMargin 15.0
#define kFooterLogoutButtonPosX   kFooterButtonLeftRightMargin // Aligned left (0 + left margin)
#define kFooterSwitcherButtonPosX (kMenuViewWidth-kFooterButtonWidth)/2 // Center
#define kFooterSettingsButtonPosX kMenuViewWidth - kFooterButtonWidth - kFooterButtonLeftRightMargin // Aligned right


@interface FooterView : UIView

@end

@implementation FooterView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = [UIColor colorWithRed:40./255 green:40./255 blue:40./255 alpha:1].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:20./255 green:20./255 blue:20./255 alpha:1].CGColor;
    
    // draw gradient 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(id) startColor, (id) endColor];
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

// = Interface for private method
@interface MenuViewController (PrivateMethods)
- (void)initModalNavigationController;
- (void)initAndSelectDocumentsViewController;
@end

@interface MenuViewController () {
 
}

@property (nonatomic, retain) eXoNavigationController* modalNavigationViewController;
@property (nonatomic, retain) UIButton* accountSwitcherButton;
@property (nonatomic) CGRect viewFrame;
@end

@implementation MenuViewController

@synthesize modalNavigationViewController;
@synthesize userProfileViewController = _userProfileViewController;
@synthesize tableView = _tableView, isCompatibleWithSocial = _isCompatibleWithSocial;
@synthesize accountSwitcherButton = _accountSwitcherButton;


#pragma mark -
#pragma mark View lifecycle

- (instancetype)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial {
    self = [super init];
    if (self) {
        _viewFrame = frame;
        _isCompatibleWithSocial = compatibleWithSocial;
		_cellContents = [[NSMutableArray alloc] init];

        if(_isCompatibleWithSocial){
            [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellText: Localize(@"News")}];
        }
        [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"DocumentIpadIcon.png"], kCellText: Localize(@"Documents")}];
        [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"DashboardIpadIcon.png"], kCellText: Localize(@"Dashboard")}];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[[UIView alloc] initWithFrame:_viewFrame] autorelease];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    CGRect viewBounds = self.view.bounds;
    self.userProfileViewController = [[[UserProfileViewController alloc] initWithFrame:CGRectMake(0, 0, viewBounds.size.width, kMenuViewHeaderHeight)] autorelease];
    self.userProfileViewController.username = [SocialRestConfiguration sharedInstance].username;
    [self.userProfileViewController startUpdateCurrentUserProfile];
    [self.view addSubview:self.userProfileViewController.view];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kMenuViewHeaderHeight, viewBounds.size.width, viewBounds.size.height - kMenuViewHeaderHeight - kHeightForFooter) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = [UIImage imageNamed:@"HomeMenuFeatureSelectedBg.png"].size.height;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_tableView];

    //Add the footer of the View for Logout, Account Switcher and Settings buttons
    UIView *footer = [[[FooterView alloc] initWithFrame:CGRectMake(0,
                                                                   viewBounds.size.height - kHeightForFooter,
                                                                   viewBounds.size.width,
                                                                   kHeightForFooter)] autorelease];
    footer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:footer];
    // Create the Logout button
    UIButton *buttonLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogout.frame = CGRectMake(kFooterLogoutButtonPosX, 10, kFooterButtonWidth, 42);
    buttonLogout.showsTouchWhenHighlighted = YES;
    UIImage *image = [UIImage imageNamed:@"Ipad_logout.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kFooterButtonWidth,42)];
    [imageView setImage:image];
    [buttonLogout addTarget:[AppDelegate_iPad instance] action:@selector(backToAuthenticate) forControlEvents:UIControlEventTouchUpInside];
    [buttonLogout addSubview:imageView];
    [footer addSubview:buttonLogout];
    
    // Create the Account Switcher button
    self.accountSwitcherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.accountSwitcherButton.frame = CGRectMake(kFooterSwitcherButtonPosX, 10, kFooterButtonWidth, 42);
    self.accountSwitcherButton.showsTouchWhenHighlighted = YES;
    UIImage *imageSwitcher = [UIImage imageNamed:@"Ipad_Switcher.png"];
    UIImageView *imageSwitcherView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kFooterButtonWidth,42)];
    [imageSwitcherView setImage:imageSwitcher];
    [self.accountSwitcherButton addTarget:self action:@selector(openAccountSwitcher) forControlEvents:UIControlEventTouchUpInside];
    [self.accountSwitcherButton addSubview:imageSwitcherView];
    [footer addSubview:self.accountSwitcherButton];
    [self setAccountSwitcherButtonVisibility];
    
    // Create the Settings button
    UIButton *buttonSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSettings.frame = CGRectMake(kFooterSettingsButtonPosX, 12, kFooterButtonWidth, 42);
    buttonSettings.showsTouchWhenHighlighted = YES;
    UIImage *imageSettings = [UIImage imageNamed:@"Ipad_setting.png"];
    UIImageView *imageViewSettings = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,kFooterButtonWidth,42)];
    [imageViewSettings setImage:imageSettings];
    [buttonSettings addSubview:imageViewSettings];
    [buttonSettings addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:buttonSettings];
    
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMenuViewWidth, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
    [footer addSubview:topLine];
    [topLine release];
    
}

- (void)setAccountSwitcherButtonVisibility
{
    if ([[ApplicationPreferencesManager sharedInstance] twoOrMoreAccountsExist]) {
        self.accountSwitcherButton.hidden = NO;
    } else {
        // Hide the button if only 1 account exists
        self.accountSwitcherButton.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithNewLanguage) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.userProfileViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark MenuManagement methods

- (void) initModalNavigationController {
    self.modalNavigationViewController = [[eXoNavigationController alloc] init];
    self.modalNavigationViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.modalNavigationViewController.modalPresentationStyle = UIModalPresentationFormSheet;
}

- (void)openAccountSwitcher {
    AccountSwitcherViewController_iPad* accountSwitcher = [[AccountSwitcherViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
    accountSwitcher.accountSwitcherDelegate = self;
    accountSwitcher.modalPresentationStyle = UIModalPresentationFormSheet;
    accountSwitcher.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    if (self.modalNavigationViewController == nil)
    {
        [self initModalNavigationController];
    }
    [self.modalNavigationViewController setViewControllers:@[accountSwitcher]];
    
    [self presentViewController:self.modalNavigationViewController animated:YES completion:nil];
}

-(void)showSettings {

    // Settings
    SettingsViewController_iPad *iPadSettingViewController = [[[SettingsViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    iPadSettingViewController.settingsDelegate = self;
    [iPadSettingViewController startRetrieve];
    
    if (self.modalNavigationViewController == nil)
    {
        [self initModalNavigationController];
    }
    
    [self.modalNavigationViewController setViewControllers:@[iPadSettingViewController]];
    [self presentViewController:self.modalNavigationViewController animated:YES completion:nil];
}





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_cellContents count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.clipsToBounds = YES;
        cell.indentationLevel = 1;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        cell.textLabel.shadowOffset = CGSizeMake(0, 2);
        cell.textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
        cell.textLabel.textColor = [UIColor whiteColor];

        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeFeatureAccessory.png"]] autorelease];
        
        // selected background view 
        UIView* bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeMenuFeatureSelectedBg.png"]];
        cell.selectedBackgroundView = bgView;
        [bgView release];
        
        // add bottom line
        UIImage *lineImg = [UIImage imageNamed:@"HomeFeatureSeparator.png"];
        lineImg = [lineImg stretchableImageWithLeftCapWidth:(lineImg.size.width / 2) topCapHeight:0];
        UIImageView *bottomLine = [[UIImageView alloc] initWithImage:lineImg];
        bottomLine.frame = CGRectMake(0, cell.bounds.size.height - lineImg.size.height, cell.bounds.size.width, lineImg.size.height);
        bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [cell addSubview:bottomLine];
        [bottomLine release];
        
    }
    
    if (indexPath.row == 0) {
        // Generate the top separator line for the first cell 
        UIImage *lineImg = [UIImage imageNamed:@"HomeFeatureSeparator.png"];
        lineImg = [lineImg stretchableImageWithLeftCapWidth:(lineImg.size.width / 2) topCapHeight:0];
        UIImageView *topLine = [[UIImageView alloc] initWithImage:lineImg];
        topLine.tag = 999;
        topLine.frame = CGRectMake(0, 0, cell.bounds.size.width, lineImg.size.height);
        [cell addSubview:topLine];
        [topLine release];
        
    } else {
        [[cell viewWithTag:999] removeFromSuperview];
        
    }
    
	cell.textLabel.text = _cellContents[indexPath.row][kCellText];
	cell.imageView.image = _cellContents[indexPath.row][kCellImage];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _intIndex = indexPath.row;
    NSInteger index = _intIndex;
    
    if(!_isCompatibleWithSocial){
        index += 1;
    }
    switch (index) {
        case EXO_ACTIVITY_STREAM_ROW: {
            //Activity Stream
            ActivityStreamBrowseViewController_iPad *activityViewController = [[[ActivityStreamBrowseViewController_iPad alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPad" bundle:nil] autorelease];
            
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:activityViewController invokeByController:self isStackStartView:TRUE];
            
            break;
        }
        case EXO_DOCUMENTS_ROW: {
            // files
            // Same code is used at the end of the method doneWithSettings
            // Hence it's put in the separate method initAndSelectDocumentsViewController
            [self initAndSelectDocumentsViewController];
            
            break;
        }
        case EXO_DASHBOARD_ROW: {
            // dashboard
            DashboardViewController_iPad *dashboardViewController_iPad = [[[DashboardViewController_iPad alloc] initWithNibName:@"DashboardViewController_iPad" bundle:nil] autorelease];
            
            
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:dashboardViewController_iPad invokeByController:self isStackStartView:TRUE];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[_cellContents release];
    [_tableView release];
    [_userProfileViewController release];
    self.modalNavigationViewController = nil;
    self.accountSwitcherButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    [super dealloc];
}

- (void)initAndSelectDocumentsViewController {
    NSIndexPath *selectedIndex = _tableView.indexPathForSelectedRow;
    DocumentsViewController_iPad *documentsViewController = [[[DocumentsViewController_iPad alloc] initWithNibName:@"DocumentsViewController_iPad" bundle:nil] autorelease];
    documentsViewController.isRoot = YES;
    documentsViewController.title = _cellContents[selectedIndex.row][kCellText];
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:documentsViewController invokeByController:self isStackStartView:TRUE];
}

#pragma mark - Settings Delegate methods

-(void)doneWithSettings {
    // We have to display/hide the account switcher button if the number of accounts is more/less than 2
    [self setAccountSwitcherButtonVisibility];
    // Reload the Documents page if it is currently selected
    NSIndexPath *selectedIndex = _tableView.indexPathForSelectedRow;
    if (selectedIndex.row == EXO_DOCUMENTS_ROW)
        [self initAndSelectDocumentsViewController];
    
    if (self.modalNavigationViewController != nil)
        [self.modalNavigationViewController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark Account Switcher delegate method
- (void)didCloseAccountSwitcher {
    if (self.modalNavigationViewController != nil)
        [self.modalNavigationViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - change language management

- (void)updateLabelsWithNewLanguage{
    // Save the selected menu
    NSIndexPath *selectedIndex = _tableView.indexPathForSelectedRow;
    // Remove the menu items...
    [_cellContents removeAllObjects];
    // ...and add them again, the new language is automatically applied
    if(_isCompatibleWithSocial){
        [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellText: Localize(@"News")}];
    }
    [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"DocumentIpadIcon.png"], kCellText: Localize(@"Documents")}];
    [_cellContents addObject:@{kCellImage: [UIImage imageNamed:@"DashboardIpadIcon.png"], kCellText: Localize(@"Dashboard")}];
    // Redraw the table
    [_tableView reloadData];
    // Reselect the previously selected menu item
    [_tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end


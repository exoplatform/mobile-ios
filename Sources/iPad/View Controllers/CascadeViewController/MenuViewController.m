//
//  MenuViewController.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "MenuViewController.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "AppDelegate_iPad.h"
#import "LanguageHelper.h"
#import "UserProfileViewController.h"
#import "ActivityStreamBrowseViewController_iPad.h"
#import "DocumentsViewController_iPad.h"
#import "DashboardViewController_iPad.h"


#define kCellText @"CellText"
#define kCellImage @"CellImage"

#define kHeightForFooter 60.0
#define kMenuViewHeaderHeight 70.0

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

@interface MenuViewController () {
    CGRect _viewFrame;
}

@end

@implementation MenuViewController

@synthesize userProfileViewController = _userProfileViewController;

@synthesize tableView = _tableView, isCompatibleWithSocial = _isCompatibleWithSocial;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial {
    self = [super init];
    if (self) {
        _viewFrame = frame;
        _isCompatibleWithSocial = compatibleWithSocial;
		_cellContents = [[NSMutableArray alloc] init];

        if(_isCompatibleWithSocial){
            [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellImage, Localize(@"News"), kCellText, nil]];
        }
        [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DocumentIpadIcon.png"], kCellImage, Localize(@"Documents"), kCellText, nil]];
        [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DashboardIpadIcon.png"], kCellImage, Localize(@"Dashboard"), kCellText, nil]];
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

    //Add the footer of the View
    //For Settings and Logout
    UIView *footer = [[[FooterView alloc] initWithFrame:CGRectMake(0,viewBounds.size.height - kHeightForFooter,viewBounds.size.width, kHeightForFooter)] autorelease];
    footer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:footer];
    // Create the button
    UIButton *buttonLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLogout.frame = CGRectMake(15, 10, 39, 42);
    buttonLogout.showsTouchWhenHighlighted = YES;
    
    // Now load the image and create the image view
    UIImage *image = [UIImage imageNamed:@"Ipad_logout.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,39,42)];
    [imageView setImage:image];
    
    [buttonLogout addTarget:[AppDelegate_iPad instance] action:@selector(backToAuthenticate) forControlEvents:UIControlEventTouchUpInside];
    
    
    [buttonLogout addSubview:imageView];
    
    [footer addSubview:buttonLogout];
    
    
    // Create the button
    UIButton *buttonSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSettings.frame = CGRectMake(152, 12, 39, 42);
    buttonSettings.showsTouchWhenHighlighted = YES;
    
    // Now load the image and create the image view
    UIImage *imageSettings = [UIImage imageNamed:@"Ipad_setting.png"];
    UIImageView *imageViewSettings = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,39,42)];
    [imageViewSettings setImage:imageSettings];
    
    [buttonSettings addSubview:imageViewSettings];
    [buttonSettings addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footer addSubview:buttonSettings];
    
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
    [footer addSubview:topLine];
    [topLine release];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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


-(void)showSettings {

    // Settings
    SettingsViewController_iPad *iPadSettingViewController = [[[SettingsViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    iPadSettingViewController.settingsDelegate = self;
   
    [iPadSettingViewController startRetrieve];
    if (_modalNavigationSettingViewController == nil) 
    {
        _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:iPadSettingViewController];
        _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
    }
    [self presentModalViewController:_modalNavigationSettingViewController animated:YES];

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
    
	cell.textLabel.text = [[_cellContents objectAtIndex:indexPath.row] objectForKey:kCellText];
	cell.imageView.image = [[_cellContents objectAtIndex:indexPath.row] objectForKey:kCellImage];
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
        case 0: {
            //Activity Stream
            ActivityStreamBrowseViewController_iPad *activityViewController = [[[ActivityStreamBrowseViewController_iPad alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPad" bundle:nil] autorelease];
            
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:activityViewController invokeByController:self isStackStartView:TRUE];
            
            break;
        }
        case 1: {
            // files
            DocumentsViewController_iPad *documentsViewController = [[[DocumentsViewController_iPad alloc] initWithNibName:@"DocumentsViewController_iPad" bundle:nil] autorelease];
            documentsViewController.isRoot = YES;
            documentsViewController.title = [[_cellContents objectAtIndex:indexPath.row] objectForKey:kCellText];
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:documentsViewController invokeByController:self isStackStartView:TRUE];
            
            break;
        }
        case 2: {
            // dashboard
            DashboardViewController_iPad *dashboardViewController_iPad = [[[DashboardViewController_iPad alloc] initWithNibName:@"DashboardViewController_iPad" bundle:nil] autorelease];
            
            
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:dashboardViewController_iPad invokeByController:self isStackStartView:TRUE];
            break;
        }
        default:
            break;
    }
    
    
    //DataViewController *dataViewController = [[DataViewController alloc] initWithFrame:CGRectMake(0, 0, 477, self.view.frame.size.height) squareCorners:NO];
	//[[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:dataViewController invokeByController:self isStackStartView:TRUE];
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
    [_modalNavigationSettingViewController release];
    
    [super dealloc];
}

#pragma mark - Settings Delegate methods

-(void)doneWithSettings {
    //TODO Localize this strings
    [_cellContents removeAllObjects];
    if(_isCompatibleWithSocial){
        [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellImage, Localize(@"News"), kCellText, nil]];
    }
    [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DocumentIpadIcon.png"], kCellImage, Localize(@"Documents"), kCellText, nil]];
    [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DashboardIpadIcon.png"], kCellImage, Localize(@"Dashboard"), kCellText, nil]];
    //[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ChatIPadIcon.png"], kCellImage, Localize(@"Chat"), kCellText, nil]];
    NSIndexPath *selectedIndex = _tableView.indexPathForSelectedRow;
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [_modalNavigationSettingViewController dismissModalViewControllerAnimated:YES];
}


@end


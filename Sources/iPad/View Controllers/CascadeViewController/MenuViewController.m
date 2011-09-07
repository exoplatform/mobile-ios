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
#import "MenuTableViewCell.h"
#import "MenuHeaderView.h"
#import "MenuWatermarkFooter.h"
#import "AppDelegate_iPad.h"

#define kCellText @"CellText"
#define kCellImage @"CellImage"

#define kHeightForFooter 60

@implementation MenuViewController

@synthesize tableView = _tableView, isCompatibleWithSocial = _isCompatibleWithSocial;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial {
    self = [super init];
    if (self) {
		[self.view setFrame:frame];
        
        self.view.backgroundColor = [UIColor clearColor]; 
        
        _isCompatibleWithSocial = compatibleWithSocial;
		
		_menuHeader = [[MenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 200, 70) andTitleImage:[UIImage imageNamed:@"eXoLogoNavigationBariPhone.png"]];
		_menuHeader.imageView.image = [UIImage imageNamed:@"eXoLogoNavigationBariPhone@2x.png"];
		_menuHeader.textLabel.text = @"everywhere, anytime";
		
		_cellContents = [[NSMutableArray alloc] init];
        
        //TODO Localize this strings
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ChatIPadIcon.png"], kCellImage, NSLocalizedString(@"Chat",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DashboardIpadIcon.png"], kCellImage, NSLocalizedString(@"Dashboard",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DocumentIpadIcon.png"], kCellImage, NSLocalizedString(@"Documents",@""), kCellText, nil]];
        if(_isCompatibleWithSocial)
            [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellImage, NSLocalizedString(@"Activity Stream",@""), kCellText, nil]];
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor clearColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        MenuWatermarkFooter *footerView = [[[MenuWatermarkFooter alloc] initWithFrame:CGRectMake(0, 0, 200, 80)] autorelease];
        
		_tableView.tableFooterView = footerView;
        
        [self.view addSubview:_tableView];
        
        
        
        //Add the footer of the View
        //For Settings and Logout
        _footer = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-kHeightForFooter,self.view.frame.size.width,kHeightForFooter)];
        [self.view addSubview:_footer];
        
        // Create the button
        UIButton *buttonLogout = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonLogout.frame = CGRectMake(15, 10, 39, 42);
        buttonLogout.showsTouchWhenHighlighted = YES;
        
        // Now load the image and create the image view
        UIImage *image = [UIImage imageNamed:@"Ipad_logout.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,39,42)];
        [imageView setImage:image];
        
        //// Create the label and set its text
        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2,3,39,42)];
        //[label setText:@"Settings"];
        
        // Put it all together
        //[button addSubview:label];
        
        [buttonLogout addTarget:[AppDelegate_iPad instance] action:@selector(backToAuthenticate) forControlEvents:UIControlEventTouchUpInside];

        
        [buttonLogout addSubview:imageView];
        
        [_footer addSubview:buttonLogout];
        
        
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

        
        [_footer addSubview:buttonSettings];
        
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 1)];
		topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
		[_footer addSubview:topLine];
		[topLine release];
        
        
        //Button for settings 
        //UIButton *roundedButtonType = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        //[roundedButtonType setImageEdgeInsets:UIEdgeInsetsMake(-10.00, 5.00, -5.00, 0.00)];
        //[roundedButtonType setImage:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ipad_logout.png"]] forState:UIControlStateNormal] ;
        //roundedButtonType.frame = CGRectMake(6, 10, roundedButtonType.frame.size.width,  roundedButtonType.frame.size.height);
        
        //[_footer addSubview:roundedButtonType];
        
        
        
        
        _intIndex = -1;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setPositionsForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    _footer.frame = CGRectMake(0,self.view.frame.size.height-kHeightForFooter,self.view.frame.size.width,kHeightForFooter);
    if (_messengerViewController) 
    {
        [_messengerViewController changeOrientation:interfaceOrientation];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark MenuManagement methods


-(void)showSettings {

    // files
    if (_iPadSettingViewController == nil)
    {
        _iPadSettingViewController = [[iPadSettingViewController alloc] initWithNibName:@"iPadSettingViewController" bundle:nil];
        [_iPadSettingViewController setDelegate:_delegate];
    }    
    
    if (_modalNavigationSettingViewController == nil) 
    {
        _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:_iPadSettingViewController];
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
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[_cellContents objectAtIndex:indexPath.row] objectForKey:kCellText];
	cell.imageView.image = [[_cellContents objectAtIndex:indexPath.row] objectForKey:kCellImage];
	
	//cell.glowView.hidden = indexPath.row != 3;
    
    if (indexPath.row == _intIndex) 
    {
        cell.glowView.hidden = NO;
    }
    else
    {
        cell.glowView.hidden = YES;
    }

    return cell;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kMenuTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return _menuHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _intIndex = indexPath.row;

    [tableView reloadData];
    
    [_messengerViewController disconnect];
    
    switch (indexPath.row) {
        case 0:
            // messenger
            if (_messengerViewController == nil) 
            {
                _messengerViewController = [[MessengerViewController_iPad alloc] initWithNibName:@"MessengerViewController_iPad" bundle:nil];
            }
            

            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_messengerViewController 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            break;
        case 1:
            // dashboard
            
            if (_dashboardViewController_iPad == nil) 
            {
            _dashboardViewController_iPad = [[DashboardViewController_iPad alloc] initWithNibName:@"DashboardViewController_iPad" bundle:nil];
            }
            
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_dashboardViewController_iPad 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            break;
        case 2:
            // files
            _filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
            [_filesViewController setDelegate:_delegate];
            [_filesViewController initWithRootDirectory:_isCompatibleWithSocial];
            [_filesViewController getPersonalDriveContent:_filesViewController._currenteXoFile];
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_filesViewController 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            break;
        
                
        case 3:
            //Activity Stream
            _activityViewController = [[ActivityStreamBrowseViewController_iPad alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPad" bundle:nil];

            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_activityViewController 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            
            
            break;
            
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
	[_menuHeader release];
	[_cellContents release];
    [super dealloc];
}


@end


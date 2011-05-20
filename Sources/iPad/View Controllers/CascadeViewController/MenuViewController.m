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

@implementation MenuViewController
@synthesize tableView = _tableView;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
		[self.view setFrame:frame];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgPatternIPad.png"]]];
		
		_menuHeader = [[MenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
		_menuHeader.imageView.image = [UIImage imageNamed:@"eXoLogoNavigationBariPhone@2x.png"];
		_menuHeader.textLabel.text = @"";
		
		_cellContents = [[NSMutableArray alloc] init];
        
        /*
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"08-chat.png"], kCellImage, NSLocalizedString(@"Chat",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"83-calendar.png"], kCellImage, NSLocalizedString(@"Dashboard",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"179-notepad.png"], kCellImage, NSLocalizedString(@"Files",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"18-envelope.png"], kCellImage, NSLocalizedString(@"Social",@""), kCellText, nil]];
         */
        
        [_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ActivityStreamIpadIcon.png"], kCellImage, NSLocalizedString(@"Activities Stream",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"ChatIPadIcon.png"], kCellImage, NSLocalizedString(@"Chat",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DocumentIpadIcon.png"], kCellImage, NSLocalizedString(@"Documents",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"DashboardIpadIcon.png"], kCellImage, NSLocalizedString(@"Dashboard",@""), kCellText, nil]];
		[_cellContents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"SettingsIpadIcon.png"], kCellImage, NSLocalizedString(@"Settings",@""), kCellText, nil]];
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor clearColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_tableView.tableFooterView = [[[MenuWatermarkFooter alloc] initWithFrame:CGRectMake(0, 0, 200, 80)] autorelease];
		[self.view addSubview:_tableView];
        
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
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
    
    switch (indexPath.row) {
        case 0:
            // chat
            if (_messengerViewController == nil) 
            {
                _messengerViewController = [[MessengerViewController alloc] initWithNibName:@"MessengerViewController" bundle:nil];
                //[_messengerViewController setDelegate:self];
                
            }
            
            if (_nvMessengerViewController == nil) 
            {
                _nvMessengerViewController = [[UINavigationController alloc] initWithRootViewController:_messengerViewController];
            }
            
            [_messengerViewController initMessengerParameters];
            [_messengerViewController._tblvUsers reloadData];
            
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
            //[_dashboardViewController_iPad setDelegate:self];
            _conn = [[Connection alloc] init];
            _dashboardViewController_iPad._arrTabs = [_conn getItemsInDashboard];

            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_dashboardViewController_iPad 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            break;
        case 2:
            // files
            _filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
            //[_filesViewController setDelegate:self];
            [_filesViewController initWithRootDirectory];
            [_filesViewController getPersonalDriveContent:_filesViewController._currenteXoFile];
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_filesViewController 
                                                                                   invokeByController:self 
                                                                                     isStackStartView:TRUE];
            break;
        
        case 3:
           break;
            
        case 4:
            // files
            if (_iPadSettingViewController == nil)
            {
                _iPadSettingViewController = [[iPadSettingViewController alloc] initWithNibName:@"iPadSettingViewController" bundle:nil];
                //[_iPadSettingViewController setDelegate:self];
            }    
            
            if (_modalNavigationSettingViewController == nil) 
            {
                _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:_iPadSettingViewController];
                _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                
            }
            [self presentModalViewController:_modalNavigationSettingViewController animated:YES];
            
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


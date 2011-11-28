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





@interface HomeSidebarViewController_iPhone (UITableView) <JTTableViewDatasourceDelegate>
@end


@implementation HomeSidebarViewController_iPhone

@synthesize revealView = _revealView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    // Create a default style RevealSidebarView
    _revealView = [[JTRevealSidebarView defaultViewWithFrame:self.view.bounds] retain];
    
    // Setup a view to be the rootView of the sidebar
    UITableView *tableView = [[[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds] autorelease];
    tableView.backgroundColor = [UIColor colorWithRed:84./255 green:84./255 blue:84./255 alpha:1.];
    tableView.delegate   = _datasource;
    tableView.dataSource = _datasource;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_revealView.sidebarView pushView:tableView animated:NO];
    
    //Add the ActivityStream as main view
    ActivityStreamBrowseViewController_iPhone* _activityStreamBrowseViewController_iPhone = [[ActivityStreamBrowseViewController_iPhone alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPhone" bundle:nil];
    
    
    [_revealView.contentView setRootView:_activityStreamBrowseViewController_iPhone.view];
    [_activityStreamBrowseViewController_iPhone release];
    [_revealView revealSidebar:NO];
    
    
    
    //Add the footer of the View
    //For Settings and Logout
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width,60)];
    
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
    UIImage *barButtonImage = [UIImage imageNamed:@"MenuButton.png"];
    tmpButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
    [tmpButton setImage:[UIImage imageNamed:@"MenuButton.png"] forState:UIControlStateNormal];
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
    //    NSArray *listItems = _launcherView.pages;
    //    for (TTLauncherItem *item in listItems){
    //        
    //    }
    //[self loadView];
    
    //[self.revealView.contentView setNavigationBarHidden:NO animated:YES];
    //[(UITableView *)[_revealView.sidebarView topView] reloadData];
    [(UITableView *)[_revealView.sidebarView topView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Helper

- (void)simulateDidSucceedFetchingDatasource:(JTTableViewDatasource *)datasource {
    NSString *url = [datasource.sourceInfo objectForKey:@"url"];
    if ([url isEqualToString:@"root"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObjects:
          [JTTableViewCellModalSimpleType modalWithTitle:Localize(@"News") type:eXoActivityStream],
          [JTTableViewCellModalSimpleType modalWithTitle:Localize(@"Documents") type:eXoDocuments],
          [JTTableViewCellModalSimpleType modalWithTitle:Localize(@"Dashboard") type:eXoDashboard],
          [JTTableViewCellModalSimpleType modalWithTitle:Localize(@"Settings") type:eXoSettings],

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
            bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
            cell.selectedBackgroundView = bgView;
            [bgView release];
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
            cell.textLabel.shadowOffset = CGSizeMake(0, 2);
            cell.textLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
            
            cell.imageView.contentMode = UIViewContentModeCenter;
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 1)];
            topLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.25];
            [cell.textLabel.superview addSubview:topLine];
            [topLine release];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kMenuTableViewCellHeight, 270, 1)];
            bottomLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
            [cell.textLabel.superview addSubview:bottomLine];
            [bottomLine release];
            
            cell.textLabel.textColor = [UIColor whiteColor]; 


            /*
            cell.textLabel.textColor = [UIColor whiteColor]; 
            cell.textLabel.shadowColor = [UIColor darkGrayColor];
            cell.textLabel.shadowOffset = CGSizeMake(0.,1.);
            cell.textLabel.font = [UIFont systemFontOfSize:16.];*/
        }
        cell.textLabel.text = [(id <JTTableViewCellModal>)object title];
        
        
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
                
                
                [_revealView.contentView setRootView:_activityStreamBrowseViewController_iPhone.view];
                //[_activityStreamBrowseViewController_iPhone release];
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
    [(UITableView *)[_revealView.sidebarView topView] reloadData];
    [(UITableView *)[_revealView.sidebarView topView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowType inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}



@end

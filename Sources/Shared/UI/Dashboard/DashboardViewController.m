//
//  DashboardViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardProxy_old.h"
#import "DashboardProxy.h"
#import "LanguageHelper.h"
#import "Gadget.h"
#import "EmptyView.h"
#import "NSString+HTML.h"
#import <QuartzCore/QuartzCore.h>
#import "GadgetItem.h"
#import "DashboardTableViewCell.h"

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]
#define kHeightForSectionHeader 40

@interface DashboardViewController ()

@property (nonatomic, retain) NSDate  *dateOfLastUpdate;

@end


@implementation DashboardViewController


@synthesize _arrDashboard;
@synthesize dateOfLastUpdate = _dateOfLastUpdate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom in itialization
        
        //Intialize the boolean to know if the content is empty or not
        _isEmpty = NO;
        
        //Initialize the error message to nil
        _errorForRetrievingDashboard = nil;
    }
    return self;
}

- (void)dealloc
{
    [_arrDashboard release];
	_arrDashboard = nil;
    
    _tblGadgets = nil;
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    [_dateOfLastUpdate release];
    _dateOfLastUpdate = nil;
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    [_dashboardProxy release];
    _dashboardProxy = nil;
    
    [_errorForRetrievingDashboard release];
    _errorForRetrievingDashboard = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Reset the  content of the view 
    [_arrDashboard release];
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Dashboard");
    
    //Add the loader
	[self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    
    //Set the background Color of the view
    //UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    //background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    //_tblGadgets.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    //[background release];
    _tblGadgets.backgroundView = nil;
    _tblGadgets.backgroundColor = [UIColor clearColor];
        
    //Start the loader
    [self displayHudLoader];
    
    //Start the request to retrieve datas
    _dashboardProxy = [[DashboardProxy alloc] initWithDelegate:self];
    [_dashboardProxy retrieveDashboards];
    
    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblGadgets.bounds.size.height, self.view.frame.size.width, _tblGadgets.bounds.size.height)];
		view.delegate = self;
		[_tblGadgets addSubview:view];
		_refreshHeaderView = view;
		[view release];
        _reloading = FALSE;
        
	}
    
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
    // Observe the change language notif to update the labels
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithNewLanguage) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
}

- (void)viewDidUnload
{
    [_refreshHeaderView release]; _refreshHeaderView =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma UIHelper methods


// Empty State
-(void)emptyState {
    if (_isEmpty) {
        //add empty view to the view 
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoGadgets.png" andContent:Localize(@"NoGadget")];
        emptyView.tag = TAG_EMPTY;
        [self.view insertSubview:emptyView belowSubview:_tblGadgets];
        [emptyView release];        
    } else {
        [[self.view viewWithTag:TAG_EMPTY] removeFromSuperview];
    }
}


-(void)errorState {
    //disable scroll in tableview
    _tblGadgets.scrollEnabled = NO;
    
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoGadgets.png" andContent:Localize(@"NoGadget")];
    [self.view insertSubview:emptyView aboveSubview:_tblGadgets];
    [emptyView release];
}



- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 85; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 70;
    }
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
    
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    if (theSize.height < 30) 
    {
        fHeight = 60;
    }
    else
    {
        fHeight = 30 + theSize.height;
    }
    
    return fHeight;
}

- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(25.0, 11.0, width, kHeightForSectionHeader);
}

- (UITableView*)tblGadgets{
    return _tblGadgets;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    //Display the empty screen if data is empty 
    [self emptyState];
    return [_arrDashboard count];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
    // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 10.0, _tblGadgets.frame.size.width-5, kHeightForSectionHeader)];
	
	// create the label object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    headerLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    headerLabel.shadowOffset = CGSizeMake(0,1);
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.text = [(DashboardItem *)[_arrDashboard objectAtIndex:section] label];
    
    CGSize theSize = [headerLabel.text sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(_tblGadgets.frame.size.width-5, CGFLOAT_MAX) 
                                      lineBreakMode:UILineBreakModeWordWrap];
    headerLabel.frame = [self rectOfHeader:theSize.width+10];
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"DashboardTabBackground.png"];
    UIImageView *imgVBackground = [[UIImageView alloc] initWithImage:[imgForSection stretchableImageWithLeftCapWidth:10 topCapHeight:7]];
    imgVBackground.frame = CGRectMake(headerLabel.frame.origin.x - 10, 16.0, theSize.width + 30, kHeightForSectionHeader-15);
    
	[customView addSubview:imgVBackground];
    [imgVBackground release];
    
    [customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 
    
    return [self getHeighSizeForTableView:tableView andText:gadgetTmp.gadgetDescription];

}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[(DashboardItem*)[_arrDashboard objectAtIndex:section] arrayOfGadgets] count] ;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString* kCellIdentifier = @"Cell";
	
    //We dequeue a cell
	DashboardTableViewCell *cell = (DashboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell==nil) 
    { 
        GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DashboardTableViewCell" owner:self options:nil];
        cell = (DashboardTableViewCell *)[nib objectAtIndex:0];
        //Not found, so create a new one
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell configureCell:gadgetTmp.gadgetName description:gadgetTmp.gadgetDescription icon:gadgetTmp.gadgetIcon];
        
        [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
        
    }
    
	return cell;

}



#pragma mark - DashboardProxy_old delegates methods 
//Method called when all dashboards has been retrieved
- (void)dashboardProxyDidFinish:(DashboardProxy *)proxy {
    //Hide the loader
    [self hideLoader:YES];
    
    _reloading = NO;
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblGadgets];
    
    
    _reloading = NO;
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblGadgets];
    
    
    NSMutableArray *dashboards = [[NSMutableArray alloc] init];
    for (DashboardItem* item in proxy.arrayOfDashboards) {
        if ([item.arrayOfGadgets count] > 0)
            [dashboards addObject:item];
    }
    
    _arrDashboard = (NSArray *)dashboards;
    
    _isEmpty = YES;
    
    //Check if there is data to display
    if ([_arrDashboard count] >0)
        _isEmpty = NO;
    
    //Check is we encountered an error for retreiving one dashboard
    if (_errorForRetrievingDashboard != nil) {
        NSString *alertMessage = [NSString stringWithFormat:@"%@: %@, %@",Localize(@"Dashboard"),_errorForRetrievingDashboard,Localize(@"GadgetsCannotBeRetrieved")];
        
        //Display an UIAlert to the user
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                             message:alertMessage 
                                                            delegate:self 
                                                   cancelButtonTitle:Localize(@"OK") 
                                                   otherButtonTitles:nil] autorelease];
        
        [alertView show];
    }
        
    
    
    
    [_tblGadgets reloadData];
}

//Error method called when the dahsboard call has failed
- (void)dashboardProxy:(DashboardProxy *)proxy didFailWithError:(NSError *)error {
    [self hideLoader:NO];
    [self errorState];
    
    
    //Display an UIAlert to the user
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                         message:Localize(@"DashboardsCannotBeRetrieved") 
                                                        delegate:self 
                                               cancelButtonTitle:Localize(@"OK") 
                                               otherButtonTitles:nil] autorelease];
    
    [alertView show];
}

//Error to load gadgets from one specific dashboard
- (void)dashboardProxyDidFailForDashboard:(DashboardItem *)dashboard {
    //If we meet a problem to retrieve one specific dahsboard/
    //We manage the error by storing the DahsboardName
    
    //First case, the first dashboard can not be retrieved
    if (_errorForRetrievingDashboard == nil) {
        _errorForRetrievingDashboard = [[NSMutableString alloc] initWithFormat:@"%@",dashboard.label];
    } else {
    //Second case, more than one dahsboard can not be retrieved
        [_errorForRetrievingDashboard appendFormat:@", %@",dashboard.label];
    }
    
    
    //Error will be showned to the user after completing the request for all dashboards
}



#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{

    //Start the loader
    [self displayHudLoader];
    
    _reloading = YES;
    
    //Start the request to retrieve datas
    [_dashboardProxy retrieveDashboards];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _dateOfLastUpdate; // should return date data source was last changed
	
}

#pragma mark - language changing management
- (void)updateLabelsWithNewLanguage {
    // update label for emptyview
    [(EmptyView *)[self.view viewWithTag:TAG_EMPTY] setLabelContent:Localize(@"NoGadget")];
    
    [super updateLabelsWithNewLanguage];
}

@end

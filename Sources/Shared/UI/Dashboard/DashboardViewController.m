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

@interface DashboardViewController (PrivateMethods)
- (void)showLoader;
- (void)hideLoader;
@end


@implementation DashboardViewController


@synthesize _arrDashboard;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom in itialization
        
        //Intialize the boolean to know if the content is empty or not
        _isEmpty = NO;
    }
    return self;
}

- (void)dealloc
{
    [_arrDashboard release];
	_arrDashboard = nil;
    
    _tblGadgets = nil;
    
    //Loader
    [_hudDashboard release];
    _hudDashboard = nil;
    
    [_dashboardProxy release];
    _dashboardProxy = nil;
    
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
    
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"Dashboard");
    
    //Add the loader
    _hudDashboard = [[ATMHud alloc] initWithDelegate:self];
    [_hudDashboard setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudDashboard.view];
    
    //Set the background Color of the view
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tblGadgets.backgroundView = background;
    [background release];
        
    //Start the loader
    [self showLoader];
    
    //Start the request to retrieve datas
    _dashboardProxy = [[DashboardProxy alloc] initWithDelegate:self];
    [_dashboardProxy retrieveDashboards];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma UIHelper methods


// Empty State
-(void)emptyState {
    //disable scroll in tableview
    _tblGadgets.scrollEnabled = NO;
    
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoGadgets.png" andContent:Localize(@"NoGadget")];
    [self.view insertSubview:emptyView aboveSubview:_tblGadgets];
    [emptyView release];
}


-(void)errorState {
    //disable scroll in tableview
    _tblGadgets.scrollEnabled = NO;
    
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoGadgets.png" andContent:Localize(@"NoGadgetError")];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    //Display the empty screen if data
    if(_isEmpty) {
        [self emptyState];
        return 0;
    }
    
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
    headerLabel.frame = [self rectOfHeader:theSize.width];
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"DashboardTabBackground.png"];
    UIImageView *imgVBackground = [[UIImageView alloc] initWithImage:[imgForSection stretchableImageWithLeftCapWidth:5 topCapHeight:7]];
    imgVBackground.frame = CGRectMake(headerLabel.frame.origin.x - 10, 16.0, theSize.width + 20, kHeightForSectionHeader-15);
    
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
    [self hideLoader];
    
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
    
    [_tblGadgets reloadData];
}

//Error method called when the dahsboard call has failed
- (void)dashboardProxy:(DashboardProxy *)proxy didFailWithError:(NSError *)error {
    [_hudDashboard hide];
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

    
    NSString *alertMessage = [NSString stringWithFormat:@"%@: %@, %@",Localize(@"Dashboard"),dashboard.label,Localize(@"GadgetsCannotBeRetrieved")];
    
    //Display an UIAlert to the user
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                         message:alertMessage 
                                                        delegate:self 
                                               cancelButtonTitle:Localize(@"OK") 
                                               otherButtonTitles:nil] autorelease];
    
    [alertView show];
    
    NSLog(@"arrDashboard %@",_arrDashboard);
}



#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoader {
    [self setHudPosition];
    [_hudDashboard setCaption:Localize(@"LoadingYourDashboards")];
    [_hudDashboard setActivity:YES];
    [_hudDashboard show];
}


- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    [self setHudPosition];
    [_hudDashboard setCaption:Localize(@"DashboardsLoaded")];
    [_hudDashboard setActivity:NO];
    [_hudDashboard setImage:[UIImage imageNamed:@"19-check"]];
    [_hudDashboard update];
    [_hudDashboard hideAfter:0.5];
}





@end

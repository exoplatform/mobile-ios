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
#import <QuartzCore/QuartzCore.h>

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
    
    [_tblGadgets release];
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

- (void)customizeAvatarDecorations:(UIImageView *)_imgvAvatar{
    //Add the CornerRadius
    [[_imgvAvatar layer] setCornerRadius:6.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    
    //Add the inner shadow
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];
}


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 60;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[(DashboardItem*)[_arrDashboard objectAtIndex:section] arrayOfGadgets] count] ;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	return nil;
}



#pragma mark - DashboardProxy_old delegates methods 
//Method called when all dashboards has been retrieved
- (void)dashboardProxyDidFinish:(DashboardProxy *)proxy {
    //Hide the loader
    [self hideLoader];

    _arrDashboard = [proxy.arrayOfDashboards copy];

    _isEmpty = YES;
    
    //Check if there is data to display
    for (DashboardItem* item in _arrDashboard) {
        if ([item.arrayOfGadgets count] >0) _isEmpty = NO;
    }
    
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

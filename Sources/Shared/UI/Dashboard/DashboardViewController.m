//
//  DashboardViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DashboardViewController.h"
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


@synthesize _arrTabs;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TODO localize that
        self.title = Localize(@"Dashboard");
    }
    return self;
}

- (void)dealloc
{
    [_arrTabs release];
	_arrTabs = nil;
    
    [_tblGadgets release];
    _tblGadgets = nil;
    
    //Loader
    [_hudDashboard release];
    _hudDashboard = nil;
    
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
    // Do any additional setup after loading the view from its nib.
    
    //Add the loader
    _hudDashboard = [[ATMHud alloc] initWithDelegate:self];
    [_hudDashboard setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudDashboard.view];
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    _tblGadgets.backgroundView = backgroundView;
    [backgroundView release];
    
    [_arrTabs removeLastObject];
    
    //Start the loader
    [self showLoader];
    
    //Set the controlle as delegate of the DashboardProxy
    [DashboardProxy sharedInstance];
    [DashboardProxy sharedInstance].proxyDelegate = self;
    [[DashboardProxy sharedInstance] startRetrievingGadgets];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    BOOL b = NO;
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        b = YES;
    }    
    return b;
}
*/


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = [_arrTabs count]; 
    return n;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 60;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int n = [[[_arrTabs objectAtIndex:section] _arrGadgetsInItem] count];
	return n;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	return nil;
}


// Empty State
-(void)emptyState {
    //disable scroll in tableview
    _tblGadgets.scrollEnabled = NO;
    
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoGadgets.png" andContent:Localize(@"NoGadget")];
    [self.view addSubview:emptyView];
    [emptyView release];
}

#pragma mark - DashboardProxy delegates methods 

//Method called when gadgets has been retrieved
-(void)didFinishLoadingGadgets:(NSMutableArray *)arrGadgets {
    //Start the loader
    [self hideLoader];
    _arrTabs = arrGadgets;
    
    //if no data
    int n = 0;
    for (int i = 0; i < [_arrTabs count]; i++){
        n += [[[_arrTabs objectAtIndex:i] _arrGadgetsInItem] count];
    }
    if (n == 0) {
        [self performSelector:@selector(emptyState) withObject:nil afterDelay:.5];
        return;
    }
    [_tblGadgets reloadData];
}


//Method called when no gadgets has been found or error
-(void)didFailLoadingGadgetsWithError:(NSError *)error {
    //TODO Management error
}

- (void)customizeAvatarDecorations:(UIImageView *)_imgvAvatar{
    //Add the CornerRadius
    [[_imgvAvatar layer] setCornerRadius:6.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:170./255 green:170./255 blue:170./255 alpha:1.].CGColor];
    CGFloat borderWidth = 2.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    
    //Add the inner shadow
    CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];
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

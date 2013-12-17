//
//  DashboardViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPhone.h"
#import "DashboardProxy.h"
#import "GadgetItem.h"
#import "GadgetDisplayViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "UIImage+BlankImage.h"

@implementation DashboardViewController_iPhone

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    //Set the back indicator image to blank image with transparent color
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorTransitionMaskImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}


- (void)viewDidAppear:(BOOL)animated {    
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblGadgets indexPathForSelectedRow];
    if (selection)
        [_tblGadgets deselectRowAtIndexPath:selection animated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 

	GadgetDisplayViewController_iPhone* gadgetDisplayViewController = [[[GadgetDisplayViewController_iPhone alloc] initWithNibAndUrl:@"GadgetDisplayViewController_iPhone"  bundle:nil gadget:gadgetTmp] autorelease];

    //[self.navigationController pushViewController:gadgetDisplayViewController animated:YES];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone  pushViewController:gadgetDisplayViewController animated:YES];
    
}

@end
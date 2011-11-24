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

@implementation DashboardViewController_iPhone



- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 

	GadgetDisplayViewController_iPhone* gadgetDisplayViewController = [[GadgetDisplayViewController_iPhone alloc] initWithNibAndUrl:@"GadgetDisplayViewController_iPhone" 
bundle:nil 
gadget:gadgetTmp];

    //[self.navigationController pushViewController:gadgetDisplayViewController animated:YES];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView pushView:gadgetDisplayViewController.view animated:YES];
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
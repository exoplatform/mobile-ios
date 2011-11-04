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


@implementation DashboardViewController_iPhone


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 

	GadgetDisplayViewController_iPhone* gadgetDisplayViewController = (GadgetDisplayViewController_iPhone *)[[GadgetDisplayViewController alloc] initWithNibAndUrl:@"GadgetDisplayViewController_iPhone" 
bundle:nil 
gadget:gadgetTmp];

    [self.navigationController pushViewController:gadgetDisplayViewController animated:YES];
    [gadgetDisplayViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
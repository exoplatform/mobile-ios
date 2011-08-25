//
//  DashboardViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPhone.h"
#import "DashboardProxy.h"
#import "Gadget.h"
#import "GadgetDisplayViewController.h"



@implementation DashboardViewController_iPhone


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GateInDbItem *gadgetTab = [_arrTabs objectAtIndex:indexPath.section];
	Gadget *gadget = [gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
	
	GadgetDisplayViewController* gadgetDisplayViewController = [[GadgetDisplayViewController alloc] initWithNibAndUrl:@"GadgetDisplayViewController" 
                                                                                                              bundle:nil 
                                                                                                                 url:tmpURL];


	[gadgetDisplayViewController setUrl:tmpURL];

    [self.navigationController pushViewController:gadgetDisplayViewController animated:YES];
}


@end
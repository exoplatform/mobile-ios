//
//  DashboardViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "GadgetDisplayViewController_iPad.h"
#import "Gadget.h"
#import "RootViewController.h"

@implementation DashboardViewController_iPad


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GateInDbItem *gadgetTab = [_arrTabs objectAtIndex:indexPath.section];
	Gadget *gadget = [gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
    
    GadgetDisplayViewController_iPad* gadgetDisplayViewController = [[GadgetDisplayViewController_iPad alloc] initWithNibName:@"GadgetDisplayViewController_iPad" bundle:nil];
    
    [gadgetDisplayViewController setUrl:tmpURL];
    
    // push the gadgets
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:gadgetDisplayViewController invokeByController:self isStackStartView:FALSE];
    
    

    
}

@end

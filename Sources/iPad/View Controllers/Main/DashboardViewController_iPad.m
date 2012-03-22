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
#import "GadgetItem.h"
#import "DashboardProxy.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"

@implementation DashboardViewController_iPad

#define kHeightForSectionHeader 40

-(void)viewDidLoad {
    [super viewDidLoad];
    _navigation.topItem.title = Localize(@"Dashboard");
}


- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(50.0, 11.0, width, kHeightForSectionHeader);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 

    
    GadgetDisplayViewController_iPad* gadgetDisplayViewController = [[GadgetDisplayViewController_iPad alloc] initWithNibAndUrl:@"GadgetDisplayViewController_iPad" 
          bundle:nil                                                                                                                                                             gadget:gadgetTmp];
    
    // push the gadgets
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:gadgetDisplayViewController invokeByController:self isStackStartView:FALSE];

}


- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}




@end

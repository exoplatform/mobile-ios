//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "DashboardViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "GadgetDisplayViewController_iPad.h"
#import "GadgetItem.h"
#import "DashboardProxy.h"
#import "RootViewController.h"
#import "ExoStackScrollViewController.h"
#import "LanguageHelper.h"
#import "EGOImageView.h"
#import "RoundRectView.h"

@implementation DashboardViewController_iPad

#define kHeightForSectionHeader 40

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    RoundRectView *containerView = (RoundRectView *) [[self.view subviews] objectAtIndex:0];
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    containerView.squareCorners = NO;
    _navigation.topItem.title = Localize(@"Dashboard");
    _navigation.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
}


- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(50.0, 11.0, width, kHeightForSectionHeader);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GadgetItem* gadgetTmp = [[(DashboardItem *)[_arrDashboard objectAtIndex:indexPath.section] arrayOfGadgets] objectAtIndex:indexPath.row]; 

    
    GadgetDisplayViewController_iPad* gadgetDisplayViewController = [[[GadgetDisplayViewController_iPad alloc] initWithNibAndUrl:@"GadgetDisplayViewController_iPad" bundle:nil gadget:gadgetTmp] autorelease];
    
    // push the gadgets
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:gadgetDisplayViewController invokeByController:self isStackStartView:FALSE];

}

- (void)dashboardProxyDidFinish:(DashboardProxy *)proxy {
    [super dashboardProxyDidFinish:proxy];
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:self];
}

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}




@end

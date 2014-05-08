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
    //Set the back indicator image to blank image with transparent color(Using custom function from Category UIImage(Blank))
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

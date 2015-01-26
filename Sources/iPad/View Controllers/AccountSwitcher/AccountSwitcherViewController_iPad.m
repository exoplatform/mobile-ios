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


#import "AccountSwitcherViewController_iPad.h"

#define kAccountSwitcherCellHeight 240.0
#define kAccountSwitcherCellMargin  20.0

@interface AccountSwitcherViewController_iPad ()

@end

@implementation AccountSwitcherViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountSwitcherTableViewCell_iPad"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"CellIdentifierAccount"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kAccountSwitcherCellHeight+kAccountSwitcherCellMargin);
}

- (void)restartAppDelegateAfterLogin:(BOOL)compatibleWithSocial
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHome) withObject:nil afterDelay:1.0];

}

- (void)restartAppDelegateAfterFailure
{
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    [appDelegate performSelector:@selector(backToAuthenticate) withObject:nil afterDelay:1.0];
}

@end

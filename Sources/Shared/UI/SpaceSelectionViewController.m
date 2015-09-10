//
// Copyright (C) 2003-2015 eXo Platform SAS.
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


#import "SpaceSelectionViewController.h"
#import "SpaceTableViewCell.h"
@interface SpaceSelectionViewController () {
    NSArray * _mySpaces;
}
@property (nonatomic, retain) NSArray * mySpaces;
@property (nonatomic, retain) NSString * headerTitle;

@end

@implementation SpaceSelectionViewController
@synthesize socialSpaceProxy = _socialSpaceProxy;
@synthesize delegate;
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.socialSpaceProxy = [[SocialSpaceProxy alloc] init];
    self.socialSpaceProxy.delegate = self;
    [self displayHUDLoaderWithMessage:Localize(@"Loading")];
    [self.socialSpaceProxy getMySocialSpaces];
    self.headerTitle = Localize(@"Loading spaces");
    
    self.navigationItem.title = Localize(@"PostActivityTo");
    [self.tableView registerNib:[UINib nibWithNibName:@"SpaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"SpaceTableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void) dealloc {
    self.socialSpaceProxy = nil;
    self.mySpaces = nil;
    self.headerTitle = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return  1;
    if (self.mySpaces)
        return self.mySpaces.count;
    return 0;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.headerTitle;
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"SpaceTableViewCell";
    SpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.prefixLabel.text = @"";
    if (indexPath.section == 0) {
        [cell setSpace:nil];
    } else {
        [cell setSpace:self.mySpaces[indexPath.row]];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SocialSpace * socialSpace = nil;
    if (indexPath.section == 1){
        socialSpace = self.mySpaces[indexPath.row];
    }
    if (delegate && [delegate respondsToSelector:@selector(spaceSelection:didSelectSpace:)]){
        [delegate spaceSelection:self didSelectSpace:socialSpace];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Social Proxy Delegate 

-(void) proxyDidFinishLoading:(SocialProxy *)proxy {
    [self hideLoaderImmediately:YES];
    self.mySpaces = self.socialSpaceProxy.mySpaces;
    if (self.mySpaces.count >0){
        self.headerTitle = Localize(@"My spaces");
    } else {
        self.headerTitle = Localize(@"You didn't join any space");
    }
    [self.tableView reloadData];
}
-(void) proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error {
    [self hideLoaderImmediately:NO];
    NSString * alertMessage = Localize(@"CannotLoadSpace");
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessage delegate:self cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil];
    
    [alertView show];

}


#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Remove the loader
    [self hideLoader:NO];
}

@end

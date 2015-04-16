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

@interface SpaceSelectionViewController () {
    NSArray * _mySpaces;
}
@property (nonatomic, retain) NSArray * mySpaces;
@end

@implementation SpaceSelectionViewController
@synthesize socialSpaceProxy = _socialSpaceProxy;
@synthesize delegate;
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    _socialSpaceProxy = [[SocialSpaceProxy alloc] init];
    _socialSpaceProxy.delegate = self;    
    [_socialSpaceProxy getMySocialSpaces];
    
    self.navigationItem.title = Localize(@"Post Activity To");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return  1;
    if (_mySpaces)
        return _mySpaces.count;
    return 0;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return Localize(@"Spaces");
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = @"SpaceTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = Localize(@"Public");
    } else {
        SocialSpace * socicalSpace = _mySpaces[indexPath.row];
        cell.textLabel.text = socicalSpace.displayName;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SocialSpace * socicalSpace = nil;
    if (indexPath.section == 1){
        socicalSpace = _mySpaces[indexPath.row];
    }
    if (delegate && [delegate respondsToSelector:@selector(spaceSelection:DidSelectedSpace:)]){
        [delegate spaceSelection:self DidSelectedSpace:socicalSpace];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Social Proxy Delegate 

-(void) proxyDidFinishLoading:(SocialProxy *)proxy {
    _mySpaces = _socialSpaceProxy.mySpaces;
    [self.tableView reloadData];
}
-(void) proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error {
    
}

@end

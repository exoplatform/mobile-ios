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


#import "SpaceViewController.h"

@interface SpaceViewController () {
    NSMutableArray * _mySpaces;
    NSMutableData * data;
    NSURLConnection * connection;
    
}
@property (nonatomic, retain) NSArray * mySpaces;

@end

@implementation SpaceViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Space selection",nil);
    // init the list of spaces. & call get all space the make request to rest ws.
    _mySpaces = [[NSMutableArray alloc] init];
    if (self.account) {
        [self getAllSpaces];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Get spaces
-(void) getAllSpaces {
    // call asynchrnous request to rest ws to get the list of space. (rest/private/portal/social/spaces/mySpaces/show.json)
    NSString * stringURL = [NSString stringWithFormat:@"%@/%@",self.account.serverURL, BASEURL];
    NSURL * url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

    //set default request timeout = 100 ms.
    [request setTimeoutInterval:100];
    [request setHTTPMethod:@"GET"];
    data = [[NSMutableData alloc] init];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // authentification by challenge: create a credential with user & password.
    if([challenge previousFailureCount] == 0) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.account.userName password:self.account.password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mdata {
    // receive a piece of download object
    [data appendData: mdata];
    
}

// finish download
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (data.length >0){
        NSError * error = nil;
        // convert the JSON to Space object (JSON string --> Dictionary --> Object.
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonObjects) {
            NSArray * spacesDict = [jsonObjects objectForKey:@"spaces"];
            for (NSDictionary * s in spacesDict) {
                SocialSpace * space = [[SocialSpace alloc] init];
                space.avatarUrl = [s objectForKey:@"avatarURL"];
                space.name = [s objectForKey:@"name"];
                space.displayName = [s objectForKey:@"displayName"];
                space.spaceUrl = [s objectForKey:@"spaceURL"];
                space.groupId = [s objectForKey:@"groupId"];
                [_mySpaces addObject:space];
            }
        }
        [self.tableView reloadData];
    } else if (data.length ==0){
    }
    
}
// connection problem
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1st Section has 1 row: "public"
    // 2nd section shows all the spaces in mySpaces list.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return  1;
    if (self.mySpaces)
        return self.mySpaces.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * reuseIdentifier = @"SpaceTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"Public",nil);
    } else {
        SocialSpace * space = _mySpaces[indexPath.row];
        cell.textLabel.text = space.displayName;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // the first section has only one row which is public space.
    
    SocialSpace * socialSpace = nil;
    if (indexPath.section == 1){
        socialSpace = self.mySpaces[indexPath.row];
    }
    if (delegate && [delegate respondsToSelector:@selector(spaceSelection:didSelectSpace:)]) {
        [delegate spaceSelection:self didSelectSpace:socialSpace];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

//
//  PeopleViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "PeopleViewController_iPhone.h"
#import "WeemoContact.h"
#import "ExoWeemoHandler.h"

@interface PeopleViewController_iPhone ()

@end

@implementation PeopleViewController_iPhone
@synthesize people = _people;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //TODO: load connections from Social rest service
    [self initPeopleData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_people release];
}

#pragma mark UITableViewDataSource and UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    WeemoContact *contact = [self.people objectAtIndex:indexPath.row];

    cell.textLabel.text = contact.uid;
    cell.detailTextLabel.text = contact.displayName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeemoContact *contact = [self.people objectAtIndex:indexPath.row];
    [[Weemo instance] createCall:contact.uid];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initPeopleData
{
    WeemoContact *contact1 = [[[WeemoContact alloc] initWithUid:@"paristote" andDisplayName:@"Philippe Aristote"] autorelease];
        
    WeemoContact *contact3 = [[[WeemoContact alloc] initWithUid:@"fdrouet" andDisplayName:@"Frédéric Drouet"] autorelease];
    
    WeemoContact *contact4 = [[[WeemoContact alloc] initWithUid:@"patrice_lamarque" andDisplayName:@"Patrice Lamarque"] autorelease];
    
    WeemoContact *contact5 = [[[WeemoContact alloc] initWithUid:@"benjamin_mestrallet" andDisplayName:@"Benjamin Mestrallet"] autorelease];
    
    self.people = [NSMutableArray arrayWithObjects:contact1, contact3, contact4, contact5, nil];
}
@end

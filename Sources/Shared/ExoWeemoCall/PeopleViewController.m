//
//  PeopleViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "PeopleViewController.h"
#import "WeemoContact.h"
#import "ExoWeemoHandler.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController
@synthesize people = _people;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [_tableView release];
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
    
    cell.textLabel.text = contact.displayName;
    cell.detailTextLabel.text = contact.uid;
    
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
    
    WeemoContact *contact6 = [[[WeemoContact alloc] initWithUid:@"benjamin_paillereau" andDisplayName:@"Benjamin Paillereau"] autorelease];
    
    self.people = [NSMutableArray arrayWithObjects:contact1, contact3, contact4, contact5, contact6, nil];
}

@end

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
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"
#import "ContactDetailViewController.h"
#import "ContactDetailViewController_iPad.h"
#import "RootViewController.h"
#import "ExoStackScrollViewController.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController {
    ContactDetailViewController *contactDetailVC;
}
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
//    [[Weemo instance] createCall:[NSString stringWithFormat:@"weemo%@",contact.uid]];
    BOOL isIpad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    
    
    if(isIpad)
    {
        if(contactDetailVC)
        {
            [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:contactDetailVC];
            
            [contactDetailVC release];
        }
        contactDetailVC = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController_iPad" bundle:nil];
        
        contactDetailVC.uid = contact.uid;
        contactDetailVC.fullName = contact.displayName;

        //get instance of ExoCallViewController which is currently at index 0 of view controllers stack
        UIViewController *exoCallVC = [[self parentViewController] parentViewController];
        
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:contactDetailVC invokeByController:exoCallVC isStackStartView:FALSE];
    
    }
    else
    {
        contactDetailVC = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
        
        contactDetailVC.uid = contact.uid;
        contactDetailVC.fullName = contact.displayName;

        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:contactDetailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initPeopleData
{
    WeemoContact *contact1 = [[[WeemoContact alloc] initWithUid:@"paristote" andDisplayName:@"Philippe Aristote"] autorelease];
    
    WeemoContact *contact3 = [[[WeemoContact alloc] initWithUid:@"fdrouet" andDisplayName:@"Frédéric Drouet"] autorelease];
    
    WeemoContact *contact4 = [[[WeemoContact alloc] initWithUid:@"patrice_lamarque" andDisplayName:@"Patrice Lamarque"] autorelease];
    
    WeemoContact *contact5 = [[[WeemoContact alloc] initWithUid:@"benjamin_mestrallet" andDisplayName:@"Benjamin Mestrallet"] autorelease];
    
    WeemoContact *contact6 = [[[WeemoContact alloc] initWithUid:@"benjamin_paillereau" andDisplayName:@"Benjamin Paillereau"] autorelease];
    WeemoContact *contact7 = [[[WeemoContact alloc] initWithUid:@"vietnq" andDisplayName:@"Quoc Viet"] autorelease];
    
    self.people = [NSMutableArray arrayWithObjects:contact1, contact3, contact4, contact5, contact6,contact7, nil];
}

@end

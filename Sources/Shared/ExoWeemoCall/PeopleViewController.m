//
//  PeopleViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "PeopleViewController.h"
#import "ExoContact.h"
#import "ExoWeemoHandler.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"
#import "ContactDetailViewController.h"
#import "ContactDetailViewController_iPad.h"
#import "RootViewController.h"
#import "ExoStackScrollViewController.h"
#import "ContactCell.h"

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
        self.title = @"Contacts";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigation.topItem.title = @"Contacts";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *contactCellIdentifier = @"ContactCell";
    
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:contactCellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    ExoContact *contact = [self.people objectAtIndex:indexPath.row];
    
    cell.lb_full_name.text = contact.displayName;
    cell.lb_username.text = contact.uid;
    
    NSURL *avatarURL = [NSURL URLWithString:[contact avatarURL]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:avatarURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if([imageData length] > 0)
            {
                cell.avatar.image = [UIImage imageWithData:imageData];
            }
        });
    });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExoContact *contact = [self.people objectAtIndex:indexPath.row];
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
        
        contactDetailVC.contact = contact;

        //get instance of ExoCallViewController which is currently at index 0 of view controllers stack
        UIViewController *exoCallVC = [[self parentViewController] parentViewController];
        
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:contactDetailVC invokeByController:exoCallVC isStackStartView:FALSE];
    
    }
    else
    {
        contactDetailVC = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
        
        contactDetailVC.contact = contact;

        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:contactDetailVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initPeopleData
{
    ExoContact *contact1 = [[[ExoContact alloc] initWithUid:@"paristote" andDisplayName:@"Philippe Aristote"] autorelease];
    
    ExoContact *contact3 = [[[ExoContact alloc] initWithUid:@"fdrouet" andDisplayName:@"Frédéric Drouet"] autorelease];
    
    ExoContact *contact4 = [[[ExoContact alloc] initWithUid:@"patrice_lamarque" andDisplayName:@"Patrice Lamarque"] autorelease];
    
    ExoContact *contact5 = [[[ExoContact alloc] initWithUid:@"benjamin_mestrallet" andDisplayName:@"Benjamin Mestrallet"] autorelease];
    
    ExoContact *contact6 = [[[ExoContact alloc] initWithUid:@"benjamin_paillereau" andDisplayName:@"Benjamin Paillereau"] autorelease];
    ExoContact *contact7 = [[[ExoContact alloc] initWithUid:@"vietnq" andDisplayName:@"Quoc Viet"] autorelease];
    
    self.people = [NSMutableArray arrayWithObjects:contact1, contact3, contact4, contact5, contact6,contact7, nil];
}

@end

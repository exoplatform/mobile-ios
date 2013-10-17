//
//  RecentsTabViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "RecentsTabViewController.h"
#import "CallHistoryManager.h"
#import "CallHistory.h"
#import "UserPreferencesManager.h"

@interface RecentsTabViewController ()

@end

@implementation RecentsTabViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Recents";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_tableView release];
}

#pragma mark UITableViewDataSource, UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [[CallHistoryManager sharedInstance] loadHistory];
    
    history = [CallHistoryManager sharedInstance].history;
    
    return [history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    
    CallHistory *entry = [history objectAtIndex:indexPath.row];
    
    NSString *status = entry.direction == 0 ? @"Incoming" : @"Outcoming";
    NSString *dateString = [NSDateFormatter localizedStringFromDate:entry.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = entry.caller;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@", status, dateString];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil; //disable select cell temporarily
}

@end

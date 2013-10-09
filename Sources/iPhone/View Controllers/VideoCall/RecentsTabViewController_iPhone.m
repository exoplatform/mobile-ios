//
//  RecentsTabViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "RecentsTabViewController_iPhone.h"
#import "CallHistoryManager.h"
#import "CallHistory.h"

@interface RecentsTabViewController_iPhone ()

@end

@implementation RecentsTabViewController_iPhone {
    NSMutableArray *history;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Recents";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[CallHistoryManager sharedInstance] loadHistory];
    history = [CallHistoryManager sharedInstance].history;
}
#pragma mark UITableViewDataSource, UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    CallHistory *entry = [history objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.caller;
    NSString *status = entry.direction;
    NSString *dateString = [NSDateFormatter localizedStringFromDate:entry.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@", status, dateString];
    return cell;
}
@end

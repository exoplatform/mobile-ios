//
//  ServerManagerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerManagerViewController.h"
#import "Configuration.h"
#import "ServerAddingViewController.h"
#import "ServerEditingViewController.h"

static NSString *ServerCellIdentifier = @"ServerIdentifier";
#define kTagForCellSubviewServerNameLabel 444
#define kTagForCellSubviewServerUrlLabel 555

@implementation ServerManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        _arrServerList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_arrServerList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    _arrServerList = [[Configuration sharedInstance] getServerList];
    UIBarButtonItem* bbtnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBbtnAdd)];
    [self.navigationItem setRightBarButtonItem:bbtnAdd];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onBbtnAdd
{
    if (_serverAddingViewController == nil) 
    {
        _serverAddingViewController = [[ServerAddingViewController alloc] initWithNibName:@"ServerAddingViewController" bundle:nil];
        [_serverAddingViewController setDelegate:self];
    }
    if ([self.navigationController.viewControllers containsObject:_serverAddingViewController]) 
    {
        [self.navigationController popToViewController:_serverAddingViewController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:_serverAddingViewController animated:YES];
    }
}

- (void)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    BOOL bExist = NO;
    for (int i = 0; i < [_arrServerList count]; i++) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:i];
        if ([tmpServerObj._strServerName isEqualToString:strServerName] && [tmpServerObj._strServerUrl isEqualToString:strServerUrl]) 
        {
            bExist = YES;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Info" message:@"This Server has been existed..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            break;
        }
    }
    
    if (!bExist) 
    {
        Configuration* configuration = [Configuration sharedInstance];
        
        ServerObj* serverObj = [[ServerObj alloc] init];
        serverObj._strServerName = strServerName;
        serverObj._strServerUrl = strServerUrl;    
        serverObj._bSystemServer = NO;
        
        NSMutableArray* arrAddedServer = [[NSMutableArray alloc] init];
        arrAddedServer = [configuration loadUserConfiguration];
        [arrAddedServer addObject:serverObj];
        [configuration writeUserConfiguration:arrAddedServer];
        [serverObj release];
        [arrAddedServer release];
        
        [_arrServerList removeAllObjects];
        _arrServerList = [configuration getServerList];
        [_tbvlServerList reloadData];
        [self.navigationController popToViewController:self animated:YES];
    }    
}

- (void)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    BOOL bExist = NO;
    ServerObj* tmpServerObj;
    for (int i = 0; i < [_arrServerList count]; i++) 
    {
        tmpServerObj = [_arrServerList objectAtIndex:i];
        if ([tmpServerObj._strServerName isEqualToString:strServerName] && [tmpServerObj._strServerUrl isEqualToString:strServerUrl]) 
        {
            bExist = YES;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Info" message:@"This Url has been existed..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            break;
        }
    }
   
    if (!bExist) 
    {
        ServerObj* serverObjEdited = [_arrServerList objectAtIndex:index];
        serverObjEdited._strServerName = strServerName;
        serverObjEdited._strServerUrl = strServerUrl;
        
        [_arrServerList replaceObjectAtIndex:index withObject:serverObjEdited];
        
        NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_arrServerList count]; i++) 
        {
            tmpServerObj = [_arrServerList objectAtIndex:i];
            if (tmpServerObj._bSystemServer == serverObjEdited._bSystemServer) 
            {
                [arrTmp addObject:tmpServerObj];
            }
        }
        
        Configuration* configuration = [Configuration sharedInstance];
        if (serverObjEdited._bSystemServer) 
        {
            [configuration writeSystemConfiguration:arrTmp];
        }
        else
        {
            [configuration writeUserConfiguration:arrTmp];
        }
        
        [_arrServerList removeAllObjects];
        _arrServerList = [configuration getServerList];
        [_tbvlServerList reloadData];
        [self.navigationController popToViewController:self animated:YES];
    }
}


- (void)deleteServerObjAtIndex:(int)index
{
    ServerObj* deletedServerObj = [_arrServerList objectAtIndex:index];
    
    [_arrServerList removeObjectAtIndex:index];
    
    NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_arrServerList count]; i++) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:i];
        if (tmpServerObj._bSystemServer == deletedServerObj._bSystemServer) 
        {
            [arrTmp addObject:tmpServerObj];
        }
    }
    
    Configuration* configuration = [Configuration sharedInstance];
    if (deletedServerObj._bSystemServer) 
    {
        [configuration writeSystemConfiguration:arrTmp];
    }
    else
    {
        [configuration writeUserConfiguration:arrTmp];
    }
    
    [arrTmp release];
            
    [_arrServerList removeAllObjects];
    _arrServerList = [configuration getServerList];
    [_tbvlServerList reloadData];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	return tmpStr;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_arrServerList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServerCellIdentifier];
    if(cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerCellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* lbServerName = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 150, 30)];
        lbServerName.tag = kTagForCellSubviewServerNameLabel;
        lbServerName.textColor = [UIColor brownColor];
        [cell addSubview:lbServerName];
        [lbServerName release];
        
        UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(170, 5, 80, 30)];
        lbServerUrl.tag = kTagForCellSubviewServerUrlLabel;
        [cell addSubview:lbServerUrl];
        [lbServerUrl release];
    }
    
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    
    UILabel* lbServer = (UILabel *)[cell viewWithTag:kTagForCellSubviewServerNameLabel];
    lbServer.text = tmpServerObj._strServerName;
    
    lbServer = (UILabel *)[cell viewWithTag:kTagForCellSubviewServerUrlLabel];
    lbServer.text = tmpServerObj._strServerUrl;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    
    if (_serverEditingViewController == nil) 
    {
        _serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
        [_serverEditingViewController setDelegate:self];
    }
    [_serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
    
    if ([self.navigationController.viewControllers containsObject:_serverEditingViewController]) 
    {
        [self.navigationController popToViewController:_serverEditingViewController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:_serverEditingViewController animated:YES];
    }
    [_tbvlServerList deselectRowAtIndexPath:indexPath animated:YES];
}

@end

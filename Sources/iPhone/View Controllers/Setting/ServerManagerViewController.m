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
#import "CustomBackgroundForCell_iPhone.h"


static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";
static NSString *CellNibServer = @"AuthenticateServerCell";
//Define tags for Server cells
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20


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
    [super viewDidLoad];

    //TODO localize this title
	self.title = @"Server List";
    
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    _arrServerList = [[Configuration sharedInstance] getServerList];
    UIBarButtonItem* bbtnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBbtnAdd)];
    [self.navigationItem setRightBarButtonItem:bbtnAdd];
        
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
        if ([tmpServerObj._strServerName isEqualToString:strServerName]) 
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
    
    ServerObj* serverObjEdited = [_arrServerList objectAtIndex:index];
    
    ServerObj* tmpServerObj;
    for (int i = 0; i < [_arrServerList count]; i++) 
    {
        if(index == i)
            continue;
        
        tmpServerObj = [_arrServerList objectAtIndex:i];
        if ([tmpServerObj._strServerName isEqualToString:strServerName]) 
        {
            bExist = YES;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Info" message:@"This server has been existed..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            break;
        }
    }
   
    if (!bExist) 
    {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 44.0;
    return fHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierServer];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNibServer owner:self options:nil];
        cell = (CustomBackgroundForCell_iPhone *)[nib objectAtIndex:0];
        
        UILabel* lbServerName = (UILabel*)[cell viewWithTag:kTagInCellForServerNameLabel];
        lbServerName.textColor = [UIColor darkGrayColor];
        
        UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
        CGRect tmpFrame = lbServerUrl.frame;
        tmpFrame.size.width += 55;
        lbServerUrl.frame = tmpFrame; 
        
        lbServerUrl.textColor = [UIColor darkGrayColor];
        
        //cell.accessoryView = nil;

        
    }
    
    if (indexPath.row < [_arrServerList count]) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
        
        UILabel* lbServerName = (UILabel*)[cell viewWithTag:kTagInCellForServerNameLabel];
        lbServerName.text = tmpServerObj._strServerName;
        
        UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
        lbServerUrl.text = tmpServerObj._strServerUrl;
    }
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

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

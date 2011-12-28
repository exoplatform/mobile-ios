//
//  ServerManagerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerManagerViewController.h"
#import "ServerPreferencesManager.h"
#import "ServerAddingViewController.h"
#import "ServerEditingViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"
#import "defines.h"

static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";
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
        _intSelectedServer = -1;
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

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tbvlServerList indexPathForSelectedRow];
    if (selection)
        [_tbvlServerList deselectRowAtIndexPath:selection animated:YES];   
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO localize this title
	self.title = Localize(@"Server List");
    
    
    //Set the background Color of the view
    /*UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tbvlServerList.backgroundView = background;
    [background release];*/
    
    //_tbvlServerList.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];

    
    _tbvlServerList.backgroundColor = EXO_BACKGROUND_COLOR;

    
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];  
    _arrServerList = [[ServerPreferencesManager sharedInstance] getServerList];
    
    UIBarButtonItem* bbtnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBbtnAdd)];
    [self.navigationItem setRightBarButtonItem:bbtnAdd];
    [bbtnAdd release];
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
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)onBbtnAdd
{    
    ServerAddingViewController* serverAddingViewController = [[ServerAddingViewController alloc] initWithNibName:@"ServerAddingViewController" bundle:nil];
    [serverAddingViewController setDelegate:self];
    [self.navigationController pushViewController:serverAddingViewController animated:YES];
    
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
    
    CustomBackgroundForCell_iPhone* cell = (CustomBackgroundForCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierServer];
    if (cell == nil) {
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierServer] autorelease];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor]; 
    }
    
    if (indexPath.row < [_arrServerList count]) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = tmpServerObj._strServerName;
        cell.detailTextLabel.text = tmpServerObj._strServerUrl;
    }
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
    if([[userDefaults valueForKey:EXO_IS_USER_LOGGED] boolValue]){
        if(_intSelectedServer != indexPath.row){
              ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
              
              ServerEditingViewController* serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
              [serverEditingViewController setDelegate:self];
              [serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
              
              [self.navigationController pushViewController:serverEditingViewController animated:YES];
        }
     } else {
         ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
         
         ServerEditingViewController* serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
         [serverEditingViewController setDelegate:self];
         [serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
         
         [self.navigationController pushViewController:serverEditingViewController animated:YES];
    }
    //[_tbvlServerList deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma - ServerManagerProtocol Methods

- (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars {
 
    NSCharacterSet *invalidCharSet = nil;
    
    
    invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:chars] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    
    return [str rangeOfString:filtered].length > 0;
    
}

- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    
    //Check first message lenght for empty parameters
    if ([strServerName length] == 0 || [strServerUrl length] == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    //Check if server name or url contains special chars
    if ([self nameContainSpecialCharacter:strServerName inSet:SPECIAL_CHAR_NAME_SET] ||
        [self nameContainSpecialCharacter:strServerUrl inSet:SPECIAL_CHAR_URL_SET]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    //Check if the server has been existed
    BOOL bExist = NO;
    for (int i = 0; i < [_arrServerList count]; i++) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:i];
        if ([tmpServerObj._strServerName isEqualToString:strServerName]) 
        {
            bExist = YES;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorExist") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    
    if (!bExist) 
    {
        ServerPreferencesManager* configuration = [ServerPreferencesManager sharedInstance];
        
        //Create the new server
        ServerObj* serverObj = [[ServerObj alloc] init];
        serverObj._strServerName = strServerName;
        serverObj._strServerUrl = strServerUrl;    
        serverObj._bSystemServer = NO;
        
        //Add the server in configuration
        NSMutableArray* arrAddedServer = [configuration loadUserConfiguration];
        [arrAddedServer addObject:serverObj];
        [configuration writeUserConfiguration:arrAddedServer];
        [serverObj release];
        
        //Reload datas
        [_arrServerList removeAllObjects];
        _arrServerList = [configuration getServerList];
        [_tbvlServerList reloadData];
                
    }   
    return YES;
}

- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    
    //Check first message lenght for empty parameters
    if ([strServerName length] == 0 || [strServerUrl length] == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    //Check if server name or url contains special chars
    if ([self nameContainSpecialCharacter:strServerName inSet:SPECIAL_CHAR_NAME_SET] ||
        [self nameContainSpecialCharacter:strServerUrl inSet:SPECIAL_CHAR_URL_SET]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }


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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorExist") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
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
        
        ServerPreferencesManager* configuration = [ServerPreferencesManager sharedInstance];
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
        
    }
    return YES;
}


- (BOOL)deleteServerObjAtIndex:(int)index
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
    
    ServerPreferencesManager* configuration = [ServerPreferencesManager sharedInstance];
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
    
    return YES;
}



@end

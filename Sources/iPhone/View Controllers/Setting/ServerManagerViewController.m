//
//  ServerManagerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerManagerViewController.h"
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"
#import "ServerAddingViewController.h"
#import "ServerEditingViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"
#import "URLAnalyzer.h"
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
    }
    return self;
}

- (void)dealloc
{
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
	self.title = Localize(@"ServerList");
    
    
    //Set the background Color of the view
    /*UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tbvlServerList.backgroundView = background;
    [background release];*/
    
    //_tbvlServerList.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];

    
    _tbvlServerList.backgroundColor = EXO_BACKGROUND_COLOR;

    
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
    return [[ApplicationPreferencesManager sharedInstance].serverList count];
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
    
    if (indexPath.row < [[ApplicationPreferencesManager sharedInstance].serverList count]) 
    {
        ServerObj* tmpServerObj = [[ApplicationPreferencesManager sharedInstance].serverList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = tmpServerObj._strServerName;
        cell.detailTextLabel.text = tmpServerObj._strServerUrl;
    }
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ApplicationPreferencesManager *serverPrefManager = [ApplicationPreferencesManager sharedInstance];
    if([UserPreferencesManager sharedInstance].isUserLogged){
        if(serverPrefManager.selectedServerIndex != indexPath.row){
            ServerObj* tmpServerObj = [serverPrefManager.serverList objectAtIndex:indexPath.row];
            
            ServerEditingViewController* serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
            [serverEditingViewController setDelegate:self];
            [serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
            
            [self.navigationController pushViewController:serverEditingViewController animated:YES];
        }
    } else {
        ServerObj* tmpServerObj = [serverPrefManager.serverList objectAtIndex:indexPath.row];
        
        ServerEditingViewController* serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
        [serverEditingViewController setDelegate:self];
        [serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
        
        [self.navigationController pushViewController:serverEditingViewController animated:YES];
    }
    //[_tbvlServerList deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma - ServerManagerProtocol Methods

// Check if the server already exists (both name and URL, ignoring the case)
// Ignore the index of the server you are currently editing
// Ignore -1 to compare with all the existing servers
- (BOOL)checkServerAlreadyExistsWithName:(NSString*)strServerName andURL:(NSString*)strServerUrl ignoringIndex:(NSInteger) index {
    ApplicationPreferencesManager* serverPrefManager = [ApplicationPreferencesManager sharedInstance];
    for (int i = 0; i < [serverPrefManager.serverList count]; i++) 
    {
        if (index==i)continue; // ignore the server specified by index
        ServerObj* tmpServerObj = [serverPrefManager.serverList objectAtIndex:i];
        NSString* tmpServName = [tmpServerObj._strServerName lowercaseString];
        NSString* tmpServURL = [tmpServerObj._strServerUrl lowercaseString];
        if ([tmpServName isEqualToString:[strServerName lowercaseString]] ||
            [tmpServURL isEqualToString:[strServerUrl lowercaseString]])
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars {
 
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    NSRange range = [str rangeOfCharacterFromSet:invalidCharSet];
    return (range.length > 0);
    
}

-(BOOL) checkServerInfo:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl {
 
    //Check if the server name is null or empty
    if (strServerName == nil || [strServerName length] == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    // Check if the name contains some forbidden characters: & < > " '
    if ([self nameContainSpecialCharacter:strServerName inSet:@"&<>\"'"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    // Check if the server URL is null
    if(strServerUrl == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    } else {
        // Check if the server URL is valid :
        // - characters & < > " ' ! ; \ | ( ) { } [ ] , * % are forbidden
        // - URL must start with http or https
        // - scheme and host must not be null or empty
        NSURL* tmpUrl = [NSURL URLWithString:strServerUrl];
        if ([self nameContainSpecialCharacter:strServerUrl inSet:@"&<>\"'!;\\|(){}[],*%"] ||
            tmpUrl == nil || tmpUrl.scheme == nil || tmpUrl.host == nil ||
            (![[tmpUrl.scheme lowercaseString] isEqualToString:@"http"] &&
             ![[tmpUrl.scheme lowercaseString] isEqualToString:@"https"]
            ) || tmpUrl.host.length == 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"InvalidUrl") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    if (![[strServerUrl lowercaseString] hasPrefix:@"http://"] && 
        ![[strServerUrl lowercaseString] hasPrefix:@"https://"]) {
        strServerUrl = [NSString stringWithFormat:@"http://%@", strServerUrl];
    }   
    // Check whether the name and URL are correctly formed
    if(![self checkServerInfo:strServerName andServerUrl:strServerUrl])
       return NO;
 
    // If the name and URL are well formed, we remove some unnecessary characters
    NSString* cleanServerName = [strServerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* cleanServerUrl = [URLAnalyzer parserURL:[strServerUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    ApplicationPreferencesManager* serverPrefManager = [ApplicationPreferencesManager sharedInstance];
    
    // Check whether the name and URL already exists, ignoring case
    if ([self checkServerAlreadyExistsWithName:cleanServerName andURL:cleanServerUrl ignoringIndex:-1]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorExist") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else
    {
        //Create the new server
        ServerObj* serverObj = [[ServerObj alloc] init];
        serverObj._strServerName = cleanServerName;
        serverObj._strServerUrl = cleanServerUrl;    
        serverObj._bSystemServer = NO;
        
        //Add the server in configuration
        NSMutableArray* arrAddedServer = [serverPrefManager loadUserConfiguration];
        [arrAddedServer addObject:serverObj];
        [serverPrefManager writeUserConfiguration:arrAddedServer];
        [serverObj release];
        [serverPrefManager loadServerList]; // reload list of servers
        [_tbvlServerList reloadData];
    }
    
    // If this is the only server: select it automatically
    if ([serverPrefManager.serverList count] == 1)
        [serverPrefManager setSelectedServerIndex:0];
    
    return YES;
}

- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    // Check whether the name and URL are correctly formed
    if(![self checkServerInfo:strServerName andServerUrl:strServerUrl])
        return NO;

    // If the name and URL are well formed, we remove some unnecessary characters
    NSString* cleanServerName = [strServerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* cleanServerUrl = [URLAnalyzer parserURL:[strServerUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    // Check whether the name and URL already exists, ignoring case and the server under edit
    if ([self checkServerAlreadyExistsWithName:cleanServerName andURL:cleanServerUrl ignoringIndex:index]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorExist") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else
    {
        ApplicationPreferencesManager* serverPrefManager = [ApplicationPreferencesManager sharedInstance];
        ServerObj* serverObjEdited = [serverPrefManager.serverList objectAtIndex:index];
        ServerObj* tmpServerObj;
        
        serverObjEdited._strServerName = cleanServerName;
        serverObjEdited._strServerUrl = cleanServerUrl;
        
        [serverPrefManager.serverList replaceObjectAtIndex:index withObject:serverObjEdited];
        
        NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [serverPrefManager.serverList count]; i++) 
        {
            tmpServerObj = [serverPrefManager.serverList objectAtIndex:i];
            if (tmpServerObj._bSystemServer == serverObjEdited._bSystemServer) 
            {
                [arrTmp addObject:tmpServerObj];
            }
        }
        
        if (serverObjEdited._bSystemServer) 
        {
            [serverPrefManager writeSystemConfiguration:arrTmp];
        }
        else
        {
            [serverPrefManager writeUserConfiguration:arrTmp];
        }
        
        [serverPrefManager loadServerList];
        [_tbvlServerList reloadData];
        
    }
    return YES;
}


- (BOOL)deleteServerObjAtIndex:(int)index
{
    ApplicationPreferencesManager* serverPrefManager = [ApplicationPreferencesManager sharedInstance];
    ServerObj* deletedServerObj = [[serverPrefManager.serverList objectAtIndex:index] retain];

    [serverPrefManager.serverList removeObjectAtIndex:index];
    int currentIndex = serverPrefManager.selectedServerIndex;
    if ([serverPrefManager.serverList count] > 0) {
        if(currentIndex > index) {
            serverPrefManager.selectedServerIndex = currentIndex - 1;
        } else if (currentIndex == index) {
            serverPrefManager.selectedServerIndex = currentIndex < serverPrefManager.serverList.count ? currentIndex : serverPrefManager.serverList.count - 1;           
        }        
    } else {
        serverPrefManager.selectedServerIndex = -1;
    }
    NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [serverPrefManager.serverList count]; i++) 
    {
        ServerObj* tmpServerObj = [serverPrefManager.serverList objectAtIndex:i];
        if (tmpServerObj._bSystemServer == deletedServerObj._bSystemServer) 
        {
            [arrTmp addObject:tmpServerObj];
        }
    }
    
    if (deletedServerObj._bSystemServer) 
    {
        [serverPrefManager writeSystemConfiguration:arrTmp];
    }
    else
    {
        [serverPrefManager writeUserConfiguration:arrTmp];
    }
    [deletedServerObj release];
    [arrTmp release];
    
    [serverPrefManager loadServerList]; // reload list of servers
    [_tbvlServerList reloadData];
    
    // If there is the only 1 remaining server: select it automatically
    if ([serverPrefManager.serverList count] == 1)
        [serverPrefManager setSelectedServerIndex:0];
    
    return YES;
}



@end

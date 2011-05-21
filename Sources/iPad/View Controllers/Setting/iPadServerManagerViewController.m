//
//  iPadServerManagerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "iPadServerManagerViewController.h"
#import "Configuration.h"
#import "iPadServerAddingViewController.h"
#import "iPadServerEditingViewController.h"
#import "ContainerCell.h"
#import "defines.h"
#import "LoginViewController.h"
#import "iPadSettingViewController.h"
#import "CustomBackgroundForCell_iPhone.h"

static NSString *ServerCellIdentifier = @"ServerIdentifier";
#define kTagForCellSubviewServerNameLabel 444
#define kTagForCellSubviewServerUrlLabel 555


static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";
static NSString *CellNibServer = @"AuthenticateServerCell";
//Define tags for Server cells
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@implementation iPadServerManagerViewController

@synthesize _tbvlServerList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        _arrServerList = [[NSMutableArray alloc] init];
        _dictLocalize = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_dictLocalize release];
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
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
//    UIView* bg = [[UIView alloc] initWithFrame:[_tbvlServerList frame]];
//	[bg setBackgroundColor:[UIColor clearColor]];
//	[_tbvlServerList setBackgroundView:bg];
//    [bg release];
    
    _arrServerList = [[Configuration sharedInstance] getServerList];
//    _btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_btnAdd setFrame:CGRectMake(100, 10, 60, 37)];
//    [_btnAdd.titleLabel setTextColor:[UIColor redColor]];
//    [_btnAdd setTitle:@"Add" forState:UIControlStateNormal];
//    [_btnAdd addTarget:self action:@selector(onBtnAdd) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_btnAdd];
    
    _bbtnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd)];
    self.navigationItem.rightBarButtonItem = _bbtnAdd;
    
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
    return YES;
}

/*
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [_tbvlServerList setFrame:CGRectMake(0, 44, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD - 44)];
        [_btnAdd setFrame:CGRectMake(690, 5, 60, 37)];
	}
    
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [_tbvlServerList setFrame:CGRectMake(0, 44, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD - 44)];
        [_btnAdd setFrame:CGRectMake(946, 5, 60, 37)];
	}
    _interfaceOrientation = interfaceOrientation;
    [_tbvlServerList reloadData];
}
*/ 

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    _dictLocalize = [_delegate getLocalization];
}

- (void)localize
{
    _dictLocalize = [_delegate getLocalization];
    [_tbvlServerList reloadData];
}

- (NSDictionary*)getLocalization 
{
    return _dictLocalize;
}

- (IBAction)onBtnBack:(id)sender
{
    [_delegate onBackDelegate];
}

- (void)onBtnAdd
{
    if (_iPadServerAddingViewController == nil) 
    {
        _iPadServerAddingViewController = [[iPadServerAddingViewController alloc] initWithNibName:@"iPadServerAddingViewController" bundle:nil];
        [_iPadServerAddingViewController setDelegate:self];
        [_iPadServerAddingViewController setInterfaceOrientation:_interfaceOrientation];
    }
    [_iPadServerAddingViewController._txtfServerName setText:@""];
    [_iPadServerAddingViewController._txtfServerUrl setText:@""];    

  
    [self.navigationController pushViewController:_iPadServerAddingViewController animated:YES];
    
    
    //[_delegate showiPadServerAddingViewController];
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
    //[_delegate pullViewOut:self.view];
    [_delegate showiPadServerManagerViewController];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temporary code. It will be updated as soon as BD team provide us UI design
    /*
    float fWidth = 0;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        fWidth = 450;
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        fWidth = 450;
    }
    float fHeight = 44.0;
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    NSString* text = tmpServerObj._strServerUrl; 
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    fHeight = 44*((int)theSize.height/44 + 1);
    return fHeight;
    */
    return 44;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_arrServerList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierServer];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNibServer owner:self options:nil];
        cell = (CustomBackgroundForCell_iPhone *)[nib objectAtIndex:0];
        
        UILabel* lbServerName = (UILabel*)[cell viewWithTag:kTagInCellForServerNameLabel];
        lbServerName.textColor = [UIColor darkGrayColor];
        
        UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
        CGRect tmpFrame = lbServerUrl.frame;
        //tmpFrame.size.width += 155;
        tmpFrame.size.width = 330;
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
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServerCellIdentifier];
    if(cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerCellIdentifier] autorelease];
    }
	
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    
    UILabel* lbServerName = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 150, 30)];
    lbServerName.text = tmpServerObj._strServerName;
    lbServerName.textColor = [UIColor brownColor];
    [cell addSubview:lbServerName];
    [lbServerName release];
    
    float fWidth = 0;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        fWidth = 450;
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        fWidth = 450;
    }
    
    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 400, 30)];
    NSString* text = tmpServerObj._strServerUrl; 
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    [lbServerUrl setFrame:CGRectMake(220, 5, fWidth, 44*((int)theSize.height/44 + 1) - 10)];
    [lbServerUrl setNumberOfLines:(int)theSize.height/44 + 1];
    lbServerUrl.text = tmpServerObj._strServerUrl;
    [cell addSubview:lbServerUrl];
    [lbServerUrl release];
    
    return cell;
    */ 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    
    if (_iPadServerEditingViewController == nil) 
    {
        _iPadServerEditingViewController = [[iPadServerEditingViewController alloc] initWithNibName:@"iPadServerEditingViewController" bundle:nil];
        [_iPadServerEditingViewController setDelegate:_delegate];
        [_iPadServerEditingViewController setInterfaceOrientation:_interfaceOrientation];
    }
    [_iPadServerEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];

    [self.navigationController pushViewController:_iPadServerEditingViewController animated:YES];
    
    _intCurrentIndex = indexPath.row;
    [_tbvlServerList deselectRowAtIndexPath:indexPath animated:YES];
}

@end

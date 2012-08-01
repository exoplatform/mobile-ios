//
//  ServerListViewController.m
//  eXo Platform
//
//  Created by exoplatform on 7/18/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ServerListViewController.h"
#import "defines.h"


//Define for cells of the Server Selection Panel
#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@interface ServerListViewController ()

@end

@implementation ServerListViewController

@synthesize tbvlServerList = _tbvlServerList;
@synthesize panelBackground = _panelBackground;

-(void) dealloc {
    [_tbvlServerList release];
    [_panelBackground release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    [_tbvlServerList reloadData];
}

#pragma mark - UITableView Utils

-(UIImageView *) makeCheckmarkOffAccessoryView
{        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return [[ServerPreferencesManager sharedInstance].serverList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return kHeightForServerCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"AuthenticateServerCellIdentifier";
    static NSString *CellNib = @"AuthenticateServerCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellNib];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellNib] autorelease];
        
        //Some customize of the cell background :-)
        [cell setBackgroundColor:[UIColor clearColor]];
        
        //Create two streachables images for background states
        UIImage *imgBgNormal = [[UIImage imageNamed:@"AuthenticateServerCellBgNormal.png"]
                                stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        UIImage *imgBgSelected = [[UIImage imageNamed:@"AuthenticateServerCellBgSelected.png"]
                                  stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        //Add images to imageView for the backgroundview of the cell
        UIImageView *ImgVCellBGNormal = [[UIImageView alloc] initWithImage:imgBgNormal];
        
        UIImageView *ImgVBGSelected = [[UIImageView alloc] initWithImage:imgBgSelected];
        
        //Define the ImageView as background of the cell
        [cell setBackgroundView:ImgVCellBGNormal];
        [ImgVCellBGNormal release];
        
        //Define the ImageView as background of the cell
        [cell setSelectedBackgroundView:ImgVBGSelected];
        [ImgVBGSelected release];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    
    if (indexPath.row == [ServerPreferencesManager sharedInstance].selectedServerIndex) 
    {
        cell.accessoryView = [self makeCheckmarkOnAccessoryView];
    }
    else
    {
        cell.accessoryView = [self makeCheckmarkOffAccessoryView];
    }
    
	ServerObj* tmpServerObj = [[ServerPreferencesManager sharedInstance].serverList objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpServerObj._strServerName;
    cell.detailTextLabel.text = tmpServerObj._strServerUrl;
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ServerPreferencesManager sharedInstance].selectedServerIndex = indexPath.row;
    
    //Invalidate server informations
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
    
    // Reload the tableview
    [_tbvlServerList reloadData];
}

@end

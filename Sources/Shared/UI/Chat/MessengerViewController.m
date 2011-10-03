//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerViewController.h"
#import "ChatBasicTableViewCell.h"
#import "defines.h"


@implementation MessengerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the loader    
    _hudChat = [[ATMHud alloc] initWithDelegate:self];
    [_hudChat setAllowSuperviewInteraction:NO];
	[self.view addSubview:_hudChat.view];
    
    // set position
    [self setHudPosition];
    
    
    self.title = @"Chat";
    self.view.userInteractionEnabled = NO;
    //Load all activities of the user
    [self startLoadingChat];
}

#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (![self.navigationController.viewControllers containsObject:self])
    {
        //         [_xmppClient disconnect];
	}	
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
}

#pragma mark - Chat Proxy 
#pragma mark Management

- (void)startLoadingChat {
    
    [self showChatLoader];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *host = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	NSString *userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	NSString *password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    
    _chatProxy = [ChatProxy sharedInstance];
    _chatProxy.delegate = self;
    [_chatProxy connectToChatServer:host port:5222 userName:userName password:password];
}

- (void)showChatLoader {
    
    [_hudChat setCaption:@"Updating Chat"];
    [_hudChat setActivity:YES];
    [_hudChat show];
}

- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    
    self.view.userInteractionEnabled = YES;
    
    [_hudChat setCaption:@"Chat updated"];
    [_hudChat setActivity:NO];
    [_hudChat setImage:[UIImage imageNamed:@"19-check"]];
    [_hudChat update];
    [_hudChat hideAfter:0.5];
}

- (void)cannotConnectToChatServer
{
    [self hideLoader];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect To Chat Server" message:@"Can not connect to Chat server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)updateChatClient:(NSArray *)arr
{
    [self hideLoader];
    
    _arrUsers = [arr copy];
    
    [_tblvUsersList reloadData];
    
}

- (void)sendChatMessage:(NSString *)msg to:(NSString *)toUser
{
    [_chatProxy sendChatMessage:msg  to:toUser];
}

#pragma mark - AlertView call back
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCellIdentifier = @"ChatCell";
	
    //We dequeue a cell
	ChatBasicTableViewCell* cell = (ChatBasicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatBasicTableViewCell" owner:self options:nil];
        cell = (ChatBasicTableViewCell *)[nib objectAtIndex:0];
        
        //Create a cell, need to do some Configuration
        [cell configureCell];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
	[cell setChatUser:[_arrUsers objectAtIndex:indexPath.row]];
    
	return cell;
    
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)disconnect
{
    [_chatProxy disconnect];
}

//Dealloc method.
- (void) dealloc
{
    [_tblvUsersList release];
    _tblvUsersList = nil;
    
	_delegate = nil;
	
    [_chatProxy disconnect];
    [_chatProxy release];
	_chatProxy = nil;
    
	[_arrUsers release];
    _arrUsers = nil;
    
	[_msgCount release];
    _msgCount = nil;
	
    [_msgDict release];
    _msgDict = nil;
    
    //Release the loader
    [_hudChat release];
    _hudChat = nil;
    
    [super dealloc];
}


@end

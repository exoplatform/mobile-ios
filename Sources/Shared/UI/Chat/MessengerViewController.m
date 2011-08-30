//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerViewController.h"
#import "DataProcess.h"
#import "defines.h"
#import "ChatBasicTableViewCell.h"
#import "ChatUser.h"

@implementation MessengerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id)delegate
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
        _arrChatUsers = [[NSMutableArray alloc] init];
        _delegate = delegate;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the loader    
    _hudChat = [[ATMHud alloc] initWithDelegate:self];
    [_hudChat setAllowSuperviewInteraction:NO];
	[self.view addSubview:_hudChat.view];
    
    self.title = @"Chat";
    
    //Load all activities of the user
    [self startLoadingChat];
}


-(void)viewDidDisappear:(BOOL)animated
{
     if (![self.navigationController.viewControllers containsObject:self])
     {
//         [_xmppClient disconnect];
	}	
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
    [alert show];
}

- (void)updateChatClient:(NSArray *)arr
{
    [self hideLoader];
    
    _arrUsers = [arr copy];
    
    [_tblvUsersList reloadData];
 
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
        
        //Create a cell, need to do some configurations
        [cell configureCell];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

	[cell setChatUser:[_arrUsers objectAtIndex:indexPath.row]];
    
	return cell;
    
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
	//if(_delegate && [_delegate respondsToSelector:@selector(showChatWindowWithXMPPUser: listMsg:)])
	{
//		XMPPUser* xmppUser = [_arrUsers objectAtIndex:indexPath.row];
		//_delegate._currentChatUser = [xmppUser address];
		[_msgCount replaceObjectAtIndex:indexPath.row withObject:@"0"];
		[_tblvUsersList reloadData];
		[self checkMsg];
		//[_delegate showChatWindowWithXMPPUser:xmppUser listMsg:_msgDict];
        if (_chatWindowViewController_iPhone == nil) 
        {
            _chatWindowViewController_iPhone = [[ChatWindowViewController_iPhone alloc] initWithNibName:@"ChatWindowViewController_iPhone" bundle:nil];
            
        }
        
        eXoChatUser* exochatuser = [_arrChatUsers objectAtIndex:indexPath.row];
        
        [_chatWindowViewController_iPhone initChatWindowWithDelegate:self andXMPPClient:_xmppClient andExoChatUser:exochatuser listMsg:_msgDict];
        
        if ([self.navigationController.viewControllers containsObject:_chatWindowViewController_iPhone]) 
        {
            [self.navigationController popToViewController:_chatWindowViewController_iPhone animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_chatWindowViewController_iPhone animated:YES];
            [_chatWindowViewController_iPhone setTitle:[[exochatuser getXmppUser] nickname]];
        }
	}
     */
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

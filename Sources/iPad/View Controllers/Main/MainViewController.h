//
//  MainViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppContainerViewController;
@class Connection;
@class GadgetDisplayController;
@class FilesViewController;
@class MessengerViewController;
@class ChatWindowViewController;
@class MessengerUser;
@class XMPPClient;
@class XMPPUser;
@class Gadget_iPad;

//Background view controller
@interface MainViewController : UIViewController <UIPopoverControllerDelegate>
{
	id										_delegate;	//The delegate
	UIPopoverController*					popoverController;	//pop up for portrait mode
	IBOutlet UIButton*						_btnPanel;	//Show app container
	IBOutlet UIButton*						_btnSignOut;	//Sign out
	IBOutlet UIButton*						_btnHome;	//Clear all app & gadget is viewing
	IBOutlet UIToolbar*						_toolBarChatsLive;	//Current chat tool bar
	int										_intSelectedLanguage;	//Language index
	NSDictionary*							_dictLocalize;	//Language dictionary
	AppContainerViewController*				_appContainerViewController;	//App contaniner
	GadgetDisplayController*				_gadgetDisplayController;	//Gadget view controller
	FilesViewController*					_filesViewController;	//File view controller
	MessengerViewController*				_messengerViewController;	//Chat list view controller
	ChatWindowViewController*				_chatWindowViewController;	//Chat windows view controller
	UIButton*								_btnMoreChat;	//Show live chat
	
	UINavigationController*					_nvMessengerViewController;	//Navigation controller for chat
	UIButton*								_btnLeftEdgeNavigation;	//Left image for navigationbar
	UIButton*								_btnRightEdgeNavigation;		//Right image for navigationbar
	
	UIView*									_vPrevious;	//Current app view
	UIImageView*							_imgvBackground;	//Backgroung image view
	UIImageView*							_imgViewNewMessage;	//New message image view
	
	NSString*								_strUsername;	//Username
	NSString*								_strPassword;	//Password
	
	short									_currentViewIndex;	//Index of views in view stack
	NSMutableArray*							_liveChatArr;	//Current chat list
	UIInterfaceOrientation					_interfaceOrientation;	//Device orientation
}

- (NSString*)getUsername;	//Get username
- (NSString*)getPassword;	//Get password
- (void)setCurrentViewIndex:(short)index;	//set current view
- (short)getCurrentViewIndex;	//get current view index
- (void)showChatToolBar:(BOOL)show;	//Show/hide chat toolbar
- (int)getCurrentChatUserIndex;	//Get current chat from live chats
- (void)setCurrentChatUserIndex:(int)index;	//Set current chat from live chats
- (void)setLeftBarButtonForNavigationBar;	//Change buttons on navigationbar
- (void)setDelegate:(id)delegate;	//Set the delegate
- (void)localize;	//Set language dictionary
- (NSDictionary*)getLocalization;	//Get language dictionary
- (Connection*)getConnection;	//Get connection
- (void)loadGadgets;	//Load gadgets
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;	//Change orientation
- (IBAction)onPanelBtn:(id)sender;	//Show app container in portrait mode
- (void)startFilesApplication;	//Establish file app
- (void)startMessengerApplication;	//Establish chat app
- (MessengerViewController*)getMessengerViewController;	//Get chat view controller
- (AppContainerViewController*)getAppContainerViewController;	//Get app container
- (void)showChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient;	//Start chat
- (void)setHiddenForNewMessageImage:(BOOL)bHidden;	//Show/hide new message alert on navigationbar
- (void)receivedChatMsg;	//Receive chat message
- (void)startGadget:(Gadget_iPad*)gadget;	//View gadget
- (IBAction)onHomeBtn:(id)sender;	//Go to home page view
- (IBAction)onSignOutBtn:(id)sender;	//Sign out
- (void)addChatButton:(XMPPUser *)user userIndex:(int)index;	//Add new button for chat user
- (void)removeChatButton:(int)index;	//Remove chat button when chat windows is close
- (void)openChatWindows:(int)index;	//Open new chat windows
- (void)moveChatWindow:(BOOL)bUp;	//Closw chat windows
@end

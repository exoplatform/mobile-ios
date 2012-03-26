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
@class Gadget;

@interface MainViewController : UIViewController <UIPopoverControllerDelegate>
{
	id										_delegate;	
	UIPopoverController*					popoverController;	
	IBOutlet UIButton*						_btnPanel;
	IBOutlet UIButton*						_btnSignOut;
	IBOutlet UIButton*						_btnHome;
	IBOutlet UIToolbar*						_toolBarChatsLive;
	int										_intSelectedLanguage;
	NSDictionary*							_dictLocalize;
	AppContainerViewController*				_appContainerViewController;
	GadgetDisplayController*				_gadgetDisplayController;
	FilesViewController*					_filesViewController;
	MessengerViewController*				_messengerViewController;
	ChatWindowViewController*				_chatWindowViewController;
	UIButton*								_btnMoreChat;
	
	UINavigationController*					_nvMessengerViewController;
	UIButton*								_btnLeftEdgeNavigation;
	UIButton*								_btnRightEdgeNavigation;
	
	UIView*									_vPrevious;
	UIImageView*							_imgvBackground;
	UIImageView*							_imgViewNewMessage;
	
	NSString*								_strUsername;
	NSString*								_strPassword;
	
	short									_currentViewIndex;
	NSMutableArray*							_liveChatArr;
	UIInterfaceOrientation					_interfaceOrientation;
}

- (NSString*)getUsername;
- (NSString*)getPassword;
- (void)setCurrentViewIndex:(short)index;
- (short)getCurrentViewIndex;
- (void)showChatToolBar:(BOOL)show;
- (int)getCurrentChatUserIndex;
- (void)setCurrentChatUserIndex:(int)index;
- (void)setLeftBarButtonForNavigationBar;
- (void)setDelegate:(id)delegate;
- (void)localize;
- (NSDictionary*)getLocalization;
- (Connection*)getConnection;
- (void)loadGadgets;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (IBAction)onPanelBtn:(id)sender;
- (void)startFilesApplication;
- (void)startMessengerApplication;
- (MessengerViewController*)getMessengerViewController;
- (AppContainerViewController*)getAppContainerViewController;
- (void)showChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient;
- (void)setHiddenForNewMessageImage:(BOOL)bHidden;
- (void)receivedChatMsg;
//- (void)startGadget:(NSURL*)gadgetUrl;
- (void)startGadget:(Gadget*)gadget;
- (IBAction)onHomeBtn:(id)sender;
- (IBAction)onSignOutBtn:(id)sender;
- (void)addChatButton:(XMPPUser *)user userIndex:(int)index;
- (void)removeChatButton:(int)index;
- (void)openChatWindows:(int)index;
- (void)moveChatWindow:(BOOL)bUp;
@end

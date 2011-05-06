//
//  HomeViewController_iPad.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "FilesViewController.h"
#import "MessengerViewController.h"
#import "ChatWindowViewController.h"

@interface HomeViewController_iPad : TTViewController <TTLauncherViewDelegate> {
    id                              _delegate;
    TTLauncherView*                 _launcherView;
    int                             _interfaceOrientation;
    
    FilesViewController*            _filesViewController;
    MessengerViewController*        _messengerViewController;
    UINavigationController*         _nvMessengerViewController;
    ChatWindowViewController*       _chatWindowViewController;
    short							_currentViewIndex;
    UIImageView*					_imgViewNewMessage;
    NSMutableArray*					_liveChatArr;
    UIToolbar*						_toolBarChatsLive;
}

- (void)setDelegate:(id)delegate;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)setCurrentViewIndex:(short)index;
- (short)getCurrentViewIndex;
- (int)getCurrentChatUserIndex;
- (void)setCurrentChatUserIndex:(int)index;
- (void)showChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient;
- (MessengerViewController*)getMessengerViewController;
- (void)showChatToolBar:(BOOL)show;
@end

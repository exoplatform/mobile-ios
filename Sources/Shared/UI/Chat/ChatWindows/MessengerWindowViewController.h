//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
#import "XMPPJID.h"
#import "XMPPUser.h"
#import "defines.h"

//Chat windows view
@interface MessengerWindowViewController : UIViewController
{
    id                              _delegate;
    XMPPUser*                       _user;
    
    IBOutlet UITableView*           _tblMessageContent;	//Chat content view
    IBOutlet UITextView*            _txtViewMsg;	//Chat typing area
    IBOutlet UIImageView*           _imgViewNewMessage;
    IBOutlet UIImageView*           _imgViewMessengerBackground;
    IBOutlet UIButton*              _btnSendMessage;
    
    int                             _heightOfKeyboard;
    BOOL                            _keyboardIsShown;
    
    NSMutableArray*                 _cellArray;
    
    UIImage*                        _discussionUserMessageBg;
    UIImage*                        _discussionBuddyMessageBg;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) XMPPUser* user;
@property int heightOfKeyboard;

@property(nonatomic, retain) UIImage* discussionUserMessageBg;
@property(nonatomic, retain) UIImage* discussionBuddyMessageBg;

- (IBAction)onBtnSendMessage;
- (void)onBtnClearMessage;

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)receivedChatMessage:(XMPPMessage *)xmppMsg;
@end

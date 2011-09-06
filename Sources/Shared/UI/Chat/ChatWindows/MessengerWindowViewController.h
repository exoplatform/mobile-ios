//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUser.h"
#import "defines.h"

//Chat windows view
@interface MessengerWindowViewController : UIViewController <UITextViewDelegate>
{
    id                              _delegate;
    XMPPUser*                       _user;
    
	IBOutlet UIScrollView*          _scrMessageContent;	//Chat content view
    IBOutlet UITextView*            _txtViewMsg;	//Chat typing area
    IBOutlet UIImageView*           _imgViewNewMessage;
    IBOutlet UIImageView*           _imgViewMessengerBackground;
    IBOutlet UIButton*              _btnSendMessage;
    
    int                             _heightOfKeyboard;
    BOOL                            _keyboardIsShown;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) XMPPUser* user;
@property int heightOfKeyboard;

- (IBAction)onBtnSendMessage;
- (void)onBtnClearMessage;

@end

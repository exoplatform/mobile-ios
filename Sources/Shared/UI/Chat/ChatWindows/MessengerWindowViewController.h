//
//  eXoFilesView.h
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUser.h"

//Chat windows view
@interface MessengerWindowViewController : UIViewController <UITextViewDelegate>
{
    id                              _delegate;
	IBOutlet UIScrollView*          _scrMessageContent;	//Chat content view
    IBOutlet UITextView*            _txtViewMsg;	//Chat typing area
    IBOutlet UIImageView*           _imgViewNewMessage;
}

@property(nonatomic, retain) id delegate;

- (IBAction)onBtnSendMessage;
- (void)onBtnClearMessage;

@end

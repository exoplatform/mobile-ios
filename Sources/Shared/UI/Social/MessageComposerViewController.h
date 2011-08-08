//
//  MessageComposerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"

@class ActivityStreamBrowseViewController;


@protocol SocialMessageComposerDelegate;


@interface MessageComposerViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SocialProxyDelegate>
{
    IBOutlet UIButton*                  _btnCancel;
    IBOutlet UIButton*                  _btnSend;
    IBOutlet UITextView*                _txtvMessageComposer;
    IBOutlet UIImageView*               _imgvBackground;
    IBOutlet UIImageView*               _imgvTextViewBg;
    
    BOOL                                _isPostMessage;
    NSString*                           _strActivityID;
    
    id<SocialMessageComposerDelegate>   delegate;
    UITableView*                        _tblvActivityDetail;
}

@property BOOL isPostMessage;
@property(nonatomic, retain) NSString* strActivityID;
@property(nonatomic, retain) id<SocialMessageComposerDelegate> delegate;
@property(nonatomic, retain) UITableView* tblvActivityDetail;

- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

- (void)showPhotoAttachment;

@end


@protocol SocialMessageComposerDelegate<NSObject>
- (void)messageComposerDidSendData;
@end
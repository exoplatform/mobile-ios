//
//  MessageComposerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"

@class ActivityStreamBrowseViewController;


@protocol SocialMessageComposerDelegate;


@interface MessageComposerViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SocialProxyDelegate>
{
    IBOutlet UIButton*                  _btnCancel;
    IBOutlet UIButton*                  _btnSend;
    IBOutlet UIButton*                  _btnAttach;
    IBOutlet UITextView*                _txtvMessageComposer;
    IBOutlet UIImageView*               _imgvBackground;
    IBOutlet UIImageView*               _imgvTextViewBg;
    
    BOOL                                _isPostMessage;
    NSString*                           _strActivityID;
    
    id<SocialMessageComposerDelegate>   delegate;
    UITableView*                        _tblvActivityDetail;
    
    UIPopoverController*                _popoverPhotoLibraryController;
    //Loader
    ATMHud*                             _hudMessageComposer;//Heads up display
}

@property BOOL isPostMessage;
@property(nonatomic, retain) NSString* strActivityID;
@property(nonatomic, retain) id<SocialMessageComposerDelegate> delegate;
@property(nonatomic, retain) UITableView* tblvActivityDetail;
@property(nonatomic, retain) UIPopoverController* _popoverPhotoLibraryController;

- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

- (IBAction)onBtnAttachment:(id)sender;
- (void)showPhotoAttachment;
- (void)setHudPosition;
- (void)showPhotoLibrary;
@end


@protocol SocialMessageComposerDelegate<NSObject>
- (void)messageComposerDidSendData;
@end
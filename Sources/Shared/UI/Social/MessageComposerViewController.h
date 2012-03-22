//
//  MessageComposerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"
#import "eXoViewController.h"

@class ActivityStreamBrowseViewController;


@protocol SocialMessageComposerDelegate;


@interface MessageComposerViewController : eXoViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SocialProxyDelegate, UIAlertViewDelegate>
{
    IBOutlet UIButton*                  _btnCancel;
    IBOutlet UIButton*                  _btnSend;
    IBOutlet UIButton*                  _btnAttach;
    IBOutlet UITextView*                _txtvMessageComposer;
    IBOutlet UIImageView*               _imgvBackground;
    IBOutlet UIImageView*               _imgvTextViewBg;
    
    BOOL                                _isPostMessage;
    NSString*                           _strActivityID;
    NSString*                           _strTitle;
    
    id<SocialMessageComposerDelegate>   delegate;
    UITableView*                        _tblvActivityDetail;
    
    UIPopoverController*                _popoverPhotoLibraryController;
    
}

@property BOOL isPostMessage;
@property(nonatomic, retain) UIButton* _btnCancel;
@property(nonatomic, retain) UIButton* _btnSend;
@property(nonatomic, retain) NSString* strActivityID;
@property(nonatomic, retain) id<SocialMessageComposerDelegate> delegate;
@property(nonatomic, retain) UITableView* tblvActivityDetail;
@property(nonatomic, retain) UIPopoverController* _popoverPhotoLibraryController;

- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

- (IBAction)onBtnAttachment:(id)sender;
- (void)showActionSheetForPhotoAttachment;
- (void)showPhotoLibrary;
- (void)addPhotoToView:(UIImage *)image;

- (void)cancelDisplayAttachedPhoto;
- (void)deleteAttachedPhoto;
- (UIImage *)resizeImage:(UIImage *)image;

@end


@protocol SocialMessageComposerDelegate<NSObject>
- (void)messageComposerDidSendData;
@end
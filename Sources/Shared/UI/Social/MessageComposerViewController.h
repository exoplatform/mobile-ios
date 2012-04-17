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
#import "ImagePreviewViewController.h"

@class ActivityStreamBrowseViewController;


@protocol SocialMessageComposerDelegate;


@interface MessageComposerViewController : eXoViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SocialProxyDelegate, UIAlertViewDelegate>
{
    IBOutlet UIButton*                  _btnCancel;
    IBOutlet UIButton*                  btnSend;
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
@property(nonatomic, retain) UIButton* btnSend;
@property(nonatomic, retain) NSString* strActivityID;
@property(nonatomic, retain) UIButton *btnAttachPhoto;
@property(nonatomic, retain) UITextView *txtMessage;
@property(nonatomic, retain) UIImageView *attPhotoView;

@property(nonatomic, assign) id<SocialMessageComposerDelegate> delegate;
@property(nonatomic, retain) UITableView* tblvActivityDetail;
@property(nonatomic, retain) UIPopoverController* _popoverPhotoLibraryController;

- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

- (IBAction)onBtnAttachment:(id)sender;
- (void)showActionSheetForPhotoAttachment;
- (void)editPhoto;
- (void)addPhotoToView:(UIImage *)image;

- (void)cancelDisplayAttachedPhoto;
- (void)deleteAttachedPhoto;
- (UIImage *)resizeImage:(UIImage *)image;
- (void)reArrangeSubViews;

@end


@protocol SocialMessageComposerDelegate<NSObject>
- (void)messageComposerDidSendData;
@end
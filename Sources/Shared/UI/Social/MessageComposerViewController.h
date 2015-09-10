//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"
#import "eXoViewController.h"
#import "ImagePreviewViewController.h"
#import "LanguageHelper.h"
#import "SpaceSelectionViewController.h"
#import "SocialSpaceProxy.h"

@class ActivityStreamBrowseViewController;


@protocol SocialMessageComposerDelegate;


@interface MessageComposerViewController : eXoViewController <UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SocialProxyDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, SpaceSelectionDelegate, SocialProxyDelegate>
{

    IBOutlet UIButton*                  _btnAttach;
    IBOutlet UITextView*                _txtvMessageComposer;
    IBOutlet UIImageView*               _imgvBackground;
    IBOutlet UIImageView*               _imgvTextViewBg;
    
    BOOL                                _isPostMessage;
    NSString*                           _strActivityID;
    NSString*                           _strTitle;
    
    UITableView*                        _tblvActivityDetail;
    
    UIPopoverController*                _popoverPhotoLibraryController;
    
}

@property BOOL isPostMessage;

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

@property (retain, nonatomic) IBOutlet UITableView *spacesTableView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *spaceTableViewHeightConstraint;

@end


@protocol SocialMessageComposerDelegate<NSObject>
- (void)messageComposerDidSendData;
@end

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

#import "MessageComposerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialPostActivity.h"
#import "SocialPostCommentProxy.h"
#import "ActivityStreamBrowseViewController.h"
#import "FilesProxy.h"
#import "defines.h"
#import "LanguageHelper.h"
#import "SpaceTableViewCell.h"
#import "ApplicationPreferencesManager.h"
#import "MobileFileUploadManager.h"


// Horizontal margin to subviews. 
#define kHorizontalMargin 10.0
// Vertical margin to subviews.
#define kVerticalMargin 10.0
// Pading between left/right panes
#define kPaneMargin 15.0
// Photo view margin
#define kPhotoViewMargin 20.0
// Portrait image width 
#define kPortraitImageWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 70.0 : 55.0)
// Landscape image width 
#define kLandscapeImageWidth (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 85.0 : 70.0)

#define kUploadErrorAlertViewTag 100

@interface MessageComposerViewController () {
    // Keep previous status bar style as the image picker changed it when displayed.
    UIStatusBarStyle _previousStatusBarStyle;
    BOOL _previousStatusBarHidden;
    SocialSpace * selectedSpace;
    
    UploadProgressViewController * uploadVC; // a view controller display the progress of the uploading process & allows to cancel the process.
    MobileFileUploadManager * uploadManager; // handler the uploading process return the progress status & completion via Blocks
}

@property (nonatomic, readonly) UIButton *attPhotoButton;
@property(nonatomic, readonly) UIImageView *photoFrameView;
@property (nonatomic, retain) SocialPostActivity *postActivityProxy;
@property (nonatomic, retain) SocialPostCommentProxy *postCommentProxy;
@property (nonatomic, retain) SocialSpaceProxy * socialSpaceProxy;

- (UIImagePickerController *)getPicker:(UIImagePickerControllerSourceType)sourceType;

@end


@implementation MessageComposerViewController

@synthesize isPostMessage=_isPostMessage, strActivityID=_strActivityID, delegate, tblvActivityDetail=_tblvActivityDetail;
@synthesize _popoverPhotoLibraryController;
@synthesize btnAttachPhoto = _btnAttachPhoto;
@synthesize txtMessage = _txtMessage;
@synthesize attPhotoView = _attPhotoView;
@synthesize photoFrameView = _photoFrameView;
@synthesize attPhotoButton = _attPhotoButton;
@synthesize postActivityProxy = _postActivityProxy;
@synthesize postCommentProxy = _postCommentProxy;
@synthesize socialSpaceProxy = _socialSpaceProxy;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    self.btnAttachPhoto = nil;
    self.txtMessage = nil;
    self.attPhotoView = nil;
    _photoFrameView = nil;
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    
    // The wantsFullScreenLayout view controller property is deprecated in iOS 7. If you currently specify wantsFullScreenLayout = NO, the
    //view controller may display its content at an unexpected screen location when it runs in iOS 7.To adjust how a view controller lays
    //out its views, UIViewController provides edgesForExtendedLayout. Detail in this document: https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Conceptual/TransitionGuide/AppearanceCustomization.html
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
	[self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityDetailCommentBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [_imgvBackground setImage:strechBg];
    
    UIImage *strechTextViewBg = [[UIImage imageNamed:@"MessageComposerTextfieldBackground.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20];
    [_imgvTextViewBg setImage:strechTextViewBg];
    
    UIBarButtonItem* bbtnSend = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Send") style:UIBarButtonItemStylePlain target:self action:@selector(onBtnSend:)];
    self.navigationItem.rightBarButtonItem = bbtnSend;
    
    UIBarButtonItem* bbtnCancel = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(onBtnCancel:)];
    self.navigationItem.leftBarButtonItem = bbtnCancel;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [_txtvMessageComposer becomeFirstResponder];
    [_txtvMessageComposer setBackgroundColor:[UIColor clearColor]];
    [_txtvMessageComposer setText:@""];
    
    if (_isPostMessage) 
    {
        _strTitle = Localize(@"PostingActivity");
        [_btnAttach setHidden:NO];
    }
    else
    {
        _strTitle = Localize(@"CommentActivity");
        [_btnAttach setHidden:YES];        
    }
    
    [self setTitle:_strTitle];
    
    /*
    ##### Add sub views for managing attached photo.
     */
    [self.view addSubview:self.attPhotoView];
    [self.view insertSubview:self.photoFrameView aboveSubview:self.attPhotoView];
    [self.view insertSubview:self.attPhotoButton aboveSubview:self.photoFrameView];
    /*
     ######
     */

    [self.spacesTableView registerNib:[UINib nibWithNibName:@"SpaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"SpaceTableViewCell"];

    if (!_isPostMessage) {
        self.spaceTableViewHeightConstraint.constant = 0;
    }
    selectedSpace = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.spacesTableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [self reArrangeSubViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) dealloc {
    _postActivityProxy.delegate = nil;
    _postCommentProxy.delegate = nil;
    _socialSpaceProxy.delegate = nil;
    
}
#pragma mark - subviews management
/*
 rearrange text field, button and attachment component in relevant position.
 */
- (void)reArrangeSubViews { 
    CGRect viewFrame = _imgvTextViewBg.frame;
    CGRect attBtnBounds = _btnAttach.bounds;
    
    /* Hide subviews for attaching image */
    self.attPhotoView.hidden = YES;
    self.photoFrameView.hidden = YES;
    self.attPhotoButton.hidden = YES;
    _btnAttach.hidden = YES;
    
    float rightPaneWidth = 0;
    /*
        Calculate attached photo view position to be placed at the middle of right pane.
     */
    if (self.attPhotoView && self.attPhotoView.image) {
        self.attPhotoView.hidden = NO;
        self.photoFrameView.hidden = NO;
        self.attPhotoButton.hidden = NO;
        CGRect attPhotoBounds = self.attPhotoView.bounds;
        float attPhotoViewX = viewFrame.origin.x + viewFrame.size.width - kHorizontalMargin - attPhotoBounds.size.width;
        float attPhotoViewY = viewFrame.origin.y + kPhotoViewMargin;
        self.attPhotoView.frame = CGRectMake(attPhotoViewX, attPhotoViewY, attPhotoBounds.size.width, attPhotoBounds.size.height);
        // if the photo is available, right pane width is its width.
        rightPaneWidth = self.attPhotoView.frame.size.width;
        self.photoFrameView.frame = CGRectMake(attPhotoViewX - 1, attPhotoViewY - 1, attPhotoBounds.size.width + 2, attPhotoBounds.size.height + 2);
        self.attPhotoButton.frame = self.photoFrameView.frame;
    } else if (_isPostMessage) {
        /* 
         Calculate attachment button position to be placed at the right bottom corner.
         */
        _btnAttach.hidden = NO;
        float buttonX = viewFrame.origin.x + viewFrame.size.width - kHorizontalMargin - attBtnBounds.size.width;
        float buttonY = viewFrame.origin.y + viewFrame.size.height - kVerticalMargin - attBtnBounds.size.height;
        _btnAttach.frame = CGRectMake(buttonX, buttonY, attBtnBounds.size.width, attBtnBounds.size.height);
        // right pane width is equal to button width
        rightPaneWidth = attBtnBounds.size.width;
    }
    
    /*
     Calculate message text view position to be placed at the left pane of the parent view.
     */
    float txtMsgWidth = viewFrame.size.width - kHorizontalMargin * 2 - rightPaneWidth - kPaneMargin; // text message view width
    CGRect frame = _txtvMessageComposer.frame;
    frame.size.width = txtMsgWidth;
    _txtvMessageComposer.frame = frame;
}



#pragma mark - getters & setters
- (UIButton *)btnAttachPhoto {
    if (!_btnAttachPhoto) {
        _btnAttachPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAttachPhoto.imageView.image = [UIImage imageNamed:@"SocialAddPhotoButton.png"];
        [_btnAttachPhoto addTarget:self action:@selector(onBtnAttachment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAttachPhoto;
}

- (UIImageView *)photoFrameView {
    if (!_photoFrameView) {
        UIImage *layerImage = [UIImage imageNamed:@"SocialAttachedImageBorder.png"];
        layerImage = [layerImage stretchableImageWithLeftCapWidth:layerImage.size.width/2 topCapHeight:layerImage.size.height/2];
        _photoFrameView = [[UIImageView alloc] initWithImage:layerImage];
    }
    return _photoFrameView;
}

- (UITextView *)txtMessage {
    if (!_txtMessage) {
        
    }
    return _txtMessage;
}

- (UIImageView *)attPhotoView {
    if (!_attPhotoView) {
        _attPhotoView = [[UIImageView alloc] init];
    }
    return _attPhotoView;
}

- (UIButton *)attPhotoButton {
    if (!_attPhotoButton) {
        _attPhotoButton = [[UIButton alloc] init];
        [_attPhotoButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
        _attPhotoButton.backgroundColor = [UIColor clearColor];
    }
    return _attPhotoButton;
}

- (UIImagePickerController *)getPicker:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    if(sourceType == UIImagePickerControllerSourceTypeCamera) {//Take a photo
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {  
            thePicker.sourceType = sourceType;
        }
    } else {
        thePicker.sourceType = sourceType;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
        }
    }
    return thePicker;
}

#pragma mark UIImagePickerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}


- (IBAction)onBtnSend:(id)sender
{
    if([self.navigationItem.title isEqualToString:Localize(@"AttachedPhoto")])
    {
        [self deleteAttachedPhoto];
        [self.navigationItem setTitle:_strTitle];
        
        return;
    }

    
    if (selectedSpace && (!selectedSpace.spaceId ||selectedSpace.spaceId.length ==0)){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageComposer") message:Localize(@"CannotLoadSpaceID") delegate:nil cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([_txtvMessageComposer.text length] > 0)
    {
        NSString* fileAttachName = nil;
        
        if(self.attPhotoView.image)
        {
            /*
             if has a attache photo:
             1. Generate a name for this photo: mobile-[date-time].png
             */
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
            fileAttachName = [dateFormatter stringFromDate:[NSDate date]];
                    
            fileAttachName = [NSString stringWithFormat:@"%@%@.png",MOBILE_UPLOAD_FILE_PREFIX, fileAttachName];
            fileAttachName = [fileAttachName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"uploading file: %@",fileAttachName);
            
            NSData *imageData = UIImagePNGRepresentation(self.attPhotoView.image);
            
//            2. Create the upload manager
            [self showUploadProgressViewController];
            uploadManager = [[MobileFileUploadManager alloc] init];
            /*
            3. Ask to upload the att photo with 2 handler blocks to get the upload process status & completion signal
            4a. In case completion success: request to create the match activity
            4b. In case of completion failed: ask to post the message any way if error connection or something. When User taps on "Cancel" button, just close the upload view controller
             */
            [uploadManager uploadFile:fileAttachName data:imageData toSpace:selectedSpace progess:^(float progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // process handler
                    uploadVC.progressBar.progress = progress;
                });
            } completion:^(NSString * fileURL, BOOL success, NSError * error ) {
                // completion handler
                if (success) {
                    self.postActivityProxy = [[SocialPostActivity alloc] init];
                    self.postActivityProxy.delegate = self;
                    [self.postActivityProxy postActivity:_txtvMessageComposer.text fileURL:fileURL fileName:fileAttachName toSpace:selectedSpace];
                } else {
                    if (!uploadVC || !uploadVC.isCanceling){ // If User hasn't hit "Cancel" so that is a connection problem --> display the alert message to ask if user want to post the message anyway
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (uploadVC && uploadVC.view.superview) {
                                [uploadVC.view removeFromSuperview];
                            }
                            UIAlertView * uploadErrorAlert = [[UIAlertView alloc] initWithTitle:Localize(@"Upload failed") message:Localize(@"Unable to upload") delegate:self cancelButtonTitle:Localize(@"Cancel") otherButtonTitles:Localize(@"OK"), nil];
                            uploadErrorAlert.tag = kUploadErrorAlertViewTag;
                            [uploadErrorAlert show];
                        });
                    }
                }
            }];

        } else {
            [self postMessageWithoutAttachement];
        }
        
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageComposer") message:Localize(@"NoMessageComment") delegate:nil cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil, nil] ;
        [alert show];
        
        if(_isPostMessage) {
            alert.message = Localize(@"NoMessagePosting");
        }
        
    }
    
}

- (void) showUploadProgressViewController {
        uploadVC = [[UploadProgressViewController alloc] initWithNibName:@"UploadProgressViewController" bundle:nil];
        uploadVC.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [uploadVC.view setFrame:self.view.frame];
        [self.navigationController.view addSubview:uploadVC.view];
        uploadVC.progressBar.progress = 0.0;
        uploadVC.errorMessage.text = Localize(@"Uploading");
        [uploadVC.cancelButton setTitle:Localize(@"Cancel") forState:UIControlStateNormal];
        [uploadVC.cancelButton setTitle:Localize(@"Cancel") forState:UIControlStateHighlighted];
        [_txtvMessageComposer resignFirstResponder];
    });
}

- (void) postMessageWithoutAttachement {
    if(_isPostMessage)
    {
        [self displayHudLoader];
        self.postActivityProxy = [[SocialPostActivity alloc] init];
        self.postActivityProxy.delegate = self;
        
        [self.postActivityProxy postActivity:_txtvMessageComposer.text fileURL:nil fileName:nil toSpace:selectedSpace];
    } else
    {
        [self displayHudLoader];
        self.postCommentProxy = [[SocialPostCommentProxy alloc] init];
        self.postCommentProxy.delegate = self;
        [self.postCommentProxy postComment:_txtvMessageComposer.text forActivity:_strActivityID];
        
    }

}

- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    if (selectedSpace){
        NSString * driverName = [selectedSpace.groupId stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        [[FilesProxy sharedInstance] uploadFile:imageData asFileName:[directory lastPathComponent] inFolder:MOBILE_UPLOAD_DEST_FOLDER ofDrive:driverName];
        
    } else {
        [[FilesProxy sharedInstance] uploadFile:imageData asFileName:[directory lastPathComponent] inFolder:@"Public/Mobile" ofDrive:MOBILE_UPLOAD_PERSONAL_DRIVE];
    }
    
}

- (IBAction)onBtnCancel:(id)sender
{
    /*
     Stop the uploading process & close the upload view controller (if it's presenting)
     */
    if (uploadManager) {
        [uploadManager cancelUpload];
    }
    if (uploadVC && uploadVC.view.superview) {
        uploadVC.isCanceling = YES;
        [uploadVC.view removeFromSuperview];
    }
    
    /*
     Dismiss this view controller
     */
    if([self.navigationItem.title isEqualToString:Localize(@"AttachedPhoto")])
    {
        [self cancelDisplayAttachedPhoto];
        [self.navigationItem setTitle:_strTitle];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (UIImage *)resizeImage:(UIImage *)image {
    
    
    int width = image.size.width;
    int height = image.size.height;
    
    if(width > height) {
        if(width > 1024) {
            
            height = height*1024/width;
            width = 1024;
        }
    }
    else {
        if(height > 1024) {
            
            width = width*1024/height;
            height = 1024;
        }
    }
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//- (void)showPhotoAttachment
- (IBAction)onBtnAttachment:(id)sender
{
    [self showActionSheetForPhotoAttachment];
}

- (void)showActionSheetForPhotoAttachment
{
    
}

// Controls the actions when the picker is started and an image already exists
// i.e. user edits the photo
- (void)editPhoto
{
    ImagePreviewViewController *imagePreview = [[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController" bundle:nil];
    __block __typeof__(imagePreview) bImagePreview = imagePreview; // create a weak reference to avoid retain cycle.
    [imagePreview changeImageWithCompletion:^(void) {
        // called when user change existing photo (edit -> change)
        // remove the image preview from the navigation view and present a picker from library source.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UIImagePickerController *picker = [self getPicker:UIImagePickerControllerSourceTypePhotoLibrary];
            [self._popoverPhotoLibraryController setContentViewController:picker animated:YES];
            // set style for navigation bar because the popover using the default style if it is not set.
            picker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
            _previousStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
            
            [self presentViewController:[self getPicker:UIImagePickerControllerSourceTypePhotoLibrary] animated:YES completion:nil];
        }
    }];
    [imagePreview removeImageWithCompletion:^(void) {
        // when user immediately remove existing photo (edit -> remove)
        // remove the photo in self and pop the image preview to return self view.
        self.attPhotoView.image = nil;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self._popoverPhotoLibraryController dismissPopoverAnimated:YES];
            self._popoverPhotoLibraryController = nil;
            [self reArrangeSubViews]; // Due to the self.view is not reappeared, this message is called to update the view.
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [imagePreview selectImageWithCompletion:^(void) {
        // when user keeps the existing photo (edit -> OK)
        // come back the self view and add given photo to this.
        [self addPhotoToView:bImagePreview.imageView.image];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self._popoverPhotoLibraryController dismissPopoverAnimated:YES];
            self._popoverPhotoLibraryController = nil;
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imagePreview];
        self._popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:navController];
        [self._popoverPhotoLibraryController presentPopoverFromRect:self.attPhotoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        // set style for navigation bar because the popover using the default style if it is not set.
        navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    } else {
        [self.navigationController pushViewController:imagePreview animated:YES];
    }
    [imagePreview displayImage:self.attPhotoView.image];
}

- (void)addPhotoToView:(UIImage *)image
{
    CGSize size = [image size];
    // the image width depends on it is landscape or portrait. 
    float imgWidth = size.width > size.height ? kLandscapeImageWidth : kPortraitImageWidth;
    float imgHeight = imgWidth * size.height / size.width;
    self.attPhotoView.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
    self.attPhotoView.image = image;
    [self reArrangeSubViews];
}

#pragma -
#pragma mark Proxies Delegate Methods

- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    if ([proxy isKindOfClass:[SocialSpaceProxy class]]){
        if (_socialSpaceProxy.mySpaces && _socialSpaceProxy.mySpaces.count>0){
            selectedSpace.spaceId = ((SocialSpace*)_socialSpaceProxy.mySpaces[0]).spaceId;
            [self.spacesTableView reloadData];
        }
    } else {
        [self hideLoaderImmediately:YES];
        if (uploadVC && uploadVC.view.superview) {
            [uploadVC.view removeFromSuperview];
        }
        if (delegate && ([delegate respondsToSelector:@selector(messageComposerDidSendData)])) {
            [delegate messageComposerDidSendData];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{

    if (![proxy isKindOfClass:[SocialSpaceProxy class]]){

        NSString *alertMessage = nil;

        [self hideLoaderImmediately:NO];

        [self.navigationController setNavigationBarHidden:NO animated:YES];

        if(_isPostMessage)
            alertMessage = Localize(@"PostingActionCannotBeCompleted");
        else
            alertMessage = Localize(@"CommentActionCannotBeCompleted");
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessage delegate:self cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil];
        
        [alertView show];

    }
}

-(void)cancelDisplayAttachedPhoto {
    
}

-(void)deleteAttachedPhoto{
    
}

#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kUploadErrorAlertViewTag) {
        switch (buttonIndex) {
            case 0: {
            }
                break;
            case 1: {
                [self postMessageWithoutAttachement];
            }
                break;
                
            default:
                break;
        }
    } else {
        //      Remove the loader
        [self hideLoader:NO];
    }
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *thePicker = nil;
    if(buttonIndex < 2)
    {
        if(buttonIndex == 0)//Take a photo
        {
            thePicker = [self getPicker:UIImagePickerControllerSourceTypeCamera];
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakePicture") message:Localize(@"CameraNotAvailable") delegate:nil cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        } else {
            thePicker = [self getPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
            _previousStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
            [self presentViewController:thePicker animated:YES completion:nil];
        } else {
            self._popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:thePicker];
            // workaround will be fixed by https://jira.exoplatform.org/browse/MOB-1828
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self._popoverPhotoLibraryController presentPopoverFromRect:_btnAttach.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }];
            // set style for navigation bar because the popover using the default style if it is not set.
            thePicker.navigationBar.barStyle = UIBarStyleBlackTranslucent;            
        }
    }
    
}


#pragma mark - UIImagePickerDelegate
// Controls the actions when the picker is started and no image is pre-existing
// i.e. user chooses an image for the 1st time
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [self addPhotoToView:[self resizeImage:info[UIImagePickerControllerOriginalImage]]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self._popoverPhotoLibraryController dismissPopoverAnimated:YES];
        self._popoverPhotoLibraryController = nil;
    } else {
        // restore previous status bar
        [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle];
        [[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHidden];
        self.navigationController.toolbarHidden = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:_previousStatusBarHidden];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * reuseIdentifier = @"SpaceTableViewCell";
    SpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.prefixLabel.text = [NSString stringWithFormat:@"%@:",Localize(@"To")];
    cell.spaceName.textColor = [UIColor colorWithRed:0.0 green:122.0/255 blue:250.0/255 alpha:1.0];

    if (selectedSpace && !selectedSpace.spaceId) {
        cell.spaceName.textColor = [UIColor redColor];
    }

    [cell setSpace:selectedSpace];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SpaceSelectionViewController  * spaceSelectionVC = [[SpaceSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    spaceSelectionVC.delegate = self;
    [self.navigationController pushViewController:spaceSelectionVC animated:YES];
    
}

#pragma mark - Space Selection Delegate 

-(void) spaceSelection:(SpaceSelectionViewController *)spaceSelection didSelectSpace:(SocialSpace *)space {
    selectedSpace = space;
    if (space){
        if (!self.socialSpaceProxy){
            self.socialSpaceProxy = [[SocialSpaceProxy alloc] init];
            self.socialSpaceProxy.delegate = self;
        }
        [self.socialSpaceProxy getIdentifyOfSpace:space];

    }
}


#pragma mark - Upload View Controller Delegate
/*
 User did selected the Cancel button while uploading
 */
-(void) uploadViewController:(UploadProgressViewController *)uploadController didSelectCancel:(id)sender {
    // Stop the uploading process
    if (uploadManager) {
        [uploadManager cancelUpload];        
    }
    [uploadController.view removeFromSuperview];
}
@end

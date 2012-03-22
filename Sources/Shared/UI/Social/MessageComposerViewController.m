//
//  MessageComposerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialPostActivity.h"
#import "SocialPostCommentProxy.h"
#import "ActivityStreamBrowseViewController.h"
#import "FilesProxy.h"
#import "defines.h"
#import "LanguageHelper.h"

@implementation MessageComposerViewController

@synthesize isPostMessage=_isPostMessage, strActivityID=_strActivityID, delegate, tblvActivityDetail=_tblvActivityDetail;
@synthesize _popoverPhotoLibraryController, _btnSend, _btnCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    iv.userInteractionEnabled = YES;
    self.view = iv;
    [iv release];
    */
    //[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    
    
	[self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityDetailCommentBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [_imgvBackground setImage:strechBg];
    
    UIImage *strechTextViewBg = [[UIImage imageNamed:@"MessageComposerTextfieldBackground.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:20];
    [_imgvTextViewBg setImage:strechTextViewBg];
    
    UIBarButtonItem* bbtnSend = [[[UIBarButtonItem alloc] initWithTitle:Localize(@"Send") style:UIBarButtonItemStylePlain target:self action:@selector(onBtnSend:)] autorelease];
    self.navigationItem.rightBarButtonItem = bbtnSend;
    
    UIBarButtonItem* bbtnCancel = [[[UIBarButtonItem alloc] initWithTitle:Localize(@"Cancel") style:UIBarButtonItemStyleDone target:self action:@selector(onBtnCancel:)] autorelease];
    self.navigationItem.leftBarButtonItem = bbtnCancel;
    
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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    if([_txtvMessageComposer.text length] > 0)
    {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        
        NSString* fileAttachName = nil;
        NSString* fileAttachURL = nil;
        
        UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
        if(imgView)
        {
            FilesProxy *fileProxy = [FilesProxy sharedInstance];
            
            BOOL storageFolder = [fileProxy createNewFolderWithURL:[NSString stringWithFormat:@"%@/Public", fileProxy._strUserRepository] folderName:@"Mobile"];
            
            if(storageFolder)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
                fileAttachName = [dateFormatter stringFromDate:[NSDate date]];
                
                //release the date formatter because, not needed after that piece of code
                [dateFormatter release];

                fileAttachName = [NSString stringWithFormat:@"MobileImage_%@.png", fileAttachName];
                NSLog(@"%@", fileAttachName);
                
                fileAttachURL = [NSString stringWithFormat:@"%@/Public/Mobile/%@", fileProxy._strUserRepository, fileAttachName];
                
                
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [fileProxy methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
                [invocation setTarget:fileProxy];
                [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
                [invocation setArgument:&fileAttachURL atIndex:2];
                [invocation setArgument:&imageData atIndex:3];
                [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
                
            }
        }
        
        
        if(_isPostMessage)
        {
            [self displayHudLoader];
            
            SocialPostActivity* actPost = [[SocialPostActivity alloc] init];
            actPost.delegate = self;

            [actPost postActivity:_txtvMessageComposer.text fileURL:fileAttachURL fileName:fileAttachName];            
        }
        else
        {
            [self displayHudLoader];
            
            SocialPostCommentProxy *actComment = [[SocialPostCommentProxy alloc] init];
            actComment.delegate = self;
            [actComment postComment:_txtvMessageComposer.text forActivity:_strActivityID];
            
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageComposer") message:Localize(@"NoMessageComment") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        if(_isPostMessage)
            alert.message = Localize(@"NoMessagePosting");
        
        [alert release];
    }
    
}

- (IBAction)onBtnCancel:(id)sender
{
    
    if([self.navigationItem.title isEqualToString:Localize(@"AttachedPhoto")])
    {
        [self cancelDisplayAttachedPhoto];
        [self.navigationItem setTitle:_strTitle];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];    
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

- (void)showPhotoLibrary
{
    
}

- (void)addPhotoToView:(UIImage *)image
{
    if(_popoverPhotoLibraryController)
        [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    else
        [self dismissModalViewControllerAnimated:YES];
    
    [[self.view viewWithTag:1] removeFromSuperview];
    [[self.view viewWithTag:2] removeFromSuperview];
    
    CGSize size = [image size];
    CGSize selfSize = self.view.frame.size;

    CGRect rect;
    if (size.width > size.height) 
    {
        if(_popoverPhotoLibraryController)
            rect = CGRectMake(10, selfSize.height - (50 + 10), 50*size.width/size.height, 50);
        else
            rect = CGRectMake(10, 150, 50*size.width/size.height, 50);
    }
    else
    {
        if(_popoverPhotoLibraryController)
            rect = CGRectMake(10, selfSize.height - (50*size.height/size.width + 10), 50, 50*size.height/size.width);
        else
            rect = CGRectMake(10, 150, 50, 50*size.height/size.width);
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.tag = 1;
    imgView.image = image;
    [self.view addSubview:imgView];
    [imgView release];
    
    
    UIButton *btnPhotoActivity = [[UIButton alloc] initWithFrame:rect];
    btnPhotoActivity.tag = 2;
    [btnPhotoActivity addTarget:self action:@selector(showPhotoActivity:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhotoActivity setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:btnPhotoActivity];
    [btnPhotoActivity release];
    
}

#pragma -
#pragma mark Proxies Delegate Methods

- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    
    [self hideLoader:YES];
    
    if (delegate && ([delegate respondsToSelector:@selector(messageComposerDidSendData)])) {
        [delegate messageComposerDidSendData];
        [self dismissModalViewControllerAnimated:YES];    
    }
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    //    [error localizedDescription] 
    
    NSString *alertMessage = nil;
    if(_isPostMessage)
        alertMessage = Localize(@"PostingActionCannotBeCompleted");    
    else
        alertMessage = Localize(@"CommentActionCannotBeCompleted");
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alertView show];
    //    [alertView release];
}

-(void)cancelDisplayAttachedPhoto {
    
}

-(void)deleteAttachedPhoto{
    
}

#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark - 
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //      Remove the loader
    [self hideLoader:NO];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 2)
    {
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
        thePicker.delegate = self;
//        thePicker.allowsEditing = YES;
        
        if(buttonIndex == 0)//Take a photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {  
                thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:thePicker animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take a picture" message:@"Camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        else
        {
            thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSString *deviceName = [[UIDevice currentDevice] name];
            NSRange rangeOfiPad = [deviceName rangeOfString:@"iPad"];
            if(rangeOfiPad.length <= 0)
                [self presentModalViewController:thePicker animated:YES];
            else
            {
                thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
                
               
                _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:thePicker];      
               
                [_popoverPhotoLibraryController presentPopoverFromRect:_btnAttach.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];        
                
            }
        }
        
        [thePicker release];
    }
    
}


#pragma mark - UIImagePickerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];    
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    [_popoverPhotoLibraryController release];
    
     
    [self addPhotoToView:[self resizeImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]]];
    
}

@end

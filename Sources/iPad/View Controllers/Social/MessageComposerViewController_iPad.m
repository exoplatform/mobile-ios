//
//  MessageComposerViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController_iPad.h"
#import "ActivityStreamBrowseViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "LanguageHelper.h"

@implementation MessageComposerViewController_iPad


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

-(void)dealloc 
{
    [super dealloc];
}

- (void)showActionSheetForPhotoAttachment
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Localize(@"AddAPhoto")
                                                             delegate:self 
                                                    cancelButtonTitle:nil 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:Localize(@"TakeAPicture"), 
                                  Localize(@"PhotoLibrary"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromRect:_btnAttach.frame inView:self.view animated:YES];
    
}


- (void)onBtnTakePhoto
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {  
        thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        thePicker.allowsEditing = YES;
        [self presentModalViewController:thePicker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakeAPicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [thePicker release];
}

- (void)onBtnPhotoLibrary
{
    [self editPhoto];
}

- (void)onBtnCancel
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

@end

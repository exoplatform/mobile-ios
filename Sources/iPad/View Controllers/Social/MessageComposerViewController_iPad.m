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

- (void)showPhotoAttachment
{
    if (_photoActionViewController == nil) 
    {
        _photoActionViewController = [[PhotoActionViewController alloc] initWithNibName:@"PhotoActionViewController" bundle:nil];
        _photoActionViewController._delegate = self;
    }
    
    if (_popoverPhotoLibraryController == nil) 
    {
        _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:_photoActionViewController];
    }
    else
    {
        [_popoverPhotoLibraryController setContentViewController:_photoActionViewController];
    }
    [_popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 132) animated:YES];
    [_popoverPhotoLibraryController presentPopoverFromRect:[_btnAttach frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)showPhotoLibrary
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    thePicker.allowsEditing = YES;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_popoverPhotoLibraryController == nil) 
    {
        _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:thePicker];
    }
    else
    {
        [_popoverPhotoLibraryController setContentViewController:thePicker];   
    }
    [_popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 320) animated:YES];
    [_popoverPhotoLibraryController presentPopoverFromRect:[_btnAttach frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [thePicker release];
}

- (void)onBtnTakePhoto
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {  
        thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        thePicker.allowsEditing = YES;
        [self presentModalViewController:thePicker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take a picture" message:@"Camera is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [thePicker release];
}

- (void)onBtnPhotoLibrary
{
    [self showPhotoLibrary];
}

- (void)onBtnCancel
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

@end

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

- (void)setHudPosition {
    _hudMessageComposer.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

- (void)showActionSheetForPhotoAttachment
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

- (void)addPhotoToView:(UIImage *)image
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    
    [[self.view viewWithTag:1] removeFromSuperview];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 50, 50)];
    imgView.tag = 1;
    imgView.image = image;
    [self.view addSubview:imgView];
    
    UIButton *btnPhotoActivity = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 50, 50)];
    btnPhotoActivity.tag = 2;
    [btnPhotoActivity addTarget:self action:@selector(showPhotoActivity:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhotoActivity setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:btnPhotoActivity];
    
}

- (void)showPhotoActivity:(UIButton *)sender
{
    self.navigationItem.title = @"Attached photo";
    [self._btnSend setTitle:@"Delete" forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    [self.view sendSubviewToBack:sender];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 400);
    self.navigationController.view.frame = imgView.frame;
    self.view.frame = imgView.frame;
    
    [UIView commitAnimations];
    
}


- (void)deleteAttachedPhoto
{
    [self._btnSend setTitle:@"Send" forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    
    CGRect frame = imgView.frame;
    frame.size.height -= 400;
    
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    [[self.view viewWithTag:2] removeFromSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
    self.navigationController.view.frame = frame;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
}

- (void)cancelDisplayAttachedPhoto
{
    [self._btnSend setTitle:@"Send" forState:UIControlStateNormal];
    CGRect frame = self.navigationController.view.frame;
    frame.size.height -= 400;
    
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    self.navigationController.view.frame = frame;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    
}

@end

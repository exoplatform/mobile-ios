//
//  MessageComposerViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController_iPhone.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageComposerViewController_iPhone


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showActionSheetForPhotoAttachment
{
    [_txtvMessageComposer resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add a photo?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take a picture" otherButtonTitles:@"Photo library", nil, nil];
    [actionSheet showInView:self.view];
    
    [actionSheet release];
}

- (void)setHudPosition {
    _hudMessageComposer.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

- (void)showPhotoLibrary
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    thePicker.allowsEditing = YES;
    [self presentModalViewController:thePicker animated:YES];
}

- (void)addPhotoToView:(UIImage *)image
{
    [self dismissModalViewControllerAnimated:YES];
    
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
    
    imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)deleteAttachedPhoto
{
    [self._btnSend setTitle:@"Send" forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    [[self.view viewWithTag:2] removeFromSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)cancelDisplayAttachedPhoto
{
 
    [self._btnSend setTitle:@"Send" forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    [UIView commitAnimations];
    
}


@end

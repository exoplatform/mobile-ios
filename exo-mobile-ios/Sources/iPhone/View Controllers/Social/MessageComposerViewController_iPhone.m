//
//  MessageComposerViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "LanguageHelper.h"

@implementation MessageComposerViewController_iPhone


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showActionSheetForPhotoAttachment
{
    [_txtvMessageComposer resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Localize(@"AddAPhoto") delegate:self cancelButtonTitle:Localize(@"Cancel") destructiveButtonTitle:nil  otherButtonTitles:Localize(@"TakeAPicture"), Localize(@"PhotoLibrary"), nil, nil];
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
//    thePicker.allowsEditing = YES;
    [self presentModalViewController:thePicker animated:YES];
}

 
- (void)showPhotoActivity:(UIButton *)sender
{
    self.title = Localize(@"AttachedPhoto");
    [self._btnSend setTitle:Localize(@"Delete") forState:UIControlStateNormal];
    
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
    [self._btnSend setTitle:Localize(@"Send") forState:UIControlStateNormal];
    
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
 
    [self._btnSend setTitle:Localize(@"Send") forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    [UIView commitAnimations];
    
}

@end

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

- (void)showPhotoAttachment
{
    [_txtvMessageComposer resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add a photo?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take a picture" otherButtonTitles:@"Photo library", nil, nil];
    [actionSheet showInView:self.view];
    
    [actionSheet release];
}

- (void)showPhotoLibrary
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    thePicker.allowsEditing = YES;
    [self presentModalViewController:thePicker animated:YES];
}

@end

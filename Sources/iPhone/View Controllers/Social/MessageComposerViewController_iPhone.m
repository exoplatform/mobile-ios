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

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

@end

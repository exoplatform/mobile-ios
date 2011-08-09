//
//  MessageComposerViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerViewController.h"

@interface MessageComposerViewController_iPhone : MessageComposerViewController <UITextViewDelegate>
{

}

- (void)showPhotoAttachment;
- (void)showPhotoLibrary;
@end

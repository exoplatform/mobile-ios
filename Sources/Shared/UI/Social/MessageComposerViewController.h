//
//  MessageComposerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageComposerViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIButton*              _btnCancel;
    IBOutlet UIButton*              _btnSend;
    IBOutlet UITextView*            _txtvMessageComposer;
    IBOutlet UIImageView*           _imgvBackground;
    IBOutlet UIImageView*           _imgvTextViewBg;
}

- (IBAction)onBtnSend:(id)sender;
- (IBAction)onBtnCancel:(id)sender;

@end

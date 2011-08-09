//
//  PhotoActionViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoActionViewController : UIViewController {
    
    id              _delegate;
}

@property (nonatomic, retain) id _delegate;

- (IBAction)onBtnTakePhoto:(id)sender;
- (IBAction)onBtnPhotoLibrary:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@end

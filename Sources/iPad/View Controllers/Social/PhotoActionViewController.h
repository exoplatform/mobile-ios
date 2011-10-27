//
//  PhotoActionViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoActionViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    id                      _delegate;
    
    UIPopoverController*    _popoverPhotoLibraryController;
    CGRect                  _rectForPresentView;
    UIView*                 _viewForPresent;
}

@property (nonatomic, retain) id _delegate;
@property CGRect _rectForPresentView;
@property (nonatomic, retain) UIView* _viewForPresent;

- (IBAction)onBtnTakePhoto:(id)sender;
- (IBAction)onBtnPhotoLibrary:(id)sender;
- (IBAction)onBtnCancel:(id)sender;
@end

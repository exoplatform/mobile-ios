//
//  UploadViewController.h
//  eXo
//
//  Created by Nguyen Manh Toan on 6/17/15.
//  Copyright (c) 2015 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UploadViewControllerDelegate;
@interface UploadViewController : UIViewController

@property (nonatomic, assign) id<UploadViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@protocol UploadViewControllerDelegate <NSObject>

@optional
-(void) uploadViewController:(UploadViewController *) uploadVC didSelectedCancel:(id) sender;

@end

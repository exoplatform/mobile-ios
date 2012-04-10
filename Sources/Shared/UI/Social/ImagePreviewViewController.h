//
//  ImagePreviewViewController.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 4/2/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^image_preview_task)();

@interface ImagePreviewViewController : UIViewController <UIScrollViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

- (void)changeImageWithCompletion:(image_preview_task)block;
- (void)removeImageWithCompletion:(image_preview_task)block;
- (void)selectImageWithCompletion:(image_preview_task)block;

- (void)displayImage:(UIImage *)image;


@end

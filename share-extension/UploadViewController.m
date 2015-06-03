//
//  UploadViewController.m
//  eXo
//
//  Created by Nguyen Manh Toan on 6/17/15.
//  Copyright (c) 2015 eXo Platform. All rights reserved.
//

#import "UploadViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView.layer.cornerRadius = 5.0;
    self.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(uploadViewController:didSelectedCancel:)]){
        [delegate uploadViewController:self didSelectedCancel:sender];
    }
}

@end

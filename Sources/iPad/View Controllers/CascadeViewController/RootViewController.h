//
//  RootView.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h>


@class MenuViewController;
@class ExoStackScrollViewController;

@class UIViewExt;

@interface RootViewController : UIViewController {
	MenuViewController* menuViewController;
	ExoStackScrollViewController* stackScrollViewController;
    
    UIImageView *imageForBackground;
    
    BOOL _isCompatibleWithSocial;
    NSTimeInterval duration;
    UIInterfaceOrientation interfaceOrient;
}
@property NSTimeInterval duration;
@property UIInterfaceOrientation interfaceOrient;
@property (nonatomic, retain) MenuViewController* menuViewController;
@property (nonatomic, retain) ExoStackScrollViewController* stackScrollViewController;
@property BOOL isCompatibleWithSocial;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCompatibleWithSocial:(BOOL)compatipleWithSocial;
- (void)resetComponent;
@end

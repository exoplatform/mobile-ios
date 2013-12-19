//
//  eXoFullScreenView.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoFullScreenView.h"
#import "defines.h"

#define IOS_5 5

@implementation eXoFullScreenView

@synthesize orientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        first = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // wantsFullScreenLayout is deprecated in iOS7+ but we keep it for backward compatibility
    self.wantsFullScreenLayout = YES;
    // The wantsFullScreenLayout view controller property is deprecated in iOS 7. If you currently specify wantsFullScreenLayout = NO, the
    //view controller may display its content at an unexpected screen location when it runs in iOS 7.To adjust how a view controller lays
    //out its views, UIViewController provides edgesForExtendedLayout. Detail in this document: https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Conceptual/TransitionGuide/AppearanceCustomization.html
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // because on iOS 5, when init class the function willAnimateRotationToInterfaceOrientation don't call
//    NSLog(@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]);
//    if([[[UIDevice currentDevice] systemVersion] floatValue] < IOS_5){
//        first = YES;
//    }else {
//        first = NO;
//    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // if the first time presentModalViewController, return (only on iso4)
//    if(first){
//        first = NO;
//        return;
//    }
    // when device rotate
    self.orientation = interfaceOrientation;
}
@end

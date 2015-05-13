//
//  RootView.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "RootViewController.h"


#import "MenuViewController.h"
#import "ExoStackScrollViewController.h"
#import "eXoFullScreenView.h"

@interface UIViewExt : UIView {} 
@end


@implementation UIViewExt
- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event 
{   
	
	UIView* viewToReturn=nil;
	CGPoint pointToReturn;
	
	UIView* uiLeftView = (UIView*)[self subviews][1];
	
	if ([uiLeftView subviews][0]) {
		
		UIView* uiScrollView = [uiLeftView subviews][0];	
		
		if ([uiScrollView subviews][0]) {	 
			
			UIView* uiMainView = [uiScrollView subviews][1];	
			
			for (UIView* subView in [uiMainView subviews]) {
				CGPoint point  = [subView convertPoint:pt fromView:self];
				if ([subView pointInside:point withEvent:event]) {
					viewToReturn = subView;
					pointToReturn = point;
				}
				
			}
		}
		
	}
	
	if(viewToReturn != nil) {
		return [viewToReturn hitTest:pointToReturn withEvent:event];		
	}
	
	return [super hitTest:pt withEvent:event];	
	
}

@end

@implementation RootViewController {
    BOOL willFixLaunchInLandscape; // see MOB-1457
    float runningiOSVersion;
}
@synthesize menuViewController, stackScrollViewController, isCompatibleWithSocial = _isCompatibleWithSocial;

@synthesize duration, interfaceOrient;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCompatibleWithSocial:(BOOL)compatipleWithSocial {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
        self.isCompatibleWithSocial = compatipleWithSocial;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    willFixLaunchInLandscape = YES;
    runningiOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
	UIViewExt *rootView = [[[UIViewExt alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	[rootView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeMenuBg.png"]]];
	
	UIView *leftMenuView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)] autorelease];
	leftMenuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;	
	menuViewController = [[MenuViewController alloc] initWithFrame:CGRectMake(0, 0, leftMenuView.frame.size.width, leftMenuView.frame.size.height) isCompatibleWithSocial: _isCompatibleWithSocial];
    menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	[leftMenuView addSubview:menuViewController.view];
	
	UIView *rightSlideView = [[[UIView alloc] initWithFrame:CGRectMake(leftMenuView.frame.size.width, 0, rootView.frame.size.width - leftMenuView.frame.size.width, rootView.frame.size.height)] autorelease];
	rightSlideView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	stackScrollViewController = [[ExoStackScrollViewController alloc] init];	
	[stackScrollViewController.view setFrame:CGRectMake(0, 0, rightSlideView.frame.size.width, rightSlideView.frame.size.height)];
	[stackScrollViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight];
	[stackScrollViewController viewWillAppear:FALSE];
	[stackScrollViewController viewDidAppear:FALSE];
	[rightSlideView addSubview:stackScrollViewController.view];
    rightSlideView.backgroundColor = [UIColor clearColor];
    
    //Add the background image when no content
    UIImage *imageBg;
    CGRect frameForBgImage;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) { 
        imageBg = [UIImage imageNamed:@"Bubble_Horizontal.png"];
        frameForBgImage = CGRectMake(250, 0, imageBg.size.width, imageBg.size.height);
    } else {
        imageBg = [UIImage imageNamed:@"Bubble_Vertical.png"];
        frameForBgImage = CGRectMake(250, 0, imageBg.size.width, imageBg.size.height);
    }
    
    imageForBackground = [[UIImageView alloc] initWithImage:imageBg];
    imageForBackground.frame = frameForBgImage;
    
    [self.view addSubview:imageForBackground];
    [self.view sendSubviewToBack:imageForBackground];
	
	[rootView addSubview:leftMenuView];
	[rootView addSubview:rightSlideView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgPatternIPad.png"]]];
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
	[self.view addSubview:rootView];
    
    
    [menuViewController tableView:menuViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)resetComponent{
    [menuViewController tableView:menuViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

// MOB-1457: willAnimateRotationToInterfaceOrientation is not called when the app is launched in
// iOS 6. It causes an UI bug if starting app in landscape mode. We need to call it manually in
// viewWillLayoutSubviews method.

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
        if(willFixLaunchInLandscape && (runningiOSVersion >= 6.0)) {
        [self willAnimateRotationToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:duration];
        willFixLaunchInLandscape = NO; // only need to fix 1 time, when the app is launched.
    }
}

-(void)changeOrientation:(NSNotification *)notification{
    eXoFullScreenView *object = (eXoFullScreenView *)[notification object];
    CGRect rect = self.view.frame;
    if(object.orientation == UIInterfaceOrientationPortrait || object.orientation == UIInterfaceOrientationPortraitUpsideDown){
        rect.size.height = 1004;
    } else {
        rect.size.height = 748;   
    }
    self.view.frame = rect;
    [self willAnimateRotationToInterfaceOrientation:object.orientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];    
	[stackScrollViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)durations{
    self.duration = durations;
    self.interfaceOrient = toInterfaceOrientation;
    //Add the background image when no content
    UIImage *imageBg;
    CGRect frameForBgImage;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) { 
        imageBg = [UIImage imageNamed:@"Bubble_Horizontal.png"];
        frameForBgImage = CGRectMake(250, 0, imageBg.size.width, imageBg.size.height);
    } else {
        imageBg = [UIImage imageNamed:@"Bubble_Vertical.png"];
        frameForBgImage = CGRectMake(250, 0, imageBg.size.width, imageBg.size.height);
    }
    
    [imageForBackground setImage:imageBg];
    imageForBackground.frame = frameForBgImage;
    
	[menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[stackScrollViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}	
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [menuViewController release];
    [stackScrollViewController release];
    [imageForBackground release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end





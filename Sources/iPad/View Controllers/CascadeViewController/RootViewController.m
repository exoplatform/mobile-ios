//
//  RootView.m
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import "RootViewController.h"


#import "MenuViewController.h"
#import "StackScrollViewController.h"
#import "eXoFullScreenView.h"

@interface UIViewExt : UIView {} 
@end


@implementation UIViewExt
- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event 
{   
	
	UIView* viewToReturn=nil;
	CGPoint pointToReturn;
	
	UIView* uiLeftView = (UIView*)[[self subviews] objectAtIndex:1];
	
	if ([[uiLeftView subviews] objectAtIndex:0]) {
		
		UIView* uiScrollView = [[uiLeftView subviews] objectAtIndex:0];	
		
		if ([[uiScrollView subviews] objectAtIndex:0]) {	 
			
			UIView* uiMainView = [[uiScrollView subviews] objectAtIndex:1];	
			
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

@implementation RootViewController
@synthesize menuViewController, stackScrollViewController, isCompatibleWithSocial = _isCompatibleWithSocial;

@synthesize duration, interfaceOrient;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCompatibleWithSocial:(BOOL)compatipleWithSocial {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
        self.isCompatibleWithSocial = compatipleWithSocial;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	rootView = [[UIViewExt alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	[rootView setBackgroundColor:[UIColor clearColor]];
	
	leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
	leftMenuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;	
	menuViewController = [[MenuViewController alloc] initWithFrame:CGRectMake(0, 0, leftMenuView.frame.size.width, leftMenuView.frame.size.height) isCompatibleWithSocial: _isCompatibleWithSocial];
	[leftMenuView addSubview:menuViewController.view];
	
	rightSlideView = [[UIView alloc] initWithFrame:CGRectMake(leftMenuView.frame.size.width, 0, rootView.frame.size.width - leftMenuView.frame.size.width, rootView.frame.size.height)];
	rightSlideView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	stackScrollViewController = [[StackScrollViewController alloc] init];	
	[stackScrollViewController.view setFrame:CGRectMake(0, 0, rightSlideView.frame.size.width, rightSlideView.frame.size.height)];
	[stackScrollViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight];
	[stackScrollViewController viewWillAppear:FALSE];
	[stackScrollViewController viewDidAppear:FALSE];
	[rightSlideView addSubview:stackScrollViewController.view];
    //rightSlideView.backgroundColor = [UIColor colorWithRed:242./255 green:242./255 blue:242./255 alpha:1.];
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //[self willAnimateRotationToInterfaceOrientation:self.interfaceOrient duration:duration];
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
    
    NSArray *arr = [stackScrollViewController viewControllersStack];
    if([arr count] == 2)
    {
        //ChatWindowViewController_iPad *chatWindowViewController = [arr objectAtIndex:1];
        //[chatWindowViewController changeOrientation:interfaceOrientation];
    }
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[stackScrollViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)durations{
    self.duration = durations;
    self.interfaceOrient = toInterfaceOrientation;
    [menuViewController setPositionsForOrientation:toInterfaceOrientation];
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
    
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end





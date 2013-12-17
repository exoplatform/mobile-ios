//
//  OnPremiseViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "eXoViewController.h"

@interface OnPremiseViewController_iPhone ()

@end

@implementation OnPremiseViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //the property wantsFullScreenLayout is for iOS prior to v7 (backward compatibility), deprecated in iOS7, and what follows is the new way to handle edges display on the screen. Link to resources that help : http://stackoverflow.com/questions/17074365/status-bar-and-navigation-bar-appear-over-my-views-bounds-in-ios-7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];

    // Notifies when the keyboard is shown/hidden
//    if(![eXoViewController isHighScreen]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboardPremise:) name:UIKeyboardDidShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboardPremise:) name:UIKeyboardDidHideNotification object:nil];
//    }
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Notifies when the keyboard is shown/hidden
    if(![eXoViewController isHighScreen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboardPremise:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboardPremise:) name:UIKeyboardDidHideNotification object:nil];
    }
    
    CGRect viewRect = self.view.frame;
    viewRect.origin.y = 0;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark LoginProxyDelegate methods

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    self.view.userInteractionEnabled = YES;
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];

    //show activity stream
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    
    [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
    
}

#pragma mark - Keyboard management

-(void)manageKeyboardPremise:(NSNotification *) notif {
    if (notif.name == UIKeyboardDidShowNotification) {
        [self setViewMovedUpPremise:YES];
    } else if (notif.name == UIKeyboardDidHideNotification) {
        [self setViewMovedUpPremise:NO];
    }
}

-(void)setViewMovedUpPremise:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        viewRect.origin.y -= scrollHeight;
    }
    else
    {
        if (viewRect.origin.y < 0) {
            viewRect.origin.y += scrollHeight;
        }
        
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}

- (void) dismissKeyboards
{
    [super dismissKeyboards];
}

@end

//
//  AlreadyAccountViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//
#define scrollUp 60; //scroll up when the keyboard appears

#import "AlreadyAccountViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "eXoViewController.h"

@interface AlreadyAccountViewController_iPhone ()

@end

@implementation AlreadyAccountViewController_iPhone

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
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];

    // Notifies when the keyboard is shown/hidden
    if(![eXoViewController isHighScreen]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.emailTf becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connectToOnPremise:(id)sender
{
    
    OnPremiseViewController_iPhone *onPremiseViewController = [[OnPremiseViewController_iPhone alloc] initWithNibName:@"OnPremiseViewController_iPhone" bundle:nil];
    
    [self.navigationController pushViewController:onPremiseViewController animated:YES];
}

#pragma mark LoginProxyDelegate methods
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
}

#pragma mark - Keyboard management

-(void)manageKeyboard:(NSNotification *) notif {
    if (notif.name == UIKeyboardDidShowNotification) {
        [self setViewMovedUp:YES];
    } else if (notif.name == UIKeyboardDidHideNotification) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        viewRect.origin.y -= scrollUp;
    }
    else
    {
        viewRect.origin.y = 0;
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}

- (void)dismissKeyboards
{
    [super dismissKeyboards];
}

@end

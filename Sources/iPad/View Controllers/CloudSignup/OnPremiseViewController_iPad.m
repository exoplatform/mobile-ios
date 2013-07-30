//
//  OnPremiseViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 7/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "OnPremiseViewController_iPad.h"
#import "AppDelegate_iPad.h"

@interface OnPremiseViewController_iPad ()

@end

@implementation OnPremiseViewController_iPad

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.serverUrlTf becomeFirstResponder];
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
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    
    // go the deepest presenting view controller to dismiss modal view
    // to avoid bug of presenting an active modal view
    WelcomeViewController_iPad *welcomeVC = (WelcomeViewController_iPad *)self.navigationController.presentingViewController;
    if(welcomeVC.shouldBackToSetting) {
        [welcomeVC.presentingViewController dismissViewControllerAnimated:NO completion:^{
            //show activity stream
            [appDelegate showHome];
        }];
    } else {
        [welcomeVC dismissViewControllerAnimated:NO completion:^{
            //show activity stream
            [appDelegate showHome];
        }];
    }
}

@end

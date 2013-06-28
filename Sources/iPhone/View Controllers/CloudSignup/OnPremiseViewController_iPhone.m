//
//  OnPremiseViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"

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
    self.title = @"On premise";
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
    
    //show activity stream
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.hud completeAndDismissWithTitle:Localize(@"Success")];

        [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
        
    }];
}

@end

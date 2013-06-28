//
//  AlreadyAccountViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "AlreadyAccountViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
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
    self.title = @"Get started";
    self.mailErrorLabel.hidden = YES;
    self.passwordErrorLabel.hidden = YES;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //if the view is redirect from sign up view, auto fill the email entered in sign up view
    if(self.autoFilledEmail != nil) {
        self.emailTf.text = self.autoFilledEmail;
    }
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
    
    //show activity stream
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.hud completeAndDismissWithTitle:Localize(@"Success")];
        [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];

    }];
}
@end

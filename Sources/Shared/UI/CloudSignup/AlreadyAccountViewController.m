//
//  AlreadyAccountViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "AlreadyAccountViewController.h"
#import "ExoCloudProxy.h"

@interface AlreadyAccountViewController ()

@end

@implementation AlreadyAccountViewController
@synthesize passwordTf, emailTf, errorLabel, autoFilledEmail;

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
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [self.emailTf release];
    [self.passwordTf release];
    [self.errorLabel release];
    [self.autoFilledEmail release];
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)login:(id)sender
{
    ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] initWithDelegate:self andEmail:self.emailTf.text];
    [cloudProxy checkTenantStatus];
}

- (void)connectToOnPremise:(id)sender
{
    
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    switch (response) {
        case TENANT_ONLINE:
            [proxy checkUserExistance];
            break;
        case USER_EXISTED:
            NSLog(@"user exit in delegate");
            break;
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    
}


#pragma mark LoginProxyDelegate methods
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    
}

- (void)authenticateFailedWithError:(NSError *)error
{
    
}
@end

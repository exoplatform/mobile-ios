//
//  AlreadyAccountViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "AlreadyAccountViewController.h"
#import "ExoCloudProxy.h"
#import "CloudUtils.h"
#import "LanguageHelper.h"
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
    if([CloudUtils checkEmailFormat:self.emailTf.text]) {
        ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] initWithDelegate:self andEmail:self.emailTf.text];
        [cloudProxy checkTenantStatus];//check the tenant status first
    } else {
        self.errorLabel.text = Localize(@"IncorrectEmailFormat");
    }
}

- (void)connectToOnPremise:(id)sender
{
    
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    switch (response) {
        case TENANT_ONLINE:
            //if the tenant is online, check user existance
            [proxy checkUserExistance];
            break;
        case TENANT_RESUMING:
            //TO-DO
            break;
        case TENANT_NOT_EXIST:
            //TO-DO
            break;
        case USER_EXISTED:
            //if user existed, login the user
            NSLog(@"user exit in delegate");
            //TO-DO
            break;
        case USER_NOT_EXISTED:
            //TO-DO
            break;
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    //TO-DO
}


#pragma mark LoginProxyDelegate methods
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    //TO-DO
}

- (void)authenticateFailedWithError:(NSError *)error
{
    //TO-DO
}
@end

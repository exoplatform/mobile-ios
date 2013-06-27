//
//  AlreadyAccountViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "AlreadyAccountViewController.h"
#import "ApplicationPreferencesManager.h"
#import "ExoCloudProxy.h"
#import "CloudUtils.h"
#import "LanguageHelper.h"
#import "LoginProxy.h"
#import "UserPreferencesManager.h"
#import "defines.h"

@interface AlreadyAccountViewController ()

@end

@implementation AlreadyAccountViewController
@synthesize passwordTf, emailTf, mailErrorLabel, passwordErrorLabel, autoFilledEmail;
@synthesize hud = _hud;

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
    [self.mailErrorLabel release];
    [self.autoFilledEmail release];
    [self.passwordErrorLabel release];
    [_hud release];
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)login:(id)sender
{
    [self dismissKeyboards];
    if([CloudUtils checkEmailFormat:self.emailTf.text]) {
        [self.hud show];

        ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] initWithDelegate:self andEmail:self.emailTf.text];
        [cloudProxy getUserMailInfo];//get info about username, tenant name, tenant status first
    } else {
        self.mailErrorLabel.hidden = NO;
    }
}

- (void)connectToOnPremise:(id)sender
{
    
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    switch (response) {
        case TENANT_ONLINE:
            //if the tenant is online, check user existance
            [cloudProxy checkUserExistance];
            break;
        case TENANT_RESUMING: {
            self.hud.hidden = YES;
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"TenantResuming") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
            break;
        }
        case TENANT_NOT_EXIST: {
            self.hud.hidden = YES;
            //TO-DO
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"TenantNotExist") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
            [alert show];
            break;
        }
            
        case USER_EXISTED: {
            //if user existed, login the user
            NSString *serverUrl = [CloudUtils serverUrlByTenant:cloudProxy.tenantName];
            
            LoginProxy *loginProxy = [[LoginProxy alloc] initWithDelegate:self username:cloudProxy.username password:self.passwordTf.text serverUrl:serverUrl];
            
            loginProxy.delegate = self;
            [loginProxy authenticate];
            break;
        }
            
        case USER_NOT_EXISTED:
            [self.hud dismiss];
            self.mailErrorLabel.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleError:(NSError *)error
{
    //TO-DO:server not available
    NSLog(@"%@", [error localizedDescription]);
    self.hud.hidden = YES;
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:Localize(@"CloudServerNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [alert show];
}

#pragma mark LoginProxyDelegate methods
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    
    //add the server url to server list
    ApplicationPreferencesManager *appPref = [ApplicationPreferencesManager sharedInstance];
    [appPref addAndSetSelectedServer:proxy.serverUrl];
    
    //1 account is already configured, next time starting app, display authenticate screen
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
}

- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    [self.hud dismiss];
    self.passwordErrorLabel.hidden = NO;
}


- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.hud dismiss];
    self.hud.hidden = NO;
}

- (void)dismissKeyboards
{
    [self.emailTf resignFirstResponder];
    [self.passwordTf resignFirstResponder];
}
@end

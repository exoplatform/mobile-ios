//
//  OnPremiseViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "OnPremiseViewController.h"
#import "LanguageHelper.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"
#import "CloudUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "CloudViewUtils.h"
#import "defines.h"

#define kAlertViewTag 1000
@interface OnPremiseViewController ()

@end

@implementation OnPremiseViewController
@synthesize usernameTf, serverUrlTf, passwordTf;
@synthesize hud = _hud;
@synthesize loginButton = _loginButton;
@synthesize  containerView;

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
    
    self.title = @"On premise";
    
    [self addInstructions];
    
    [self configElements];
    
    //add rounded corner, shadow for the form container
    [CloudViewUtils adaptCloudForm:self.containerView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
}

- (void)dealloc
{
    [super dealloc];
    [passwordTf release];
    [usernameTf release];
    [serverUrlTf release];
   
    _hud = nil;
    [_hud release];
    
    [_loginButton release];
    [containerView release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login:(id)sender
{
    
    [LoginProxy doLogout];//clear all credentials cache
    NSString *correctUrl = [CloudUtils correctServerUrl:self.serverUrlTf.text];
    
    if(correctUrl) {
        [self dismissKeyboards];
        [self.hud show];
        LoginProxy *loginProxy = [[LoginProxy alloc] initWithDelegate:self username:self.usernameTf.text password:self.passwordTf.text serverUrl:correctUrl];
        [loginProxy authenticate];
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:@"Please enter a valid url" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }
}

- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

#pragma mark LoginProxyDelegate methods
- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    [self view].userInteractionEnabled = YES;
    [self.hud setHidden:YES];
    UIAlertView *alert = nil;
    
    if([error.domain isEqualToString:NSURLErrorDomain] && error.code == kCFURLErrorNotConnectedToInternet) { // network connection problem
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"NetworkConnection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorCannotFindHost || error.code == kCFURLErrorTimedOut)) { // cant connect to server
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"InvalidServer") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) { // wrong username/password
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"WrongUserNamePassword") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    } else if ([error.domain isEqualToString:RKRestKitErrorDomain] && error.code == RKRequestBaseURLOfflineError) { //error getting platform info by restkit
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"NetworkConnection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    } else if([error.domain isEqualToString:EXO_NOT_COMPILANT_ERROR_DOMAIN]) {
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Error")
                                            message:Localize(@"NotCompliant")
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] autorelease];
        
    } else if([error.domain isEqualToString:RKRestKitErrorDomain] && error.code == RKObjectLoaderUnexpectedResponseError) {
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"ServerNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    }
    else {
        alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    }
    alert.tag = kAlertViewTag;
    [alert show];
}

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboards];
    if(textField == self.serverUrlTf) {
        [self.usernameTf becomeFirstResponder];
    } else if(textField == self.usernameTf) {
        [self.passwordTf becomeFirstResponder];
    } else if(textField == self.passwordTf) {
        if(self.passwordTf.text.length > 0 && self.serverUrlTf.text.length > 0 && self.usernameTf.text.length > 0) {
            [self login:nil];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length] > 0) {
        if(self.passwordTf.text.length > 0 && self.serverUrlTf.text.length > 0 && self.usernameTf.text.length > 0) {
            self.loginButton.enabled = YES;
        }
    } else {
        if(range.location == 0) {//delete all the text, disable login button
            self.loginButton.enabled = NO;
        }
    }
    return YES;
}
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kAlertViewTag) {
        self.hud.hidden = NO;
        [self.hud dismiss];
    }
}

#pragma mark Utils

- (void) configElements
{
    self.passwordTf.delegate = self;
    self.serverUrlTf.delegate = self;
    self.usernameTf.delegate = self;
    
    [CloudViewUtils configureTextField:self.serverUrlTf withIcon:@"icon_link"];
    [CloudViewUtils configureTextField:self.usernameTf withIcon:@"icon_user"];
    [CloudViewUtils configureTextField:self.passwordTf withIcon:@"icon_lock"];
    
    self.loginButton.enabled = NO;
    [CloudViewUtils configureButton:self.loginButton withBackground:@"blue_btn"];
}

- (void) addInstructions
{
    float instructionWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 380 : 260;
    UIView *serverInstruction = [CloudViewUtils styledLabelWithOrder:@"1" andTitle:Localize(@"EnterServerUrl") withWidth:instructionWidth];
    UIView *credentialsIntruction = [CloudViewUtils styledLabelWithOrder:@"2" andTitle:Localize(@"EnterCredentials") withWidth:instructionWidth];
    
    CGRect tmpFrame = serverInstruction.frame;
    tmpFrame.origin.x = self.serverUrlTf.frame.origin.x;
    tmpFrame.origin.y = 20;
    serverInstruction.frame = tmpFrame;
    
    tmpFrame = credentialsIntruction.frame;
    tmpFrame.origin.x = self.usernameTf.frame.origin.x;
    tmpFrame.origin.y = 120;
    credentialsIntruction.frame = tmpFrame;
    
    [self.containerView addSubview:serverInstruction];
    [self.containerView addSubview:credentialsIntruction];
    
    [serverInstruction release];
    [credentialsIntruction release];
}
#pragma mark - Keyboard management

- (void) dismissKeyboards
{
    [self.passwordTf resignFirstResponder];
    [self.serverUrlTf resignFirstResponder];
    [self.usernameTf resignFirstResponder];
}

- (void)cancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end

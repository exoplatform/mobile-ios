//
//  AlreadyAccountViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "AlreadyAccountViewController.h"

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
    
}

- (void)connectToOnPremise:(id)sender
{
    
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)proxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    
}

- (void)cloudProxy:(ExoCloudProxy *)proxy handleError:(NSError *)error
{
    
}

@end

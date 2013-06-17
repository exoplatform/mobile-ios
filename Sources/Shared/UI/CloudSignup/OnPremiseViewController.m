//
//  OnPremiseViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "OnPremiseViewController.h"

@interface OnPremiseViewController ()

@end

@implementation OnPremiseViewController
@synthesize usernameTf, serverUrlTf, passwordTf;

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

- (void)dealloc
{
    [super dealloc];
    [self.passwordTf release];
    [self.usernameTf release];
    [self.serverUrlTf release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login:(id)sender
{
    
}
@end

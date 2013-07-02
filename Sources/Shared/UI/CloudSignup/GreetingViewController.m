//
//  GreetingViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "GreetingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "defines.h"
@interface GreetingViewController ()

@end

@implementation GreetingViewController

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
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = 8;
    self.view.backgroundColor = UIColorFromRGB(0xF0F0F0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkMmail:(id)sender
{
    
}
@end

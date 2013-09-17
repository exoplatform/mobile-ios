//
//  SignUpViewController.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "SignUpViewController.h"
@interface SignUpViewController ()

@end

@implementation SignUpViewController
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
    
    [self insertBodyPanel];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

// the panel that contains the input view and greeting view
// the input view is displayed first, then after receiving validation email
// the greeting view is displayed with a flip animation
- (void)insertBodyPanel
{
    
}
@end

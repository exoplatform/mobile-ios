//
//  SignUpViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "SignUpViewController_iPhone.h"
#import "MailInputViewController_iPhone.h"
#import "GreetingViewController_iPhone.h"

@interface SignUpViewController_iPhone ()

@end

@implementation SignUpViewController_iPhone
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)dealloc
{
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) insertBodyPanel
{
    MailInputViewController_iPhone  *mailInputViewController = [[MailInputViewController_iPhone alloc] initWithNibName:@"MailInputViewController_iPhone" bundle:nil];
    
    GreetingViewController_iPhone *greetingViewController = [[GreetingViewController_iPhone alloc] initWithNibName:@"GreetingViewController_iPhone" bundle:nil] ;
    
    mailInputViewController.view.hidden = NO;
    greetingViewController.view.hidden = YES;
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 250)]; //the view that contains mail input and greeting view
    
    [viewContainer addSubview:mailInputViewController.view];
    [viewContainer addSubview:greetingViewController.view];
    
    [self addChildViewController:mailInputViewController];
    
    [self.view addSubview:viewContainer];
    
    [mailInputViewController release];
    [greetingViewController release];
    [viewContainer release];
}

@end

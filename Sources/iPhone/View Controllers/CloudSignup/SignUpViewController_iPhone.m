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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture.jpg"]];
    
    [self insertBodyPanel];
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

// the panel that contains the input view and greeting view
// the input view is displayed first, then after receiving validation email
// the greeting view is displayed with a flip animation
- (void) insertBodyPanel
{
    mailInputViewController = [[MailInputViewController_iPhone alloc] initWithNibName:@"MailInputViewController_iPhone" bundle:nil];
    
    greetingViewController = [[GreetingViewController_iPhone alloc] initWithNibName:@"GreetingViewController_iPhone" bundle:nil] ;
    
    [self addChildViewController:mailInputViewController];
    
    UIView *viewContainer = [[[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 280)] autorelease]; //the view that contains mail input and greeting view
    
    [viewContainer addSubview:mailInputViewController.view];
    [viewContainer addSubview:greetingViewController.view];
    
    mailInputViewController.view.hidden = NO;
    greetingViewController.view.hidden = YES;
    
    [self.view addSubview:viewContainer];
    
}

@end

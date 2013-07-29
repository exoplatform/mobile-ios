//
//  SignUpViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 7/5/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "SignUpViewController_iPad.h"
#import "MailInputViewController_iPad.h"
#import "GreetingViewController_iPad.h"

@interface SignUpViewController_iPad ()

@end

@implementation SignUpViewController_iPad

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
    self.title = @"Sign Up";
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) insertBodyPanel
{
    MailInputViewController_iPad  *mailInputViewController = [[MailInputViewController_iPad alloc] initWithNibName:@"MailInputViewController_iPad" bundle:nil];
    
    GreetingViewController_iPad *greetingViewController = [[GreetingViewController_iPad alloc] initWithNibName:@"GreetingViewController_iPad" bundle:nil] ;
    
    mailInputViewController.view.hidden = NO;
    greetingViewController.view.hidden = YES;
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(40, 56, 460, 420)]; //the view that contains mail input and greeting view
    
    [viewContainer addSubview:mailInputViewController.view];
    [viewContainer addSubview:greetingViewController.view];
    
    [self addChildViewController:mailInputViewController];
    
    [self.view addSubview:viewContainer];
    
//    [mailInputViewController release];
//    [greetingViewController release];
//    [viewContainer release];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end

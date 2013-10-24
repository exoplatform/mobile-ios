//
//  ContactDetailViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/24/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "CallHistory.h"
#import <iOS-SDK/Weemo.h>
#import "CloudViewUtils.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController {
    NSMutableArray *history;
}
@synthesize bt_call = _bt_call;
@synthesize lb_full_name = _lb_full_name;
@synthesize fullName = _fullName;
@synthesize uid = _uid;
@synthesize lb_uid = _lb_uid;

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
    self.lb_full_name.text = self.fullName;
    self.lb_uid.text = self.uid;
    self.bt_call.enabled = NO;
    [CloudViewUtils configureButton:self.bt_call withBackground:@"blue_btn"];
    
    [ExoWeemoHandler sharedInstance].delegate = self;
    [[Weemo instance] getStatus:[NSString stringWithFormat:@"weemo%@", self.uid]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    _lb_full_name = nil;
    [_lb_full_name release];
    
    _lb_uid = nil;
    [_lb_uid release];
    
    _bt_call = nil;
    [_bt_call release];
    
    [_uid release];
    [_fullName release];
}

- (void)call:(id)sender
{
    [[Weemo instance] createCall:[NSString stringWithFormat:@"weemo%@",self.uid]];
}

#pragma mark ExoWeemHandlerDelegate methods

- (void)weemoHandler:(ExoWeemoHandler *)weemoHandler updateStatus:(BOOL)canBeCalled
{
    self.bt_call.enabled = canBeCalled;
}
@end

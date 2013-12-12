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
#import "JTNavigationView.h"

@interface ContactDetailViewController ()

@end

@implementation ContactDetailViewController {
    NSMutableArray *history;
}
@synthesize bt_call = _bt_call;
@synthesize lb_full_name = _lb_full_name;
@synthesize contact = _contact;
@synthesize lb_uid = _lb_uid;
@synthesize avatar = _avatar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.title = @"Details";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lb_full_name.text = self.contact.displayName;
    self.lb_uid.text = self.contact.uid;
    self.bt_call.enabled = NO;
    [CloudViewUtils configureButton:self.bt_call withBackground:@"blue_btn"];
    
    [ExoWeemoHandler sharedInstance].delegate = self;
    [[Weemo instance] getStatus:[NSString stringWithFormat:@"weemo%@", self.contact.uid]];
    
    NSURL *avatarURL = [NSURL URLWithString:[self.contact avatarURL]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:avatarURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if([imageData length] > 0)
            {
                self.avatar.image = [UIImage imageWithData:imageData];
            }
        });
    });

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
    
    _contact = nil;
    [_contact release];
    
    _avatar = nil;
    [_avatar release];
}

- (void)call:(id)sender
{
    [[Weemo instance] createCall:[NSString stringWithFormat:@"weemo%@",self.contact.uid]];
}

#pragma mark ExoWeemHandlerDelegate methods

- (void)weemoHandler:(ExoWeemoHandler *)weemoHandler updateUIWithStatus:(BOOL)canBeCalled ofContact:(NSString *)contactID
{
    self.bt_call.enabled = canBeCalled;
}
@end

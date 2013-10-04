//
//  ContactsTabViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "ContactsTabViewController_iPhone.h"
#import "ExoWeemoHandler.h"
@interface ContactsTabViewController_iPhone ()

@end

@implementation ContactsTabViewController_iPhone
@synthesize calledIdTf = _calledIdTf;
@synthesize callStatusLabel = _callStatusLabel;
@synthesize uidLabel = _uidLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Contacts";
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if([ExoWeemoHandler sharedInstance].isAuthenticated) {
        self.uidLabel.text = [NSString stringWithFormat:@"Your uid: %@",[ExoWeemoHandler sharedInstance].userId ];
    } else {
        self.uidLabel.text = @"You are not connected to Weemo";
    }
    
    self.callStatusLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_callStatusLabel release];
    [_uidLabel release];
    [_calledIdTf release];
}

-(void)call:(id)sender
{
    [[Weemo instance] createCall:self.calledIdTf.text];;
}


@end

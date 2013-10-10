//
//  DialViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/1/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "DialViewController_iPhone.h"
#import "ExoWeemoHandler.h"
@interface DialViewController_iPhone ()

@end

@implementation DialViewController_iPhone
@synthesize calledIdTf = _calledIdTf;
@synthesize uidLabel = _uidLabel;
@synthesize callButton = _callButton;
@synthesize connectButton = _connectButton;
@synthesize indicator = _indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dial";
        self.tabBarItem.title = @"Dial";
        self.tabBarItem.image = [UIImage imageNamed:@"call_video"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.indicator.hidden = YES;
    
    [self updateViewWithConnectionStatus:[Weemo instance].isConnected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [_uidLabel release];
    [_calledIdTf release];
    [_connectButton release];
    [_callButton release];
    [_indicator release];
}

-(void)call:(id)sender
{
    [[Weemo instance] createCall:self.calledIdTf.text];
    [self.calledIdTf resignFirstResponder];
}

- (void)connect:(id)sender
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    [ExoWeemoHandler sharedInstance].updatedVC = self;
    [[ExoWeemoHandler sharedInstance] connect];
}

- (void)updateViewWithConnectionStatus:(BOOL)isConnected
{
    if(isConnected) {
        self.uidLabel.text = [NSString stringWithFormat:@"Your uid: %@",[ExoWeemoHandler sharedInstance].userId ];
    } else {
        self.uidLabel.text = @"You are not connected";
    }
    
    self.callButton.enabled = isConnected;
    self.connectButton.hidden = isConnected;
    self.indicator.hidden = isConnected;
}
@end

//
//  DialViewController.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "DialViewController.h"

@interface DialViewController ()

@end

@implementation DialViewController
@synthesize calledIdTf = _calledIdTf;
@synthesize uidLabel = _uidLabel;
@synthesize callButton = _callButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Dial";
        self.tabBarItem.title = @"Dial";
        self.tabBarItem.image = [UIImage imageNamed:@"phone"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self updateViewWithConnectionStatus:[Weemo instance].isConnected];
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];

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
    [_callButton release];
}

-(void)call:(id)sender
{
    [[Weemo instance] createCall:[NSString stringWithFormat:@"weemo%@",self.calledIdTf.text]];
    [ExoWeemoHandler sharedInstance].delegate = self;
    [self.calledIdTf resignFirstResponder];
}

- (void)updateViewWithConnectionStatus:(BOOL)isConnected
{
    if(isConnected) {
        self.uidLabel.text = [NSString stringWithFormat:@"Your uid: %@",[ExoWeemoHandler sharedInstance].userId ];
    } else {
        self.uidLabel.text = @"You are not connected";
    }
    
    self.callButton.enabled = isConnected;
}

- (void)dismissKeyboards
{
    [self.calledIdTf resignFirstResponder];
}

#pragma mark ExoWeemoHandlerDelegate method

- (void)weemoHandler:(ExoWeemoHandler *)weemoHandler updateUIWithStatus:(BOOL)canBeCalled ofContact:(NSString *)contactID
{
    if(!canBeCalled)
    {
        NSString *calledUID = [contactID hasPrefix:@"weemo"] ? [contactID substringFromIndex:[@"weemo" length]] : contactID;
        
        NSString *message = [NSString stringWithFormat:Localize(@"ContactNotAvailableMessage"), calledUID];
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"ContactNotAvailableTitle") message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }
}
@end

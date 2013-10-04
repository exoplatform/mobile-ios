//
//  VideoCallViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 10/4/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "VideoCallViewController_iPhone.h"

@interface VideoCallViewController_iPhone ()

@end

@implementation VideoCallViewController_iPhone
@synthesize call = _call;
@synthesize bCameraOff = _bCameraOff;
@synthesize bVideoQuality = _bVideoQuality;
@synthesize bHangup = _bHangup;
@synthesize bMute = _bMute;
@synthesize bSwitchCamera = _bSwitchCamera;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])) {
        self.call = [[Weemo instance] activeCall];
        self.call.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    [_bCameraOff release];
    _bCameraOff = nil;
    [_bHangup release];
    _bHangup = nil;
    [_bSwitchCamera release];
    _bSwitchCamera = nil;
    [_bVideoQuality release];
    _bVideoQuality = nil;
    [_bMute release];
    _bMute = nil;
    [_call release];
    _call = nil;
}

#pragma mark Call Actions
- (void)hangup
{
    [self.call hangup];
}

- (void)switchCamera
{
    
}

- (void)changeVideoQuality
{
    
}

- (void)muteControl
{
    
}

#pragma mark WeemoCallDelegate methods
- (void)weemoCall:(id)sender videoSending:(BOOL)isSending
{
    
}

- (void)weemoCall:(id)sender videoReceiving:(BOOL)isReceiving
{
    
}

- (void)weemoCall:(id)sender videoProfile:(int)profile
{
    
}

- (void)weemoCall:(id)sender callStatus:(int)status
{
    
}
@end

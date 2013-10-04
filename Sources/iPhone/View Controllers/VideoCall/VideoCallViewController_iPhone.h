//
//  VideoCallViewController_iPhone.h
//  eXo Platform
//
//  Created by vietnq on 10/4/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOS-SDK/Weemo.h>

@interface VideoCallViewController_iPhone : UIViewController <WeemoCallDelegate>
@property (nonatomic, retain) IBOutlet UIButton *bSwitchCamera;
@property (nonatomic, retain) IBOutlet UIButton *bMute;
@property (nonatomic, retain) IBOutlet UIButton *bCameraOff;
@property (nonatomic, retain) IBOutlet UIButton *bVideoQuality;
@property (nonatomic, retain) IBOutlet UIButton *bHangup;
@property (nonatomic, retain) WeemoCall *call;
- (IBAction) switchCamera;
- (IBAction) muteControl;
- (IBAction) onOffCamera;
- (IBAction) changeVideoQuality;
- (IBAction) hangup;
@end

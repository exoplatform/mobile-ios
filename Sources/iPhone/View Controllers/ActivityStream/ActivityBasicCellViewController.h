//
//  ActivityBasicCellViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class EGOImageView;

@interface ActivityBasicCellViewController : UITableViewCell {

    IBOutlet UILabel*               _lbUsername;
    IBOutlet UILabel*               _lbMessage;
    IBOutlet UILabel*               _lbDate;
    
    IBOutlet EGOImageView*          _imgvAvatar;
    IBOutlet UIButton*              _btnLike;
    IBOutlet UIButton*              _btnComment;
    
    IBOutlet UIView*                _vMessageBg;
    IBOutlet UIImageView*           _imgvMessageBg;
}

- (void)setActivity:(Activity*)activity;
@end

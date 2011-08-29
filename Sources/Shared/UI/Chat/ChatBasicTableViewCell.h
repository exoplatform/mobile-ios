//
//  ActivityBasicTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class EGOImageView;
@class SocialActivityStream;
@class ActivityStreamBrowseViewController;
@class SocialUserProfile;

@interface ChatBasicTableViewCell : UITableViewCell {
    
    UILabel*               _lbName;
    EGOImageView*          _imgvAvatar;
}

@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;

@end

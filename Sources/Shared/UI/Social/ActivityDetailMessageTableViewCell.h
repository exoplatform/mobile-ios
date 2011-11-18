//
//  ActivityDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@class Activity;
@class EGOImageView;
@class SocialActivityStream;
@class SocialActivityDetails;
@class ActivityDetail;

@interface ActivityDetailMessageTableViewCell : UITableViewCell {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    UILabel*               _lbName;
    
    EGOImageView*          _imgvAvatar;
    UIImageView*           _imgvMessageBg;
    UIImageView*           _imgType;
    EGOImageView*          _imgvAttach;
    
    UIWebView*             _webViewForContent;
    NSInteger             _activityType;
    NSDictionary*          _templateParams;
    
    TTStyledTextLabel*     htmlLabel;
}

@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) IBOutlet UIImageView* imgType;
@property  NSInteger activityType;
@property (retain, nonatomic) NSDictionary *templateParams;

@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;
@property (retain, nonatomic) IBOutlet UIWebView* webViewForContent;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;
- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail;

@end

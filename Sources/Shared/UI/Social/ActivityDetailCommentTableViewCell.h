//
//  ActivityDetailCommentTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class EGOImageView;
@class SocialComment;

@interface ActivityDetailCommentTableViewCell : UITableViewCell {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    UILabel*               _lbName;
    
    EGOImageView*          _imgvAvatar;

    UIImageView*           _imgvMessageBg;
    UIImageView*           _imgvCellBg;
}

@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;
@property (retain, nonatomic) IBOutlet UIImageView* imgvCellBg;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;



//- (void)setActivity:(Activity*)activity;
- (void)setSocialComment:(SocialComment*)socialComment;


@end

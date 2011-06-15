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


@interface ActivityBasicTableViewCell : UITableViewCell {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    
    EGOImageView*          _imgvAvatar;
    UIButton*              _btnLike;
    UIButton*              _btnComment;
    
    UIImageView*           _imgvMessageBg;
    
}

@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain, nonatomic) IBOutlet UIButton* btnLike;
@property (retain, nonatomic) IBOutlet UIButton* btnComment;
@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;



- (void)setActivity:(Activity*)activity;


@end

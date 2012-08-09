//
//  ActivityDetailCommentTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@class Activity;
@class EGOImageView;
@class SocialComment;

@interface ActivityDetailCommentTableViewCell : UITableViewCell <UIWebViewDelegate> {
    
    UILabel*               _lbMessage;
    UILabel*               _lbDate;
    UILabel*               _lbName;
    
    EGOImageView*          _imgvAvatar;

    UIImageView*           _imgvMessageBg;
    UIImageView*           _imgvCellBg;
    
    TTStyledTextLabel  *htmlLabel;
    UIWebView*             _webViewForContent;
    
}
@property (retain, nonatomic) IBOutlet UILabel* lbDate;
@property (retain, nonatomic) IBOutlet UILabel* lbName;
@property (retain, nonatomic) IBOutlet UIWebView* webViewForContent;
@property (retain, nonatomic) IBOutlet EGOImageView* imgvAvatar;
@property (retain, nonatomic) IBOutlet UIImageView* imgvMessageBg;
@property (retain, nonatomic) IBOutlet UIImageView* imgvCellBg;
// this delegate is used to handle the click action of user on the link
@property (nonatomic, assign) id<UIWebViewDelegate> extraDelegateForWebView;
@property (nonatomic) CGFloat width;

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;



//- (void)setActivity:(Activity*)activity;
- (void)setSocialComment:(SocialComment*)socialComment;

@end

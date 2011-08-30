//
//  ActivityBasicTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPUser.h"

@interface ChatBasicTableViewCell : UITableViewCell {
    
    UILabel*               _lbName;
    UIImageView*          _imgvAvatar;
}

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;

//set user for cell
- (void)setChatUser:(XMPPUser *)chatUser;

@end

//
//  ActivityBasicTableViewCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBackgroundForCell_iPhone.h"
#import "XMPPUser.h"

@interface ChatBasicTableViewCell : CustomBackgroundForCell_iPhone {
    
    UILabel*               _lbName;
    UIImageView*          _imgvAvatar;
}

//Use this method after create the cell to customize the appearance of the Avatar
- (void)customizeAvatarDecorations;
- (void)configureCell;

//set user for cell
- (void)setChatUser:(XMPPUser *)chatUser;

@end

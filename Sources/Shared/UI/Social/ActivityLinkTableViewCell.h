//
//  ActivityLinkTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityLinkTableViewCell : ActivityBasicTableViewCell {
 
    EGOImageView*          _imgvAttach;
    TTStyledTextLabel*     _lbComment;
    TTStyledTextLabel*     _htmlLinkMessage;
    
}

@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) TTStyledTextLabel* lbComment;

@end

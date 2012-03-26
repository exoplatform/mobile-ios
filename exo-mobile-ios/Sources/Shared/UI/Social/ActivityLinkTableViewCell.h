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
    TTStyledTextLabel*     _htmlActivityMessage;
    TTStyledTextLabel*     _htmlLinkTitle;
    TTStyledTextLabel*     _htmlLinkDescription;
    TTStyledTextLabel*     _htmlName;
    TTStyledTextLabel*     _htmlLinkMessage;
    CGFloat width;
}

@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) TTStyledTextLabel* htmlActivityMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlLinkTitle;
@property (retain, nonatomic) TTStyledTextLabel* htmlLinkDescription;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;
@property (retain, nonatomic) TTStyledTextLabel* htmlLinkMessage;

@end

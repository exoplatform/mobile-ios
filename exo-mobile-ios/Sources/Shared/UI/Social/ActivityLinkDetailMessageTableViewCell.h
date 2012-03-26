//
//  ActivityLinkDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityLinkDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{

    TTStyledTextLabel*      _htmlLinkTitle;
    TTStyledTextLabel*     _htmlLinkMessage;
    TTStyledTextLabel*     _htmlActivityMessage;
    
    CGFloat width;
}
@property (retain, nonatomic) TTStyledTextLabel* htmlActivityMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlLinkTitle;
@property (retain, nonatomic) TTStyledTextLabel* htmlLinkMessage;
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;

@end

//
//  ActivityCalendarDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityCalendarDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{
    TTStyledTextLabel*                      _htmlMessage;
    TTStyledTextLabel*                      _htmlName;
    TTStyledTextLabel*                      _htmlTitle;
    CGFloat width;
}
@property (retain, nonatomic) TTStyledTextLabel* htmlName;
@property (retain, nonatomic) TTStyledTextLabel* htmlMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlTitle;
@end

//
//  ActivityCalendarTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"
@interface ActivityCalendarTableViewCell : ActivityBasicTableViewCell
{
    TTStyledTextLabel*                      _lbMessage;
    TTStyledTextLabel*                      _htmlName;
    TTStyledTextLabel*                      _htmlTitle;
    
}
@property (retain, nonatomic) TTStyledTextLabel* htmlTitle;
@property (retain, nonatomic) TTStyledTextLabel* lbMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;

@end

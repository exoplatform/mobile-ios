//
//  ActivityAnswerTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityAnswerTableViewCell : ActivityBasicTableViewCell
{
    TTStyledTextLabel*                      _lbMessage;
    TTStyledTextLabel*                      _htmlName;
    TTStyledTextLabel*                      _htmlTitle;
}

@property (retain, nonatomic) TTStyledTextLabel* lbMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;
@property (retain, nonatomic) TTStyledTextLabel* htmlTitle;
@end

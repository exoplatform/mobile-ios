//
//  ActivityForumDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityForumDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{

    TTStyledTextLabel*                      _htmlMessage;
    CGFloat width;
}
@property (retain, nonatomic) TTStyledTextLabel* htmlMessage;

@end

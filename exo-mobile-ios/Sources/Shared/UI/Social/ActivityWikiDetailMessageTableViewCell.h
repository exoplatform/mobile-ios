//
//  ActivityWikiDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityWikiDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{
    TTStyledTextLabel*                      _htmlMessage;
    TTStyledTextLabel*                      _htmlName;
    
    CGFloat width;
}
@property (retain, nonatomic) TTStyledTextLabel* htmlMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;
@end

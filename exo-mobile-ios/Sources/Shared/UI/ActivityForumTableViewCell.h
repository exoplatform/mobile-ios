//
//  ActivityForumTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"
#import "Three20/Three20.h"

@interface ActivityForumTableViewCell : ActivityBasicTableViewCell {

    
    TTStyledTextLabel*                       _lbMessage;
    TTStyledTextLabel*                      _htmlName;
    TTStyledTextLabel*                      _lbTitle;
    
}
@property (retain, nonatomic) TTStyledTextLabel* lbTitle;
@property (retain, nonatomic) TTStyledTextLabel* lbMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;


@end

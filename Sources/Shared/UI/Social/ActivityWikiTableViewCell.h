//
//  ActivityWikiTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"



@interface ActivityWikiTableViewCell : ActivityBasicTableViewCell {

    TTStyledTextLabel*                      _lbMessage;
    TTStyledTextLabel*                      _lbTitle;
    TTStyledTextLabel*                      _htmlName;
}


@property (retain, nonatomic) TTStyledTextLabel* lbMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;
@property (retain, nonatomic) TTStyledTextLabel* lbTitle;



@end

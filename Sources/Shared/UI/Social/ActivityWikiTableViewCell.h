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

    UILabel*                                _lbMessage;
    TTStyledTextLabel*                      _htmlName;

}


@property (retain, nonatomic) IBOutlet UILabel* lbMessage;
@property (retain, nonatomic) TTStyledTextLabel* htmlName;



@end

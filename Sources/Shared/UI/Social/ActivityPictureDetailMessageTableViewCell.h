//
//  ActivityPictureTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityPictureDetailMessageTableViewCell : ActivityDetailMessageTableViewCell {
    CGFloat width;
    UILabel*     _lbFileName;
    
}

@property (retain) IBOutlet UILabel* lbFileName;
@end

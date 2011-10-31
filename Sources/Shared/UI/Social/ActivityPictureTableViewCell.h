//
//  ActivityPictureTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityPictureTableViewCell : ActivityBasicTableViewCell {
    EGOImageView*          _imgvAttach;
    UILabel*               _lbFileName;
    
    TTStyledTextLabel  *htmlFileName;
}

@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain) IBOutlet UILabel* lbFileName;

-(void)setPicture;
@end

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
}
@property (retain) IBOutlet EGOImageView* imgvAttach;

-(void)setPicture;
@end

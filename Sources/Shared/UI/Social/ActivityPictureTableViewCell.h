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
    
    NSURL*                 _urlForAttachment;
}

@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain) NSURL* urlForAttachment;
@property (retain) IBOutlet UILabel* lbFileName;


//Method use to start the loading of the image Attached.
- (void)startLoadingImageAttached;

@end

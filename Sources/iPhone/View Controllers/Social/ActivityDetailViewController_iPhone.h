//
//  ActivityDetailViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityDetailViewController.h"

@class ActivityStreamBrowseViewController;
@class ActivityDetailLikeTableViewCell;

@interface ActivityDetailViewController_iPhone : ActivityDetailViewController {

}

@property (nonatomic, retain) UITableViewCell *noCommentCell;
@property (nonatomic, retain) ActivityDetailLikeTableViewCell *likeViewCell;

@end

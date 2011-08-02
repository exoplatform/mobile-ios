//
//  ActivityDetailViewController_iPad.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityDetailViewController.h"

@class ActivityStreamBrowseViewController;
@class MessageComposerViewController_iPad;

@interface ActivityDetailViewController_iPad : ActivityDetailViewController {
    
    ActivityStreamBrowseViewController* _delegate;
    MessageComposerViewController_iPad*  _messageComposerViewController;
}

@property(nonatomic, retain) ActivityStreamBrowseViewController* _delegate;

@end

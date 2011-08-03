//
//  ActivityStreamBrowseViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityStreamBrowseViewController.h"

@class MessageComposerViewController_iPhone;

@interface ActivityStreamBrowseViewController_iPhone : ActivityStreamBrowseViewController
{
    MessageComposerViewController_iPhone*  _messageComposerViewController;
}

@end

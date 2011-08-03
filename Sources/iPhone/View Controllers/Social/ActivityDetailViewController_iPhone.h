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
@class MessageComposerViewController_iPhone;

@interface ActivityDetailViewController_iPhone : ActivityDetailViewController {

    id                                     _delegate;

    MessageComposerViewController_iPhone*  _messageComposerViewController;
}

@property(nonatomic, retain) id _delegate;

//- (IBAction)onBtnMessageComposer:(id)sender;

@end

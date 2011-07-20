//
//  ActivityDetailViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class ActivityDetail;
@class ActivityDetailMessageTableViewCell;
@class ActivityDetailLikeTableViewCell;
@class SocialActivityStream;

@interface ActivityDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>{
    
    IBOutlet UITableView*                   _tblvActivityDetail;
    IBOutlet UITextView*                    _txtvEditor;
    IBOutlet UINavigationBar*               _navigationBar;
    
    UIBarButtonItem*                        _bbtnDone;
    
    CGRect                                  _sizeOrigin;
    
    Activity*                               _activity;
    SocialActivityStream*                   _socialActivityStream;
    
    //Cell for the content of the message
    ActivityDetailMessageTableViewCell*     _cellForMessage;
    
    //Cell for the like part of the screen
    ActivityDetailLikeTableViewCell*        _cellForLikes;
    
    ActivityDetail*                         _activityDetail;
    UITextView*                             _txtvMsgComposer;
    IBOutlet UIButton*                      _btnMsgComposer;    
    BOOL                                    _bIsIPad;
}

//- (void)setActivity:(Activity*)activity andActivityDetail:(ActivityDetail*)activityDetail;
- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andActivityDetail:(ActivityDetail*)activityDetail;
@end

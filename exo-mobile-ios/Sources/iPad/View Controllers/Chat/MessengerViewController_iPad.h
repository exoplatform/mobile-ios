//
//  MessengerViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessengerViewController.h"
#import "ChatWindowViewController_iPad.h"



//List of chat users
@interface MessengerViewController_iPad : MessengerViewController {
    
    ChatWindowViewController_iPad*          _chatWindowViewController;
}

@end

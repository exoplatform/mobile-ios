//
//  ExoStackScrollViewController.h
//  eXo Platform
//
//  Created by exoplatform on 9/10/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "StackScrollViewController.h"

@interface ExoStackScrollViewController : StackScrollViewController {
    NSInteger   activePaneTag;
    CGFloat     startDragPosX;
    BOOL        leftMenuOpened;
}

@end

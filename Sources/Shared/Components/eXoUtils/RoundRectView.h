//
//  RoundRectView.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 8/29/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundRectViewMask : UIView

@property (nonatomic) BOOL squareCorners;

@end

@interface RoundRectView : UIView {
    RoundRectViewMask *mask;
}

@property (nonatomic) BOOL squareCorners;

@end

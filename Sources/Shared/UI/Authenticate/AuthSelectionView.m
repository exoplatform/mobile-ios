//
//  AuthSelectionView.m
//  eXo Platform
//
//  Created by exoplatform on 7/23/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "AuthSelectionView.h"

@implementation AuthSelectionView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [[[UIImage imageNamed:@"AuthenticatePanelButtonBgOn.png"] stretchableImageWithLeftCapWidth:15                                                                                    topCapHeight:15] drawInRect:rect];
}

@end

//
//  HomeViewController_iPad.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface HomeViewController_iPad : TTViewController <TTLauncherViewDelegate> {
    id                      _delegate;
    TTLauncherView*         _launcherView;
    int                     _interfaceOrientation;
}

- (void)setDelegate:(id)delegate;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

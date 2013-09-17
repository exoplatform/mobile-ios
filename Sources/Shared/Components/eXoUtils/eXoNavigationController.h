//
//  eXoNavigationController.h
//  eXo Platform
//
//  Created by vietnq on 7/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

// subclass UINavigationController to override the method -
// -(BOOL)disablesAutomaticKeyboardDismissal
// this will fix the bug of cannot dismiss keyboard while presenting a modal view
// inside a navigation controller in iPad with form sheet style

@interface eXoNavigationController : UINavigationController

@end

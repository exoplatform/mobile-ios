//
//  UINavigationBar+ BackButtonDisplayFix.m
//  eXo Platform
//
//  Created by Ta Minh Quan on 12/3/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "UINavigationBar+ BackButtonDisplayFix.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackButtonDisplayFix)

+ (void)load
{
    if ([UIDevice currentDevice].systemVersion.intValue >= 7)
    {
        /*
         * We first try to simply add an override version of didAddSubview: to the class.  If it
         * fails, that means that the class already has its own override implementation of the method
         * (which we are expecting in this case), so use a method-swap version instead.
         */
        Method didAddMethod = class_getInstanceMethod(self, @selector(_displaybugfixsuper_didAddSubview:));
        if (!class_addMethod(self, @selector(didAddSubview:),
                             method_getImplementation(didAddMethod),
                             method_getTypeEncoding(didAddMethod)))
        {
            Method existMethod = class_getInstanceMethod(self, @selector(didAddSubview:));
            Method replacement = class_getInstanceMethod(self, @selector(_displaybugfix_didAddSubview:));
            method_exchangeImplementations(existMethod, replacement);
        }
    }
}

- (void)_displaybugfixsuper_didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [subview setNeedsDisplay];
}

- (void)_displaybugfix_didAddSubview:(UIView *)subview
{
    [self _displaybugfix_didAddSubview:subview]; // calls the existing method
    [subview setNeedsDisplay];
}

@end

//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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

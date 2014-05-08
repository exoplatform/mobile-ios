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

#import "UINavigationBar+eXoCustomIphone.h"
#import <QuartzCore/QuartzCore.h>


@implementation UINavigationBar (eXoCustomIphone) 

- (void) drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"NavbarBg.png"];
    [image drawAsPatternInRect:rect];
    [self setTintColor:[UIColor colorWithRed:39./255 green:101./255 blue:131./255 alpha:1.]];
}


-(void)willMoveToWindow:(UIWindow *)newWindow{
	[super willMoveToWindow:newWindow];
	[self applyDefaultStyle];
}

- (void)applyDefaultStyle {	
	// add the drop shadow
    self.clipsToBounds = NO;
	self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	self.layer.shadowOpacity = 0.50;
}


@end

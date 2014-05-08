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

#import "HomeStyleSheet.h"


@implementation HomeStyleSheet

- (TTStyle*)launcherButton:(UIControlState)state {
	return
    [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE(launcherButtonImage:, state) next:
	 [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13] color:[UIColor darkGrayColor]
				minimumFontSize:13 shadowColor:[UIColor whiteColor]
				   shadowOffset:CGSizeMake(1., 1.) next:nil]];
}

- (TTStyle*)launcherPageDot:(UIControlState)state {
	if (state != UIControlStateSelected) {
		return [self pageDotWithColor:[UIColor whiteColor]];
	} else {
		return [self pageDotWithColor:[UIColor colorWithRed:0.227 green:0.455 blue:0.647 alpha:1.000]];
	}
}


- (UIColor*)linkTextColor {
    return RGBCOLOR(17, 94, 173);
}

@end

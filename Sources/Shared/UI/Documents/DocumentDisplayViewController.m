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

#import "DocumentDisplayViewController.h"


@implementation DocumentDisplayViewController

// custom init method to allow URL to be passed
- (instancetype)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName
{
	if(self = [super initWithNibName:nibName bundle:nibBundle]){
        _url = [defaultURL retain];
        _fileName = [fileName retain];
    }
    
	return self;
}

#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _fileName;
}

-(NSString *) shortString : (NSString *) myString withMaxCharacter: (int) range {
    // define the range you're interested in
    if (range > [myString length]) {
        return myString;
    }
    NSRange stringRange = {0, MIN([myString length], range)};
    
    // adjust the range to include dependent chars
    stringRange = [myString rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [myString substringWithRange:stringRange];
    NSString *result = [NSString stringWithFormat:@"%@%@",shortString,@"..."];
    return result;
}


@end

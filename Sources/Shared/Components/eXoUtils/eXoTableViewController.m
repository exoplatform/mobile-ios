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

#import "eXoTableViewController.h"


@implementation eXoTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType rangeOfString:@"iPhone"].length > 0){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 40)];
    }
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor grayColor];
    
    _navigation.topItem.titleView = label;
    self.navigationItem.titleView = label;*/
}

/*
-(void)setTitle:(NSString *)_titleView {
    [super setTitle:_titleView];
    label.text = _titleView;
}
*/

-(void)dealloc {
    [super dealloc];
    //[label release];
}

@end

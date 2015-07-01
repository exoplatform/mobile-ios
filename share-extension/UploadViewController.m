//
// Copyright (C) 2003-2015 eXo Platform SAS.
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

#import "UploadViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView.layer.cornerRadius = 5.0;
    self.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(uploadViewController:didSelectCancel:)]){
        [delegate uploadViewController:self didSelectCancel:sender];
    }
}

@end

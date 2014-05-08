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

#import "MailInputViewController_iPad.h"
#import "AlreadyAccountViewController_iPad.h"
#import "WelcomeViewController_iPad.h"
@interface MailInputViewController_iPad ()

@end

@implementation MailInputViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)redirectToLoginScreen:(NSString *)email
{
    AlreadyAccountViewController_iPad *alreadyVC = [[AlreadyAccountViewController_iPad alloc] initWithNibName:@"AlreadyAccountViewController_iPad" bundle:nil];
    alreadyVC.autoFilledEmail = email;
    [self.parentViewController.navigationController pushViewController:alreadyVC animated:YES];
}
@end

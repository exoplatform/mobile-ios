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

#import "SignUpViewController_iPad.h"
#import "MailInputViewController_iPad.h"
#import "GreetingViewController_iPad.h"

@interface SignUpViewController_iPad ()

@end

@implementation SignUpViewController_iPad

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.title = @"Get Started";
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) insertBodyPanel
{
    MailInputViewController_iPad  *mailInputViewController = [[MailInputViewController_iPad alloc] initWithNibName:@"MailInputViewController_iPad" bundle:nil];
    
    GreetingViewController_iPad *greetingViewController = [[GreetingViewController_iPad alloc] initWithNibName:@"GreetingViewController_iPad" bundle:nil] ;
    
    mailInputViewController.view.hidden = NO;
    greetingViewController.view.hidden = YES;
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(40, 56, 460, 420)]; //the view that contains mail input and greeting view
    
    [viewContainer addSubview:mailInputViewController.view];
    [viewContainer addSubview:greetingViewController.view];
    
    [self addChildViewController:mailInputViewController];
    
    [self.view addSubview:viewContainer];
    
    [mailInputViewController release];
    [greetingViewController release];
    [viewContainer release];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end

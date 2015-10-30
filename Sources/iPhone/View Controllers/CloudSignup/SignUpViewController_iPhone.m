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

#import "SignUpViewController_iPhone.h"
#import "MailInputViewController_iPhone.h"
#import "GreetingViewController_iPhone.h"

@interface SignUpViewController_iPhone ()

@end

@implementation SignUpViewController_iPhone
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) insertBodyPanel
{
    MailInputViewController_iPhone  *mailInputViewController = [[MailInputViewController_iPhone alloc] initWithNibName:@"MailInputViewController_iPhone" bundle:nil];
    
    GreetingViewController_iPhone *greetingViewController = [[GreetingViewController_iPhone alloc] initWithNibName:@"GreetingViewController_iPhone" bundle:nil] ;
    
    mailInputViewController.view.hidden = NO;
    greetingViewController.view.hidden = YES;
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 280, 250)]; //the view that contains mail input and greeting view
    
    [viewContainer addSubview:mailInputViewController.view];
    [viewContainer addSubview:greetingViewController.view];
    
    [self addChildViewController:mailInputViewController];
    
    [self.view addSubview:viewContainer];
    
}

@end

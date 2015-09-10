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
#define scrollUp 60 //scroll up when the keyboard appears

#import "AlreadyAccountViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "eXoViewController.h"

@interface AlreadyAccountViewController_iPhone ()

@end

@implementation AlreadyAccountViewController_iPhone

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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] ;
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    
    self.scrollView.contentSize  =  CGRectInset(self.scrollView.frame,0,50).size;
    self.scrollView.scrollEnabled = YES;
    
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


- (void)connectToOnPremise:(id)sender
{
    
    OnPremiseViewController_iPhone *onPremiseViewController = [[OnPremiseViewController_iPhone alloc] initWithNibName:@"OnPremiseViewController_iPhone" bundle:nil];
    
    [self.navigationController pushViewController:onPremiseViewController animated:YES];
}

#pragma mark LoginProxyDelegate methods
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
}

#pragma mark - Keyboard management
- (void) keyboardDidShow {
    [self.scrollView setContentOffset:CGPointMake(0, scrollUp) animated:YES];
}
- (void) keyboardDidHide {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void)dismissKeyboards
{
    [super dismissKeyboards];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    [_scrollView release];
    [super dealloc];
}
@end

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

#import "AlreadyAccountViewController_iPad.h"
#import "OnPremiseViewController_iPad.h"
#import "AppDelegate_iPad.h"
@interface AlreadyAccountViewController_iPad ()

@end

@implementation AlreadyAccountViewController_iPad

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connectToOnPremise:(id)sender
{
    OnPremiseViewController_iPad *onPremiseViewController = [[OnPremiseViewController_iPad alloc] initWithNibName:@"OnPremiseViewController_iPad" bundle:nil];
    
    [self.navigationController pushViewController:onPremiseViewController animated:YES];
}

#pragma mark LoginProxyDelegate methods


- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    // go the deepest presenting view controller to dismiss modal view
    // to avoid bug of presenting an active modal view
    WelcomeViewController_iPad *welcomeVC = (WelcomeViewController_iPad *)self.navigationController.presentingViewController;
    if(welcomeVC.shouldBackToSetting) {
        [welcomeVC.presentingViewController dismissViewControllerAnimated:NO completion:^{
            //show activity stream
            [appDelegate showHome];
        }];
        
    } else {
        [welcomeVC dismissViewControllerAnimated:NO completion:^{
            //show activity stream
            [appDelegate showHome];
        }];
    }
}

@end

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

#import "OnPremiseViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "eXoViewController.h"

@interface OnPremiseViewController_iPhone ()
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation OnPremiseViewController_iPhone

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
    // The wantsFullScreenLayout view controller property is deprecated in iOS 7. If you currently specify wantsFullScreenLayout = NO, the
    //view controller may display its content at an unexpected screen location when it runs in iOS 7.To adjust how a view controller lays
    //out its views, UIViewController provides edgesForExtendedLayout. Detail in this document: https://developer.apple.com/library/prerelease/ios/documentation/UserExperience/Conceptual/TransitionGuide/AppearanceCustomization.html
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)] ;
    [tapGesure setCancelsTouchesInView:NO]; // Processes other events on the subviews
    [self.view addGestureRecognizer:tapGesure];

    // Notifies when the keyboard is shown/hidden
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];

    self.scrollView.contentSize  =  CGRectInset(self.scrollView.frame,0,50).size;
    self.scrollView.scrollEnabled = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect viewRect = self.view.frame;
    viewRect.origin.y = 0;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [_scrollView release];
    [super dealloc];
}
#pragma mark LoginProxyDelegate methods

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    self.view.userInteractionEnabled = YES;
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];

    //show activity stream
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    
    [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
    
}

#pragma mark - Keyboard management
- (void) keyboardDidShow {
    [self.scrollView setContentOffset:CGPointMake(0, scrollHeight) animated:YES];
}
- (void) keyboardDidHide {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) dismissKeyboards
{
    [super dismissKeyboards];
}

@end

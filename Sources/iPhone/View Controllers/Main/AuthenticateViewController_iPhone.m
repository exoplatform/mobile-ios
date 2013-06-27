//
//  AuthenticateViewController.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "LanguageHelper.h"
#import "AuthTabItem.h"
#import "eXoViewController.h"
#define scrollHeight 80 /* how much should we scroll up/down when the keyboard is displayed/hidden */
#define tabViewsTopMargin 6 /* the top margin of the views under the tabs */
#define tabsHeightAndLeftMargin 30 /* the height and left margin of the tabs */
#define tabsWidth 110 /* defines the width of the clickable area */
#define tabsY 180 /* distance from the top of the screen to the top of the tabs */

@implementation AuthenticateViewController_iPhone
@synthesize backgroundImage = _backgroundImage;

#pragma mark - Object Management
-(void)dealloc {
    
    [_settingsViewController release];
    _settingsViewController = nil;
    [_backgroundImage release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([eXoViewController isHighScreen]) {
        [_backgroundImage setImage:[UIImage imageNamed:@"Default-568h"]];
    } else {
        [_backgroundImage setImage:[UIImage imageNamed:@"Default"]];
    }
    
    // Position the tabs just above the subviews
    [self.tabView setFrame:
     CGRectMake((self.view.center.x-_credViewController.view.bounds.size.width/2)+tabsHeightAndLeftMargin,
                tabsY,
                tabsWidth,
                tabsHeightAndLeftMargin)];
    // Position the views and allow them to be resized properly when the orientation changes
    [_credViewController.view setFrame:
     CGRectMake(self.view.center.x-_credViewController.view.bounds.size.width/2,
                self.tabView.frame.origin.y+self.tabView.frame.size.height+tabViewsTopMargin,
                _credViewController.view.bounds.size.width,
                _credViewController.view.bounds.size.height)];
    [_credViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    
    [_servListViewController.view setFrame:
     CGRectMake(self.view.center.x-_servListViewController.view.bounds.size.width/2,
                self.tabView.frame.origin.y+self.tabView.frame.size.height+tabViewsTopMargin,
                _servListViewController.view.bounds.size.width,
                _servListViewController.view.bounds.size.height)];
    [_servListViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    // Position the settings btn at the bottom
    [_btnSettings setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];

    //Stevan UI fixes
    _credViewController.panelBackground.image = 
    [[UIImage imageNamed:@"AuthenticatePanelBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25]; 
    
    _servListViewController.panelBackground.image = 
    [[UIImage imageNamed:@"AuthenticatePanelBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25];

}

-(void) initTabsAndViews {
    // Creating the sub view controllers
    _credViewController = [[CredentialsViewController alloc] initWithNibName:@"CredentialsViewController_iPhone" bundle:nil];
    _credViewController.authViewController = self;
    
    _servListViewController = [[ServerListViewController alloc] initWithNibName:@"ServerListViewController_iPhone" bundle:nil];
    
    // Initializing the Tab items and adding them to the Tab view
    AuthTabItem * tabItemCredentials = [AuthTabItem tabItemWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateCredentialsIconIphoneOff"] alternateIcon:[UIImage imageNamed:@"AuthenticateCredentialsIconIphoneOn"]];
    [self.tabView addTabItem:tabItemCredentials];
    
    AuthTabItem * tabItemServerList = [AuthTabItem tabItemWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateServersIconIphoneOff"] alternateIcon:[UIImage imageNamed:@"AuthenticateServersIconIphoneOn"]];
    [self.tabView addTabItem:tabItemServerList];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_credViewController.bAutoLogin && ![self autoLoginIsDisabled])
        [_credViewController onSignInBtn:nil];
}

#pragma mark - Keyboard management

-(void)manageKeyboard:(NSNotification *) notif {
    if (notif.name == UIKeyboardDidShowNotification) {
        [self setViewMovedUp:YES];
    } else if (notif.name == UIKeyboardDidHideNotification) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        viewRect.origin.y -= scrollHeight;
    }
    else
    {
        viewRect.origin.y = 0;
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}


- (IBAction)onSettingBtn
{
    if (_settingsViewController == nil) {
        
        _settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _settingsViewController.settingsDelegate = self;
    }
    [_settingsViewController startRetrieve];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_settingsViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:navController animated:YES];
    
    
}

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHomeSidebarViewController) withObject:nil afterDelay:1.0];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _credViewController.txtfUsername) 
    {
        [_credViewController.txtfPassword becomeFirstResponder];
    }
    else
    {    
        [_credViewController.txtfPassword resignFirstResponder];
                
        [_credViewController onSignInBtn:nil];
    }    
	return YES;
}

#pragma mark - Settings Delegate methods

- (void)doneWithSettings {
    [super doneWithSettings];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end



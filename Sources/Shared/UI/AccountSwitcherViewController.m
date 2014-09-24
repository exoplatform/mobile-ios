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


#import "AccountSwitcherViewController.h"
#import "AccountSwitcherTableViewCell.h"
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"
#import "AppDelegate_iPhone.h"
#import "SSHUDView.h"
#import "LoginProxy.h"
#import "LanguageHelper.h"
#import "NSDate+Formatting.h"
#import "defines.h"

static NSString *CellIdentifierAccount = @"CellIdentifierAccount";

@interface AccountSwitcherViewController ()

@property (nonatomic, retain) NSMutableArray* listOfAccounts;
@property (nonatomic, assign) int             currentAccount;
@property (nonatomic, retain) SSHUDView*      hud; // display loading
@property (nonatomic, retain) LoginProxy*     login;

@end

@implementation AccountSwitcherViewController

@synthesize listOfAccounts;
@synthesize currentAccount;
@synthesize accountSwitcherDelegate;
@synthesize hud = _hud;
@synthesize login;

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listOfAccounts = [[ApplicationPreferencesManager sharedInstance] serverList];
        self.currentAccount = [[ApplicationPreferencesManager sharedInstance] selectedServerIndex];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//  The nib is loaded in the iPhone and iPad specific children classes
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Done button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton")
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    // Accounts title
    self.title = Localize(@"ServerList");
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

}

- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

- (void)dealloc
{
    self.listOfAccounts = nil;
    self.currentAccount = nil;
    self.accountSwitcherDelegate = nil;
    self.hud = nil;
    self.login = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doneAction {
    if (self.accountSwitcherDelegate) [self.accountSwitcherDelegate didCloseAccountSwitcher];
}

#pragma mark Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return [self.listOfAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountSwitcherTableViewCell* cell;
    // Because the prototype cell is defined in a nib, the dequeueReusableCellWithIdentifier: method always returns a valid cell.
    // No need to check the return value against nil and create a cell manually.
    // https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableViewCells/TableViewCells.html#//apple_ref/doc/uid/TP40007451-CH7-SW20
    cell = (AccountSwitcherTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierAccount];
    
    ServerObj* account = [self.listOfAccounts objectAtIndex:indexPath.row];
    cell.accountNameLabel.text = [account.accountName uppercaseString];
    cell.accountServerUrlLabel.text = account.serverUrl;
    cell.accountUserFullNameLabel.text = // Display the user's full name if it is set, nothing otherwise
        (account.userFullname!=nil) ? account.userFullname : @"";
    cell.accountUsernameLabel.text = account.username;
    
    ServerObj* selectedAccount = [[ApplicationPreferencesManager sharedInstance] getSelectedAccount];
    if ([account isEqual:selectedAccount]) {
        // Showing the connected user, we display a label "Connected"
        cell.accountLastLoginDateLabel.text = Localize(@"Connected");
    } else {
        // Showing signed out user, we display the last login date if it exists, nothing otherwise
        if (account.lastLoginDate > 0) {
            NSDate* lastLogin = [NSDate dateWithTimeIntervalSince1970:account.lastLoginDate];
            cell.accountLastLoginDateLabel.text =
                 [NSString stringWithFormat:@"%@: %@", Localize(@"Last login"), [lastLogin distanceOfTimeInWords]];
        } else {
            cell.accountLastLoginDateLabel.text = @"";
        }
    }
    cell.accountAvatarView.placeholderImage = [UIImage imageNamed:@"IconForNoContact.png"];
    if (![self.tableView isDragging] && ![self.tableView isDecelerating]) {
        cell.accountAvatarView.imageURL = [NSURL URLWithString:account.avatarUrl];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerObj* selectedAccount = [self.listOfAccounts objectAtIndex:indexPath.row];
    if ([selectedAccount isEqual:[[ApplicationPreferencesManager sharedInstance] getSelectedAccount]])
    {
        // if the current account is selected, simply close the account switcher
        [self doneAction];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL rememberUser = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@_%@_remember_me",
                                                     selectedAccount.serverUrl, selectedAccount.username]] boolValue];
    NSString* password = [userDefaults objectForKey:[NSString stringWithFormat:@"%@_password",selectedAccount.serverUrl]];
    if (![selectedAccount.username isEqualToString:@""] && ![password isEqualToString:@""] && rememberUser)
    {
        [UserPreferencesManager sharedInstance].isUserLogged = NO;
        [LoginProxy doLogout];
//        [self.hud setLoading:YES];
        [self.hud show];
        [self view].userInteractionEnabled = NO;
        [[ApplicationPreferencesManager sharedInstance] setSelectedServerIndex:indexPath.row];
        self.login = [[LoginProxy alloc] initWithDelegate:self username:selectedAccount.username password:password serverUrl:selectedAccount.serverUrl];
        [self.login authenticate];
    } else {
        // TODO open the sign-in screen
    }
}

- (void)restartAppDelegateAfterLogin:(BOOL)compatibleWithSocial
{
    [NSException raise:@"AbstractMethodCallException"
                format:@"Method restartAppDelegateAfterLogin must be overridden in iPhone and iPad classes"];
}

#pragma mark Login proxy delegate methods

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    [self.hud setHidden:YES];
    [self view].userInteractionEnabled = YES;
    
    [self restartAppDelegateAfterLogin:compatibleWithSocial];
}

- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    [self.hud dismiss];
    [self.hud setHidden:YES];
    [self view].userInteractionEnabled = YES;
}

@end

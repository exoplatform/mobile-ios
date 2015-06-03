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


#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    
    Account * account = self.allAccounts[indexPath.row];
    cell.textLabel.text = account.accountName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", account.userName, account.serverURL];
    // Configure the cell...
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Account * account = self.allAccounts[indexPath.row];
    // The account is selected, if this account have a password configured: go back to ShareVC, if not: Popup a message alert to ask user to configure the password for this account. 
    if (account.password.length >0){
        if (delegate && [delegate respondsToSelector:@selector(accountSelection:didSelectAccount:)]) {
            [delegate accountSelection:self didSelectAccount:account];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Login",nil) message:NSLocalizedString(@"Enter the password",nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // configuration of the password's text feild
            textField.backgroundColor = [UIColor clearColor];
            textField.placeholder = NSLocalizedString(@"password",nil);
            textField.secureTextEntry = YES;
        }];
        // Ok button
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  account.password = ((UITextField*)alert.textFields[0]).text;
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  if (delegate && [delegate respondsToSelector:@selector(accountSelection:didSelectAccount:)]) {
                                                                      [delegate accountSelection:self didSelectAccount:account];
                                                                  }
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        // Cancel button
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];

        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end

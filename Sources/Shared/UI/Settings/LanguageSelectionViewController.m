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


#import "LanguageSelectionViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"
#import "defines.h"

@interface LanguageSelectionViewController ()

@end

@implementation LanguageSelectionViewController
@synthesize listLanguages;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localize(@"Language");
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listLanguages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomBackgroundForCell_iPhone *cell;
    cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:@"LanguageCell"];
    if(cell == nil)
    {
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LanguageCell"] autorelease];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.textLabel.text = listLanguages[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"EN.gif"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"FR.gif"];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"DE.gif"];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"ES.gif"];
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"BR.gif"];
            break;
    }
    
    //Put the checkmark
    int selectedLanguage = [[LanguageHelper sharedInstance] getSelectedLanguage];
    if (indexPath.row == selectedLanguage)
    {
        cell.accessoryView = [self makeCheckmarkOnAccessoryView];
    }
    else
    {
        cell.accessoryView = [self makeCheckmarkOffAccessoryView];
    }


    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedLanguage = indexPath.row;
    
    //Save the language
    [[LanguageHelper sharedInstance] changeToLanguage:selectedLanguage];
    
    //Finally reload the content of the screen
    [self.tableView reloadData];
    
    self.navigationItem.title = Localize(@"Language");

    //Notify the language change
    [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_CHANGE_LANGUAGE object:self];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}


#pragma - UI Customizations for cells

-(UIImageView *) makeCheckmarkOffAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
}

@end

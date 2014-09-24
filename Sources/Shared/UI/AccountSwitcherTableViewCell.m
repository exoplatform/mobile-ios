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


#import "AccountSwitcherTableViewCell.h"
#import "defines.h"

#define kAccountSwitcherCellHeaderBackgroundColor [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] /*#f0f0f0*/
#define kAccountSwitcherCellHeaderNameColor       [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] /*#333333*/
#define kAccountSwitcherCellHeaderLinkColor       [UIColor colorWithRed:0.184 green:0.369 blue:0.573 alpha:1] /*#2f5e92*/
#define kAccountSwitcherCellBodyConnLabelColor    [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] /*#999999*/

@interface AccountSwitcherTableViewCell ()

@property (nonatomic, retain) IBOutlet UIView* cellHeaderView;

@end

@implementation AccountSwitcherTableViewCell

@synthesize cellHeaderView;
@synthesize accountNameLabel;
@synthesize accountServerUrlLabel;
@synthesize accountAvatarView;
@synthesize accountUserFullNameLabel;
@synthesize accountUsernameLabel;
@synthesize accountLastLoginDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = EXO_BACKGROUND_COLOR;
    self.contentView.backgroundColor = EXO_BACKGROUND_COLOR;
    self.cellHeaderView.backgroundColor = kAccountSwitcherCellHeaderBackgroundColor;
    self.accountNameLabel.textColor = kAccountSwitcherCellHeaderNameColor;
    self.accountServerUrlLabel.textColor = kAccountSwitcherCellHeaderLinkColor;
    self.accountLastLoginDateLabel.textColor = kAccountSwitcherCellBodyConnLabelColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.cellHeaderView = nil;
    self.accountNameLabel = nil;
    self.accountServerUrlLabel = nil;
    self.accountAvatarView = nil;
    self.accountUserFullNameLabel = nil;
    self.accountUsernameLabel = nil;
    self.accountLastLoginDateLabel = nil;
    [super dealloc];
}

@end

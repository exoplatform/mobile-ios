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


#import "SpaceTableViewCell.h"
#import "ApplicationPreferencesManager.h"
#import "LanguageHelper.h"
@implementation SpaceTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_prefixLabel release];
    [_spaceAvatar release];
    [_spaceName release];
    [super dealloc];
}
-(void) setSpace:(SocialSpace *)space {
    if (!space) {
    } else {
    
    }
    if (!space) {
        self.spaceName.text = Localize(@"Public");
        self.spaceAvatar.image = [UIImage imageNamed:@"global-icon.png"];
        
    } else {
        self.spaceName.text= space.displayName;
        self.spaceAvatar.imageURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[ApplicationPreferencesManager sharedInstance].selectedDomain, space.avatarUrl]];
    }
}
@end

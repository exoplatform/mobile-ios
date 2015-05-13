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


#import "AuthenticateTabView.h"

@interface AuthenticateTabView()
@property (nonatomic,retain) AuthTabItem* accountSwitcherTabItem;
@end

@implementation AuthenticateTabView

@synthesize accountSwitcherTabItem;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.switcherTabIsVisible = YES;
    }
    return self;
}

-(void)dealloc
{
    self.accountSwitcherTabItem = nil;
    [super dealloc];
}

-(void)setShowSwitcherTab:(BOOL)show
{
    if (!self.switcherTabIsVisible && show)
    {
        // tab is hidden and we ask to show it
        [self addTabItem:self.accountSwitcherTabItem];
        self.accountSwitcherTabIndex = 1;
    }
    else if(self.switcherTabIsVisible && !show)
    {
        // tab is visible and we ask to hide it
        [self removeTabItemAtIndex:self.accountSwitcherTabIndex];
        [self setSelectedIndex:0];
        self.accountSwitcherTabIndex = -1;
    }
    self.switcherTabIsVisible = show;
}

-(void) addCredentialsTabItem:(AuthTabItem *)credentialsTabItem AndSwitcherTabItem:(AuthTabItem *)switcherTabItem
{
    [self removeAllTabItems];
    [self addTabItem:credentialsTabItem];
    [self addTabItem:switcherTabItem];
    self.accountSwitcherTabItem = switcherTabItem;
    self.accountSwitcherTabIndex = 1;
}


@end

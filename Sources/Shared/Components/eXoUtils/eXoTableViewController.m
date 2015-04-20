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

#import "eXoTableViewController.h"
#import "LanguageHelper.h"

@implementation eXoTableViewController

@synthesize hudLoadWaiting = _hudLoadWaiting;
@synthesize navigation, label;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)dealloc {
//    self.label = nil;
//    self.navigation = nil;
    [super dealloc];
}

#pragma mark - hudLoadWaiting
- (ATMHud *)hudLoadWaiting {
    // lazy loading
    if (!_hudLoadWaiting) {
        _hudLoadWaiting = [[ATMHud alloc] initWithDelegate:nil];
        // disable user interaction during the loading.
        [_hudLoadWaiting setAllowSuperviewInteraction:NO];
    }
    return _hudLoadWaiting;
}

- (void)updateHudPosition {
    // default implementation
}

- (ATMHud *)hudLoadWaitingWithPositionUpdated {
    ATMHud *hudLoad = [self hudLoadWaiting];
    [self updateHudPosition];
    return hudLoad;
}

- (void)displayHudLoader {
    [self displayHUDLoaderWithMessage:Localize(@"Loading")];
}

- (void)displayHUDLoaderWithMessage:(NSString *)message {
    [self.hudLoadWaitingWithPositionUpdated setCaption:message];
    [self.hudLoadWaiting setActivity:YES];
    [self.hudLoadWaiting show];
}

- (void)hideLoader:(BOOL)successful {
    [self.hudLoadWaitingWithPositionUpdated setActivity:NO];
    if (successful) {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"19-check"]];
        [self.hudLoadWaiting setCaption:Localize(@"Success")];
        [self.hudLoadWaiting hideAfter:0.5];
    } else {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"11-x"]];
        [self.hudLoadWaiting setCaption:Localize(@"Error")];
        [self.hudLoadWaiting hideAfter:1.0];
    }
    [self.hudLoadWaiting update];
}

- (void)hideLoaderImmediately:(BOOL)successful {
    [self.hudLoadWaitingWithPositionUpdated setActivity:NO];
    if (successful) {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"19-check"]];
        [self.hudLoadWaiting setCaption:Localize(@"Success")];
    } else {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"11-x"]];
        [self.hudLoadWaiting setCaption:Localize(@"Error")];
    }
    [self.hudLoadWaiting hide];
}

@end

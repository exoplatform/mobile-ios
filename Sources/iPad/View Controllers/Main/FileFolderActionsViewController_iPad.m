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

#import "FileFolderActionsViewController_iPad.h"

@implementation FileFolderActionsViewController_iPad

- (void)updateUI
{        
    if(_isNewFolder) {
		_navigation.topItem.title = Localize(@"NewFolderTitle");
	}
	else {
		_navigation.topItem.title = Localize(@"RenameTitle");	
	}
    
    _navigation.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"OK") style:UIBarButtonItemStyleDone target:self action:@selector(OKBtn)];
    
    _navigation.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(CancelBtn)];
    
}

- (void)OKBtn {
    
    NSString* strName = [_txtfNameInput text];
	strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_isNewFolder) {
        [self.delegate createNewFolder:strName];
    } else {
        [self.delegate renameFolder:strName forFolder:_fileToApplyAction];
    }    
    
}


- (void)CancelBtn {
    
    [self.delegate cancelFolderActions];
    
}

@end

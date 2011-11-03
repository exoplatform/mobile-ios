//
//  FileFolderActionsViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/30/10.
//  Copyright 2010 home. All rights reserved.
//

#import "FileFolderActionsViewController_iPad.h"

@implementation FileFolderActionsViewController_iPad

- (void)updateUI
{        
    if(_isNewFolder) {
		self.title = Localize(@"NewFolderTitle");
	}
	else {
		self.title = Localize(@"RenameTitle");	
	}
    
    _navigation.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(OKBtn)];
    
}

- (void)OKBtn {
    
    NSString* strName = [_txtfNameInput text];
	strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_isNewFolder) {
        [_delegate createNewFolder:strName];
    } else {
        [_delegate renameFolder:strName forFolder:_fileToApplyAction];
    }    
    
}


@end

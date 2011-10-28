//
//  FileFolderActionsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 02/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileFolderActionsViewController_iPhone.h"
#import "File.h"

@implementation FileFolderActionsViewController_iPhone


- (void)updateUI
{        
    if(_isNewFolder) {
		self.navigationItem.title = Localize(@"NewFolderTitle");
	}
	else {
		self.navigationItem.title = Localize(@"RenameTitle");	
	}
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(OKBtn)];
    
}

- (void)OKBtn {
    
    NSString* strName = [_txtfNameInput text];
	strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_isNewFolder) {
        [_delegate createNewFolder:strName];
    } else {
        [_delegate renameFolder:strName forFolder:_fileToApplyAction];
    }    
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

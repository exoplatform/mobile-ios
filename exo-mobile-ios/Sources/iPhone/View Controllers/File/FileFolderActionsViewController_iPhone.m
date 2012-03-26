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
		self.title = Localize(@"NewFolderTitle");
	}
	else {
		self.title = Localize(@"RenameTitle");	
	}
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"OK") 
                                                                              style:UIBarButtonItemStyleDone 
                                                                             target:self 
                                                                             action:@selector(OKBtn)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Cancel") 
                                                                             style:UIBarButtonItemStylePlain 
                                                                            target:self 
                                                                            action:@selector(CancelBtn)];
    
}

- (void)OKBtn {
    
    NSString* strName = [_txtfNameInput text];
	strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_isNewFolder) {
        [_delegate createNewFolder:strName];
    } else {
        [_delegate renameFolder:strName forFolder:_fileToApplyAction];
    }    
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)CancelBtn {

    [_delegate cancelFolderActions];
    
}






#pragma mark - Rotation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end

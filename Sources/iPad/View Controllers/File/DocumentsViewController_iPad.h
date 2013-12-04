//
//  DocumentsViewController_iPad.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DocumentsViewController.h"
#import "File.h"
#import "WEPopoverController.h"




////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Display file list
@interface DocumentsViewController_iPad : DocumentsViewController <UIPopoverControllerDelegate,WEPopoverControllerDelegate>
{    
    WEPopoverController *_actionPopoverController;
    UIPopoverController *_fileFolderActionsPopoverController;
}

- (void)dismissAddPhotoPopOver:(BOOL)animation;

@end

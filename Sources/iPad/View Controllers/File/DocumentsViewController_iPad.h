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




////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Display file list
@interface DocumentsViewController_iPad : DocumentsViewController <UIPopoverControllerDelegate>
{
    IBOutlet UINavigationBar* _navigationBar;
    
    UIPopoverController *_actionPopoverController;
    
}

@end

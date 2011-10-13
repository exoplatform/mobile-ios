//
//  DocumentsViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController.h"
#import "FileActionsViewController.h"
#import "WEPopoverController.h"


@interface DocumentsViewController_iPhone : DocumentsViewController <WEPopoverControllerDelegate, UIPopoverControllerDelegate>{
    
    FileActionsViewController *_actionsViewController;
    
    WEPopoverController *popoverController;
    WEPopoverController *popoverClass;
    NSInteger currentPopoverCellIndex;
    
}
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain) WEPopoverController *popoverClass;

@end

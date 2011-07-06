//
//  FilesViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilesProxy.h"
#import "FileActionsViewController_iPhone.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"



@interface FilesViewController_iPhone : UITableViewController <FileActionsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, ATMHudDelegate> {
    
    File *_rootFile;
    
    NSArray *_arrayContentOfRootFile;
    
    FilesProxy *_filesProxy;
    
    FileActionsViewController_iPhone *_actionsViewController;
    
    UIView *_maskingViewForActions;
    
    ATMHud *_hudFolder;//Heads up display
    
}

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile; 


@end

//
//  FilesViewController_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilesProxy.h"


@interface FilesViewController_iPhone : UITableViewController {
    
    File *_rootFile;
    
    NSArray *_arrayContentOfRootFile;
    
    FilesProxy *_filesProxy;
    
}

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile; 


@end

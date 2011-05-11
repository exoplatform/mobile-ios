//
//  DashboardViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@class GadgetDisplayViewController;

@interface DashboardViewController_iPhone : UIViewController <UITableViewDataSource, UITableViewDelegate>{

    NSMutableArray*		_arrTabs;	//Gadget array 
    
    IBOutlet UITableView*   _tblGadgets;
    GadgetDisplayViewController* _gadgetDisplayViewController;	//Display gadget
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;

@end

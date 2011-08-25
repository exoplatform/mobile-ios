//
//  DashboardViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray*         _arrTabs;	//Gadget array 
    IBOutlet UITableView*   _tblGadgets;
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;
    

@end

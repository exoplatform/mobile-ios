//
//  DashboardViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardProxy.h"

@interface DashboardViewController : UIViewController <DashboardProxyDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray*         _arrTabs;	//Gadget array 
    IBOutlet UITableView*   _tblGadgets;
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;
    

@end

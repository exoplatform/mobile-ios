//
//  DashboardViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardProxy.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"

@interface DashboardViewController : UIViewController <DashboardProxyDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray*         _arrTabs;	//Gadget array 
    IBOutlet UITableView*   _tblGadgets;
    
    //Loader
    ATMHud*                 _hudDashboard;//Heads up display
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;

- (void)setHudPosition;

    

@end

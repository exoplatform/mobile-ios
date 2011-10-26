//
//  DashboardViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardProxy_old.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "eXoViewController.h"
//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44

@interface DashboardViewController : eXoViewController <DashboardProxyDelegate_old, UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray*         _arrTabs;	//Gadget array 
    IBOutlet UITableView*   _tblGadgets;
    
    //Loader
    ATMHud*                 _hudDashboard;//Heads up display
}

@property(nonatomic, retain) NSMutableArray* _arrTabs;

- (void)setHudPosition;
- (void)emptyState;
- (void)customizeAvatarDecorations:(UIImageView *)_imgvAvatar;

@end

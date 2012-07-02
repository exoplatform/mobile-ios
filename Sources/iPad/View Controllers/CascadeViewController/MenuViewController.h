//
//  MenuViewController.h
//  StackScrollView
//
//  Created by Reefaq on 2/24/11.
//  Copyright 2011 raw engineering . All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SettingsViewController_iPad.h"


@class UserProfileViewController;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SettingsDelegateProcotol> {
	
    
	UITableView*  _tableView;
	NSMutableArray* _cellContents;

    UINavigationController*         _modalNavigationSettingViewController;
    
	int									_intSelectedLanguage;

    int                             _intIndex;
    
    UIView*                         _footer; 
    BOOL                            _isCompatibleWithSocial;
    
}
@property(nonatomic, retain)UITableView* tableView;
@property BOOL isCompatibleWithSocial;
@property (nonatomic, retain) UserProfileViewController *userProfileViewController;

- (id)initWithFrame:(CGRect)frame isCompatibleWithSocial:(BOOL)compatibleWithSocial;
- (void)setPositionsForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

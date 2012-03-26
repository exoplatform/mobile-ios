//
//  eXoGadgetViewController.h
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GateInDbItem;
@class eXoApplicationsViewController;

@interface eXoGadgetViewController : UITableViewController {
	GateInDbItem *_gadgetTab;
	eXoApplicationsViewController *_delegate;
}

- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate 
		  gadgetTab:(GateInDbItem *)gagetTab;

@end

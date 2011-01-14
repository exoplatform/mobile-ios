//
//  eXoGadgetViewController.h
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GateInDbItem_iPhone;
@class eXoApplicationsViewController;

@interface eXoGadgetViewController : UITableViewController {
	GateInDbItem_iPhone *_gadgetTab;
	eXoApplicationsViewController *_delegate;
}

- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate 
		  gadgetTab:(GateInDbItem_iPhone *)gagetTab;

@end

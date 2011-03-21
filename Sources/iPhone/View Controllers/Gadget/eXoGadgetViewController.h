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
@class GadgetDisplayViewController;

//Display gadgets in each tab
@interface eXoGadgetViewController : UITableViewController {
	GateInDbItem_iPhone *_gadgetTab;	//Gadget tab contains gadgets
	eXoApplicationsViewController *_delegate;	//Main eXo app
	GadgetDisplayViewController* _gadgetDisplayViewController;	//Display gadget
}

//Constructor
- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate 
		  gadgetTab:(GateInDbItem_iPhone *)gagetTab;

@end

//
//  AppContainerViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/9/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GadgetViewController;
@class Connection;
@class Gadget_iPad;

//Dis play root view of splitview, including: eXo app and gadgets
@interface AppContainerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	id										_delegate;	//The delegate
	IBOutlet UITableView*					_tblAppList;	//eXo apps list
	IBOutlet UIButton*						_btnGrid;	//Change gadget display mode
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
	
	GadgetViewController*					_gadgetViewController;	//Gadget view controller
	
	NSMutableArray*							_arrGadgets;	//Gadget list
	NSMutableArray*							_arrGateInDbItems;	//Gadget tab list
	Connection*								_connection;	//Interact with server
	BOOL									_bGrid;	//Is in grid view mode
	BOOL									_bExistGadget;	//Exist gadget or not
}

- (UITableView*)getTableViewAppList;	//Get table view app list
- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Set language dictionary
- (Connection*)getConnection;	//Get connection
- (void)setSelectedLanguage:(int)languageId;	//Set language
- (int)getSelectedLanguage;	//Get current language
- (NSDictionary*)getLocalization;	//Get language dictionary
- (void)loadGadgets;	//Load gadgets
- (void)onGadget:(Gadget_iPad*)gadget;	//View gadget
- (IBAction)onGridBtn:(id)sender;	//Change gadget view mode
@end

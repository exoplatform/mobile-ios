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
@class Gadget;

@interface AppContainerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	id										_delegate;
	IBOutlet UITableView*					_tblAppList;
	IBOutlet UIButton*						_btnGrid;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
	
	GadgetViewController*					_gadgetViewController;
	
	NSMutableArray*							_arrGadgets;
	NSMutableArray*							_arrGateInDbItems;
	Connection*								_connection;
	BOOL									_bGrid;
	BOOL									_bExistGadget;
}

- (UITableView*)getTableViewAppList;
- (void)setDelegate:(id)delegate;
- (void)localize;
- (Connection*)getConnection;
- (void)setSelectedLanguage:(int)languageId;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
- (void)loadGadgets;
- (NSMutableArray*)getItemsInDashboard;
- (NSArray*)listOfGadgetsWithURL:(NSString *)url;
//- (void)onGadgetTableViewCell:(NSURL*)gadgetUrl;
- (void)onGadget:(Gadget*)gadget;
- (NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr;
- (IBAction)onGridBtn:(id)sender;
@end

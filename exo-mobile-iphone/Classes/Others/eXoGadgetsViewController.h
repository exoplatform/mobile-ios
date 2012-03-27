//
//  eXoGadgetsViewController.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/13/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayCell.h"

@class eXoUserClient;

@interface eXoGadgetsViewController : UIViewController {
	IBOutlet UITableView*	_tblView;
	UIButton*				_detailDisclosureButtonType;
	eXoUserClient*			_exoUserClient;
	NSMutableArray*			_listOfGadgets;
}

- (DisplayCell*)obtainTableCellForRow:(UITableView*)myTableView at:(NSInteger)row;
- (NSMutableArray*)getGadgetsList;
- (NSMutableArray*)parseData:(NSString*)dataStr;
- (void)parseXMLData:(NSData *)xmlData;
@end

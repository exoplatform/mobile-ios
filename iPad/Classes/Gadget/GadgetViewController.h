//
//  GadgetViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GadgetButtonView_iPad;
@class GrayPageControl;

@interface GadgetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 
{
	id										_delegate;
	IBOutlet UITableView*					_tblGadgetList;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;

	NSMutableArray*							_arrGadgets;
	NSMutableArray*							_arrGateInDbItems;
	
	IBOutlet UIButton*						_btnGrid;
	BOOL									_bGrid;
	BOOL									_bPageControlUsed;
	int										_intPageNumber;
	//IBOutlet UIPageControl*					_pageController;
	IBOutlet GrayPageControl*					_pageController;
	IBOutlet UIScrollView*					_scrollView;
	IBOutlet UILabel*						_lbTitleItemInDb;
}

@property(nonatomic, retain) UITableView* _tblGadgetList;

- (void)setDelegate:(id)delegate;
- (void)localize;
- (int)getSelectedLanguage;
- (NSDictionary*)getLocalization;
- (void)loadGateInDbItems:(NSMutableArray*)arrGateInDbItems;
//- (IBAction)onGridBtn:(id)sender;
- (void)checkGrid;
- (void)onGridBtn;
- (void)showGrid;
- (void)loadScrollViewWithPage:(int)page;
- (IBAction)onPageViewController:(id)sender;
- (void)onGadgetButton:(GadgetButtonView_iPad*)gadgetBtn;
@end

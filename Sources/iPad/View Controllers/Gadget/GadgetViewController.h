//
//  GadgetViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Gadget_iPadButtonView;
@class GrayPageControl;

//Display gadget list
@interface GadgetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 
{
	id										_delegate;	//The delegate
	IBOutlet UITableView*					_tblGadgetList;	//show gadget in a list
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//language index

	NSMutableArray*							_arrGadgets;	//Gadgets list
	NSMutableArray*							_arrGateInDbItems;		//Dashboard tab list
	
	IBOutlet UIButton*						_btnGrid;	//Show gadget as list or grid
	BOOL									_bGrid;	//Is in grid vie mode
	BOOL									_bPageControlUsed;	//Is page control activing
	int										_intPageNumber;		//Number of gadget page
	IBOutlet GrayPageControl*				_pageController;	//Gadget page controller
	IBOutlet UIScrollView*					_scrollView;	//Scroll view for gadget pages
	IBOutlet UILabel*						_lbTitleItemInDb;	//Dashboard title
}

@property(nonatomic, retain) UITableView* _tblGadgetList;

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Get current language
- (int)getSelectedLanguage;	//Get current language index
- (NSDictionary*)getLocalization;	//Get cuurent language dictionary
- (void)loadGateInDbItems:(NSMutableArray*)arrGateInDbItems;	//Get dashboar tab list
- (void)checkGrid;	//Check gadget tabs view mode
- (void)onGridBtn;	//Change gadget tabs view mode
- (void)showGrid;	//Change gadget tabs view mode
//- (void)loadScrollViewWithPage:(int)page;
- (IBAction)onPageViewController:(id)sender;	//Scroll gadget page
- (void)onGadgetButton:(Gadget_iPadButtonView*)gadgetBtn; //View gadget
@end

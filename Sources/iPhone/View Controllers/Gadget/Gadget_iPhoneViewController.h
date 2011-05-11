//
//  GadgetViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import <UIKit/UIKit.h>

//Gadget list view
@interface Gadget_iPhoneViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 
{
	id										_delegate;	//Main app controller view
	IBOutlet UITableView*					_tblGadgetList; //Gadget list view
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index

	NSMutableArray*							_arrGadgets;	//List of gadgets
	NSMutableArray*							_arrGateInDbItems;	//List of gadget tabs
	
	IBOutlet UIButton*						_btnGrid;		//Change gadget view mode
	BOOL									_bGrid;	//Is in grid view mode
	BOOL									_bPageControlUsed;	//Uesed page controller
	int										_intPageNumber;	//Number of gadget pages
	IBOutlet UIPageControl*					_pageController;	//Gadget page controller
	IBOutlet UIScrollView*					_scrollView;	//Scroll view for gadget page
	IBOutlet UILabel*						_lbTitleItemInDb;	//Gadget tab title
}

@property(nonatomic, retain) NSMutableArray* _arrGadgets;

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Get current language
- (int)getSelectedLanguage;	//Get current language index
- (NSDictionary*)getLocalization;	//Get cuurent language dictionary
- (void)loadGateInDbItems:(NSMutableArray*)arrGateInDbItems;	//Get dashboar tab list
- (void)loadScrollViewWithPage:(int)page;	//
- (IBAction)onPageViewController:(id)sender;	//Scroll gadget page
- (void)onGadgetButton:(NSURL*)url;	//View gadget

@end

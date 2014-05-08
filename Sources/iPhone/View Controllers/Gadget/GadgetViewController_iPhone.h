//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>

//Gadget list view
@interface GadgetViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> 
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

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Get current language
- (int)getSelectedLanguage;	//Get current language index
- (NSDictionary*)getLocalization;	//Get cuurent language dictionary
- (void)loadGateInDbItems:(NSMutableArray*)arrGateInDbItems;	//Get dashboar tab list
- (void)loadScrollViewWithPage:(int)page;	//
- (IBAction)onPageViewController:(id)sender;	//Scroll gadget page
- (void)onGadgetButton:(NSURL*)url;	//View gadget

@end

//
//  GadgetViewControllerController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetViewController.h"
#import "AppContainerViewController.h"
#import "Gadget_iPad.h"
#import "Gadget_iPadButtonView.h"
#import "GrayPageControl.h"

@implementation GadgetViewController

@synthesize _tblGadgetList;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_arrGateInDbItems = [[NSMutableArray alloc] init];
		_bGrid = NO;
		_bPageControlUsed = NO;
		_intPageNumber = 0; 
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	UIView* bg = [[UIView alloc] initWithFrame:[_tblGadgetList frame]];
	[bg setBackgroundColor:[UIColor clearColor]];
	[_tblGadgetList setBackgroundView:bg];
	
	if(!_bGrid)
	{
		[_pageController setHidden:YES];
		[_scrollView setHidden:YES];
		[_lbTitleItemInDb setHidden:YES];
		[_lbTitleItemInDb setFrame:CGRectMake(0, 405, 290, 30)];
	}
	else 
	{
		[_pageController setFrame:CGRectMake(0, 440, 290, 15)];
		[_pageController setHidden:NO];
		[_scrollView setHidden:NO];		
		[_lbTitleItemInDb setHidden:NO];		
	}
	[self localize];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)loadGateInDbItems:(NSMutableArray*)arrGateInDbItems
{
	_arrGateInDbItems = arrGateInDbItems;
	[self checkGrid];
}

- (void)checkGrid
{
	if(!_bGrid)
	{
		[_scrollView setHidden:YES];
		[_pageController setHidden:YES];
		[_lbTitleItemInDb setHidden:YES];
		[_tblGadgetList setHidden:NO];
		[_tblGadgetList reloadData];	
	}
	else
	{
		[_scrollView setHidden:NO];
		[_pageController setHidden:NO];		
		[_lbTitleItemInDb setHidden:NO];		
		[_tblGadgetList setHidden:YES];
		[self showGrid];
	}
}

- (void)showGrid
{
	NSArray* arrViews = [_scrollView subviews];
	for (int i = 0; i < [arrViews count]; i++) 
	{
		UIView* tmpView = [arrViews objectAtIndex:i];
		[tmpView removeFromSuperview];
	}
	
	_intPageNumber = [_arrGateInDbItems count];
	
	if(_intPageNumber <= 1)
	{
		[_pageController setHidden:YES];
	}
	else
	{
		[_pageController setHidden:NO];
	}
	
	_scrollView.pagingEnabled = YES;
	_scrollView.frame = CGRectMake(0, 0, 290, 445);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _intPageNumber, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
	_pageController.numberOfPages = _intPageNumber;
	_pageController.currentPage = 0;
	
	Gadget_iPadButtonView* tmpBtn;
	int row = 0;	
	
	for(int i = 0; i < [_arrGateInDbItems count]; i++)
	{
		for(int j = 0; j < [[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] count]; j++)
		{
			if((j!= 0) && (j%4 == 0))
			{
				row++;
			}
			
			CGRect tmpRect = CGRectMake(i*290 + 72*(j%4) + 1, 102*row + 8, 72, 102);
			tmpBtn = [[Gadget_iPadButtonView alloc] initWithFrame:tmpRect];
			[tmpBtn setDelegate:self];
			[tmpBtn setGadget:[[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] objectAtIndex:j]];
			[tmpBtn setName:[[[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] objectAtIndex:j] _strName]];
			[tmpBtn setIcon:[[[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] objectAtIndex:j] _imgIcon]];
			[tmpBtn setUrl:[[[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] objectAtIndex:j] _urlContent]];
			[_scrollView addSubview:tmpBtn];
		}
		row = 0;
	}
	NSString* tmpStr = [[_arrGateInDbItems objectAtIndex:_pageController.currentPage] _strDbItemName];
	[_lbTitleItemInDb setText:tmpStr];
}

- (void)onGridBtn
{
	_bGrid = !_bGrid;
	[self checkGrid];
}

- (IBAction)onPageViewController:(id)sender
{
	int page = _pageController.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
   // [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _bPageControlUsed = YES;
}

//- (void)loadScrollViewWithPage:(int)page 
//{
//    if (page < 0) 
//	{
//		return;
//	}	
//    if (page >= _intPageNumber) 
//	{
//		return;
//	}	
//}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_bPageControlUsed) 
	{
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageController.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
	
	NSString* tmpStr = [[_arrGateInDbItems objectAtIndex:_pageController.currentPage] _strDbItemName];
	[_lbTitleItemInDb setText:tmpStr];	
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    _bPageControlUsed = NO;
}


- (void)onGadgetButton:(Gadget_iPadButtonView*)gadgetBtn
{
	[_delegate onGadget:[gadgetBtn getGadget]];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = [_arrGateInDbItems count]; 
	return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = [[_arrGateInDbItems objectAtIndex:section] _strDbItemName];
	return tmpStr;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int n = [[[_arrGateInDbItems objectAtIndex:section] _arrGadgetsInItem] count];
	return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString* kCellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	
	cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 5.0, 180.0, 20.0)];
	titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
	titleLabel.text = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] name];
	titleLabel.backgroundColor = [UIColor clearColor];
	[cell addSubview:titleLabel];
	
	UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 180.0, 33.0)];
	descriptionLabel.numberOfLines = 2;
	descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	descriptionLabel.text = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	[cell addSubview:descriptionLabel];
	
	UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
	imgView.image = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] imageIcon];
	[cell addSubview:imgView];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	Gadget_iPad* tmpGadget = [[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row];
	[_delegate onGadget:tmpGadget];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

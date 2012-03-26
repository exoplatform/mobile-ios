//
//  GadgetViewControllerController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetViewController_iPhone.h"
#import "Gadget_iPhone.h"
#import "GadgetButton_iPhone.h"

@implementation GadgetViewController_iPhone

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
	if(!_bGrid)
	{
		[_pageController setHidden:YES];
		[_scrollView setHidden:YES];
		[_lbTitleItemInDb setHidden:YES];
	}
	else 
	{
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

	if(!_bGrid)
	{
		[_btnGrid setTitle:[_dictLocalize objectForKey:@"GridButton"] forState:UIControlStateNormal];
	}
	else 
	{
		[_btnGrid setTitle:[_dictLocalize objectForKey:@"ListButton"]forState:UIControlStateNormal];		
	}
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
}

- (void)checkGrid
{
	if(!_bGrid)
	{
		[_btnGrid setTitle:[_dictLocalize objectForKey:@"GridButton"] forState:UIControlStateNormal];
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
		[_btnGrid setTitle:[_dictLocalize objectForKey:@"ListButton"]forState:UIControlStateNormal];		
		[_tblGadgetList setHidden:YES];
		[self showGrid];
	}
}

- (void)showGrid
{
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
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _intPageNumber, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
	_pageController.numberOfPages = _intPageNumber;
	_pageController.currentPage = 0;
	
	GadgetButton_iPhone* tmpBtn;
	int row = 0;	
	
	for(int i = 0; i < [_arrGateInDbItems count]; i++)
	{
		for(int j = 0; j < [[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] count]; j++)
		{
			if((j!= 0) && (j%3 == 0))
			{
				row++;
			}
			
			CGRect tmpRect = CGRectMake(i*290 + 93*(j%3) + 1, 90*row + 7, 93, 90);
			tmpBtn = [[GadgetButton_iPhone alloc] initWithFrame:tmpRect];
			[tmpBtn setDelegate:self];
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

- (IBAction)onGridBtn:(id)sender
{
	_bGrid = !_bGrid;
	[self checkGrid];
}

- (IBAction)onPageViewController:(id)sender
{
	int page = _pageController.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _bPageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page 
{
    if (page < 0) 
	{
		return;
	}	
    if (page >= _intPageNumber) 
	{
		return;
	}	
}

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
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
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

- (void)onGadgetButton:(NSURL*)gadgetUrl
{
	[_delegate onGadgetTableViewCell:gadgetUrl];
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
	[cell addSubview:titleLabel];
	
	UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 180.0, 33.0)];
	descriptionLabel.numberOfLines = 2;
	descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
	descriptionLabel.text = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description];
	[cell addSubview:descriptionLabel];
	
	UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
	imgView.image = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] imageIcon];
	[cell addSubview:imgView];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSURL* tmpURL = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] urlContent];
	[_delegate onGadgetTableViewCell:tmpURL];
}


@end

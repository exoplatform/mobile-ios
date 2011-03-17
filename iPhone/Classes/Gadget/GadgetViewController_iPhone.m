//
//  GadgetViewControllerController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import "GadgetViewController_iPhone.h"
#import "Gadget_iPhone.h"


//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44


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
	
    //We dequeue a cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell==nil) 
    {
        //Not found, so create a new one
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        //Add subviews only one time, and use the propertie 'Tag' of UIView to retrieve them
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 5.0, 180.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        //define the tag for the titleLabel
        titleLabel.tag = kTagForCellSubviewTitleLabel; 
        [cell addSubview:titleLabel];
        //release the titleLabel because cell retain it now
        [titleLabel release];
        
        //Create the descriptionLabel
        UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 23.0, 180.0, 33.0)];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        descriptionLabel.tag = kTagForCellSubviewDescriptionLabel;
        [cell addSubview:descriptionLabel];
        [descriptionLabel release];
        
        //Create the imageView
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
        imgView.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgView];
        [imgView release];
    }

    //Configurate the cell
    //Configurate the titleLabel and assign good value
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    titleLabel.text = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] name];

	//Configuration the DesriptionLabel
    UILabel *descriptionLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewDescriptionLabel];
	descriptionLabel.text = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description];
	
    //Configuration of the ImageView
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:kTagForCellSubviewImageView];
    imgView.image = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] imageIcon];
	
	return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSURL* tmpURL = [[[[_arrGateInDbItems objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] urlContent];
	[_delegate onGadgetTableViewCell:tmpURL];
}


@end

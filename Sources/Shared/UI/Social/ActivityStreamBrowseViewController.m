//
//  ActivityStreamBrowseViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController.h"
#import "ActivityBasicTableViewCell.h"
#import "NSDate+Formatting.h"
#import "ActivityDetailViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageComposerViewController.h"
#import "ActivityDetailViewController_iPhone.h"
#import "SocialIdentityProxy.h"
#import "SocialActivityStreamProxy.h"
#import "SocialUserProfileProxy.h"
#import "SocialLikeActivityProxy.h"
#import "defines.h"
#import "SocialUserProfileCache.h"


@implementation ActivityStreamBrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //_bbtnPost = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBbtnPost)];
        _bbtnPost = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnPost)];
        self.navigationItem.rightBarButtonItem = _bbtnPost;
                
        _bIsPostClicked = NO;
        _bIsIPad = NO;
        
        _arrActivityStreams = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    
    _tblvActivityStream = nil ;
    
    [_arrayOfSectionsTitle release];
    _arrayOfSectionsTitle = nil;
    
    [_sortedActivities release];
    _sortedActivities=nil;
    
    [_arrActivityStreams release];
    
    [_bbtnPost release];
    
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    
    [_dateOfLastUpdate release];
    _dateOfLastUpdate = nil;
    
    //Release the loader
    [_hudActivityStream release];
    _hudActivityStream = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the loader
    _hudActivityStream = [[ATMHud alloc] initWithDelegate:self];
    [_hudActivityStream setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudActivityStream.view];
    
    
    self.title = @"Activity Stream";
        
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    _tblvActivityStream.backgroundView = backgroundView;

    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityStream.bounds.size.height, self.view.frame.size.width, _tblvActivityStream.bounds.size.height)];
		view.delegate = self;
		[_tblvActivityStream addSubview:view];
		_refreshHeaderView = view;
		[view release];
        _reloading = FALSE;

	}
    
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date]retain];
    
    //Load all activities of the user
    [self startLoadingActivityStream];
    
    

}

- (void)viewDidUnload
{
    [_refreshHeaderView release]; _refreshHeaderView =nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Helpers methods
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    //Default value is 0, to force the developper to implement this method
    return 0.0;
}


- (void)addTimeToActivities:(NSDate*)dateOfLastUpdate 
{
    int intervalBetweenNowAndLastUpdate = [dateOfLastUpdate timeIntervalSinceNow];
    //Browse each activities
    for (SocialActivityStream *a in _arrActivityStreams) {
        a.postedTime += intervalBetweenNowAndLastUpdate;
        
        //Change the value of the label displayed
        [a convertToPostedTimeInWords];
    }
}


- (void)sortActivities 
{
    _arrayOfSectionsTitle = [[NSMutableArray alloc] init];
    
    _sortedActivities =[[NSMutableDictionary alloc] init];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postedTime"
                                                  ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    _arrActivityStreams = [[NSMutableArray alloc] initWithArray:[_arrActivityStreams sortedArrayUsingDescriptors:sortDescriptors]];
    
    //Browse each activities
    for (SocialActivityStream *a in _arrActivityStreams) {
        
        //Check activities of today
        long postedTimeInSecond = round(a.postedTime/1000);
        long timeIntervalNow = [[NSDate date] timeIntervalSince1970];
        
        int time = (timeIntervalNow - postedTimeInSecond);
        
        if (time < 86400) {
            //Search the current array of activities for today
            NSMutableArray *arrayOfToday = [_sortedActivities objectForKey:@"Today"];
            
            // if the array not yet exist, we create it
            if (arrayOfToday == nil) {
                //create the array
                arrayOfToday = [[NSMutableArray alloc] init];
                //set it into the dictonary
                [_sortedActivities setObject:arrayOfToday forKey:@"Today"];
                
                //set the key to the array of sections title
                [_arrayOfSectionsTitle addObject:@"Today"];
            } 
            
            //finally add the object to the array
            [arrayOfToday addObject:a];
        }
        else
        {
            //Search the current array of activities for current key
            NSMutableArray *arrayOfCurrentKeys = [_sortedActivities objectForKey:a.postedTimeInWords];
            
            // if the array not yet exist, we create it
            if (arrayOfCurrentKeys == nil) {
                //create the array
                arrayOfCurrentKeys = [[NSMutableArray alloc] init];
                //set it into the dictonary
                [_sortedActivities setObject:arrayOfCurrentKeys forKey:a.postedTimeInWords];
                
                //set the key to the array of sections title 
                [_arrayOfSectionsTitle addObject:a.postedTimeInWords];
            } 
            
            //finally add the object to the array
            [arrayOfCurrentKeys addObject:a];
        }
    }
}


- (SocialActivityStream *)getSocialActivityStreamForIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrayForSection = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:indexPath.section]];
    return [arrayForSection objectAtIndex:indexPath.row];
}


#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [_arrayOfSectionsTitle count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arrayForSection = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:section]];
    return [arrayForSection count];
}


#define kHeightForSectionHeader 28

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return kHeightForSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _tblvActivityStream.frame.size.width-5, kHeightForSectionHeader)];
	
	// create the label object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor darkGrayColor];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    headerLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    headerLabel.shadowOffset = CGSizeMake(0,1);
    headerLabel.textAlignment = UITextAlignmentRight;
	headerLabel.frame = CGRectMake(0.0, 0.0, _tblvActivityStream.frame.size.width-5, kHeightForSectionHeader);
    headerLabel.text = [_arrayOfSectionsTitle objectAtIndex:section];
    
    CGSize theSize = [headerLabel.text sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(_tblvActivityStream.frame.size.width-5, CGFLOAT_MAX) 
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"SocialActivityBrowseHeaderNormalBg.png"];
    if ([(NSString *) [_arrayOfSectionsTitle objectAtIndex:section] isEqualToString:@"Today"]) {
        imgForSection = [UIImage imageNamed:@"SocialActivityBrowseHeaderHighlightedBg.png"];
    }
    
    UIImageView *imgVBackground = [[UIImageView alloc] initWithImage:[imgForSection stretchableImageWithLeftCapWidth:5 topCapHeight:7]];
    imgVBackground.frame = CGRectMake(_tblvActivityStream.frame.size.width-5 - theSize.width-10, 2, theSize.width+20, kHeightForSectionHeader-4);
    
	[customView addSubview:imgVBackground];
    [imgVBackground release];
    
    [customView addSubview:headerLabel];
    [headerLabel release];

    
	return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SocialActivityStream* socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    NSString* text = socialActivityStream.title;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
        
    return  fHeight;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString* kCellIdentifier = @"ActivityCell";
	
    //We dequeue a cell
	ActivityBasicTableViewCell* cell = (ActivityBasicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityBasicTableViewCell" owner:self options:nil];
        cell = (ActivityBasicTableViewCell *)[nib objectAtIndex:0];
        
        //Create a cell, need to do some configurations
        [cell configureCell];
    }
    
    SocialActivityStream* socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    
    cell.delegate = self;
    cell.socialActivytyStream = socialActivityStream;
    
    NSString* text = socialActivityStream.title;
    
    //Set the size of the cell
    float fWidth = tableView.frame.size.width;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    NSLog(@"fHeight %2f",fHeight);
    [cell setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    
    //Set the cell content
    [cell setSocialActivityStream:socialActivityStream];
    
	return cell;
}



- (void)likeDislikeActivity:(NSString *)activity like:(BOOL)isLike
{
    SocialLikeActivityProxy *likeDislikeActProxy = [[SocialLikeActivityProxy alloc] init];
    
    if(isLike)
        [likeDislikeActProxy likeActivity:activity];
    else
        [likeDislikeActProxy dislikeActivity:activity];
    
    
    [self clearActivityData];
    
    [self startLoadingActivityStream];
}

#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoaderForUpdating {
    [self setHudPosition];
    [_hudActivityStream setCaption:@"Updating Activity stream"];
    [_hudActivityStream setActivity:YES];
    [_hudActivityStream show];
}


- (void)hideLoader {
    //Now update the HUD
    //TODO Localize this string
    [self setHudPosition];
    [_hudActivityStream setCaption:@"Activity Stream updated"];
    [_hudActivityStream setActivity:NO];
    [_hudActivityStream setImage:[UIImage imageNamed:@"19-check"]];
    [_hudActivityStream update];
    [_hudActivityStream hideAfter:0.5];
}

#pragma mark - Social Proxy 
#pragma mark Management

- (void)startLoadingActivityStream {
    
    [self showLoaderForUpdating];
    
    SocialIdentityProxy* identityProxy = [[SocialIdentityProxy alloc] init];
    identityProxy.delegate = self;
    [identityProxy getIdentityFromUser];
}


- (void)updateActivityStream {
    
    [self showLoaderForUpdating];
    
    _reloading = YES;
    SocialActivityStreamProxy* socialActivityStreamProxy = [[SocialActivityStreamProxy alloc] initWithSocialUserProfile:_socialUserProfile];
    socialActivityStreamProxy.delegate = self;
    [socialActivityStreamProxy updateActivityStreamSinceActivity:[_arrActivityStreams objectAtIndex:0]];
}

- (void)finishLoadingAllDataForActivityStream {
    
    //Remove the loader
    [self hideLoader];
    
    //Prevent any reloading status
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityStream];
    
    //Prepare data to be displayed
    for (int i = 0; i < [_arrActivityStreams count]; i++) 
    {
        SocialActivityStream* socialActivityStream = [_arrActivityStreams objectAtIndex:i];
        SocialUserProfile *userProfile = [[SocialUserProfileCache sharedInstance] cachedProfileForIdentity:socialActivityStream.identityId];
        [socialActivityStream setFullName:userProfile.fullName];
        
        NSString *userImageAvatar = [NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN], userProfile.avatarUrl];
        
        [socialActivityStream setUserImageAvatar:userImageAvatar];
    }
    
    //We have retreive new datas from API
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date] retain];
    
    //Ask the controller to sort activities
    [self sortActivities];
    
    [_tblvActivityStream reloadData];
    
    
}



#pragma -
#pragma mark Proxies Delegate Methods

- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    //If proxy is king of class SocialIdentityProxy, then we can start the request for retrieve SocialActivityStream
    if ([proxy isKindOfClass:[SocialIdentityProxy class]]) 
    {
        SocialUserProfileProxy* socialUserProfile = [[SocialUserProfileProxy alloc] init];
        socialUserProfile.delegate = self;
        [socialUserProfile getUserProfileFromIdentity:[(SocialIdentityProxy *)proxy _socialIdentity].identity]; 
    } 
    else if ([proxy isKindOfClass:[SocialUserProfileProxy class]]) 
    {
        //Check if the proxy is loading multiple activites
        if ([(SocialUserProfileProxy *)proxy isLoadingMultipleActivities]) {
            [self finishLoadingAllDataForActivityStream];
        } else {
            _socialUserProfile = [[(SocialUserProfileProxy *)proxy userProfile] retain];
            SocialActivityStreamProxy* socialActivityStreamProxy = [[SocialActivityStreamProxy alloc] initWithSocialUserProfile:_socialUserProfile];
            socialActivityStreamProxy.delegate = self;
            [socialActivityStreamProxy getActivityStreams];
        }
    }
    else if ([proxy isKindOfClass:[SocialActivityStreamProxy class]]) 
    {
        SocialActivityStreamProxy* socialActivityStreamProxy = (SocialActivityStreamProxy *)proxy;
        
        //We have to check if the request for ActivityStream was an update request or not
        if (socialActivityStreamProxy.isUpdateRequest) {                
            //We need to update the postedTime of all previous activities
            [self addTimeToActivities:_dateOfLastUpdate];
        }
        
        
        
        //Retrieve all activities
        //Start preparing data
        //retrieve all distinct identities
        NSMutableSet *setOfIdentities = [[NSMutableSet alloc] init];
        
        for (int i = 0; i < [socialActivityStreamProxy.arrActivityStreams count]; i++) 
        {
            SocialActivityStream* socialActivityStream = [socialActivityStreamProxy.arrActivityStreams objectAtIndex:i];
            [socialActivityStream convertToPostedTimeInWords];
            
            [setOfIdentities addObject:[socialActivityStream.identityId copy]];

            [_arrActivityStreams addObject:socialActivityStream];
            
        }
        
        //Retrieve all identities informations
        SocialUserProfileProxy* socialUserProfile = [[SocialUserProfileProxy alloc] init];
        socialUserProfile.delegate = self;
        [socialUserProfile retrieveIdentitiesSet:setOfIdentities];
    } 
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    
}

#pragma mark -
#pragma mark MessageComposer Methods
- (void)messageComposerDidSendData {
    [self updateActivityStream];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    [self updateActivityStream];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _dateOfLastUpdate; // should return date data source was last changed
	
}



@end

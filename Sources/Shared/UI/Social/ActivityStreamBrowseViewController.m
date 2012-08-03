//
//  ActivityStreamBrowseViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController.h"
#import "ActivityBasicTableViewCell.h"
#import "ActivityPictureTableViewCell.h"
#import "ActivityForumTableViewCell.h"
#import "ActivityWikiTableViewCell.h"
#import "ActivityLinkTableViewCell.h"
#import "ActivityAnswerTableViewCell.h"
#import "ActivityCalendarTableViewCell.h"
#import "NSDate+Formatting.h"
#import "ActivityDetailViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageComposerViewController.h"
#import "ActivityDetailViewController_iPhone.h"
#import "SocialActivityStreamProxy.h"
#import "SocialUserProfileProxy.h"
#import "SocialLikeActivityProxy.h"
#import "defines.h"
#import "SocialUserProfileCache.h"
#import "EmptyView.h"
#import "EGOImageView.h"
#import "SocialPictureAttach.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "SocialRestProxy.h"

#define kStreamTabbarHeight 40.0

static NSString* kCellIdentifier = @"ActivityCell";
static NSString* kCellIdentifierPicture = @"ActivityPictureCell";
static NSString* kCellIdentifierForum = @"ActivityForumCell";
static NSString* kCellIdentifierWiki = @"ActivityWikiCell";
static NSString* kCellIdentifierLink = @"ActivityLinkCell";
static NSString* kCellIdentifierAnswer = @"ActivityAnswerCell";
static NSString* kCellIdentifierCalendar = @"ActivityCalendarCell";

@interface ActivityStreamBrowseViewController ()

@property (nonatomic, retain) SocialActivityStreamProxy *socialActivityStreamProxy;
@property (nonatomic, retain) SocialRestProxy *socialRestProxy;
@property (nonatomic, retain) SocialLikeActivityProxy *likeActivityProxy;
@property (nonatomic, retain) SocialUserProfileProxy *userProfileProxy;
@property (nonatomic, retain) NSMutableArray *arrayOfSectionsTitle;
@property (nonatomic, retain) NSMutableDictionary *sortedActivities;
@property (nonatomic, retain) NSDate *dateOfLastUpdate;
@property (nonatomic, retain) NSMutableArray *arrActivityStreams;

- (void)loadImagesForOnscreenRows;
- (void)callProxiesToReloadActivityStream;

@end


@implementation ActivityStreamBrowseViewController

//@synthesize socialUserProfile = _socialUserProfile;
@synthesize socialActivityStreamProxy = _socialActivityStreamProxy;
@synthesize socialRestProxy = _socialRestProxy;
@synthesize likeActivityProxy = _likeActivityProxy;
@synthesize userProfileProxy = _userProfileProxy;
@synthesize arrayOfSectionsTitle = _arrayOfSectionsTitle;
@synthesize sortedActivities = _sortedActivities;
@synthesize dateOfLastUpdate = _dateOfLastUpdate;
@synthesize arrActivityStreams = _arrActivityStreams;
@synthesize filterTabbar = _filterTabbar;
@synthesize userProfile = _userProfile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Create a custom logout button    
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *barButtonImage = [UIImage imageNamed:@"NavbarComposeButton.png"];
        tmpButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
        [tmpButton setImage:barButtonImage forState:UIControlStateNormal];
        [tmpButton addTarget:self action:@selector(onBbtnPost) forControlEvents: UIControlEventTouchUpInside];
        _bbtnPost = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
        [self.navigationItem setRightBarButtonItem:_bbtnPost];
        
        
        _bIsPostClicked = NO;
        _activityAction = 0;
        _selectedTabItem = -1;
        self.arrActivityStreams = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    _tblvActivityStream = nil;
    [_filterTabbar release];
    [_userProfile release];
    
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
    
    
    if (_activityDetailViewController != nil) 
    {
        [_activityDetailViewController release];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_indexpathSelectedActivity release];

    // release proxies
    [_socialActivityStreamProxy release];
    [_socialRestProxy release];
    [_likeActivityProxy release];
    [_userProfileProxy release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)showHudForUpload{
    
}

#pragma mark - Proxy management
- (SocialActivityStreamProxy *)socialActivityStreamProxy {
    if (!_socialActivityStreamProxy) {
        _socialActivityStreamProxy = [[SocialActivityStreamProxy alloc] init];
        _socialActivityStreamProxy.delegate = self;
    }
    return _socialActivityStreamProxy;
}

- (SocialUserProfileProxy *)userProfileProxy {
    if (!_userProfileProxy) {
        _userProfileProxy = [[SocialUserProfileProxy alloc] init];
        _userProfileProxy.delegate = self;
    }
    return _userProfileProxy;
}

- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    if(proxy == self.socialRestProxy){
        [self.socialActivityStreamProxy getActivityStreams:_selectedTabItem];
    } else if (proxy == self.userProfileProxy) { 
        self.userProfile = self.userProfileProxy.userProfile;
        self.userProfileProxy = nil;
        if (self.filterTabbar.tabView.selectedIndex == ActivityStreamTabItemMyStatus) {
            self.socialActivityStreamProxy.userProfile = self.userProfile;
            // reload my status after getting user profile
            [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeMyStatus];
        }
    } else if (proxy == self.socialActivityStreamProxy) {
        //We have to check if the request for ActivityStream was an update request or not
        if (self.socialActivityStreamProxy.isUpdateRequest) {                
            //We need to update the postedTime of all previous activities
            [self addTimeToActivities:_dateOfLastUpdate];
        }
        
        //Retrieve all activities
        //Start preparing data
        [_arrActivityStreams removeAllObjects];
        for (int i = 0; i < [self.socialActivityStreamProxy.arrActivityStreams count]; i++) 
        {
            SocialActivity *socialActivityStream = [self.socialActivityStreamProxy.arrActivityStreams objectAtIndex:i];
            [socialActivityStream convertToPostedTimeInWords];
            [socialActivityStream convertHTMLEncoding];
            [socialActivityStream getActivityType];
            [socialActivityStream cellHeightCalculationForWidth:_tblvActivityStream.frame.size.width];
            [_arrActivityStreams addObject:socialActivityStream];
        }
        
        //All informations has been retrieved we can now display them
        [self finishLoadingAllDataForActivityStream];
    } 
    else if (proxy == self.likeActivityProxy) 
    {
        self.likeActivityProxy = nil;
        [self updateActivityStream];
    }
    
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    NSString *alertMessages = nil;
    
    if(_activityAction == 0)
        alertMessages = Localize(@"GettingActionCannotBeCompleted");
    else if(_activityAction == 1)
        alertMessages = Localize(@"UpdatingActionCannotBeCompleted");
    else if (_activityAction == 2)
        alertMessages = Localize(@"LikingActionCannotBeCompleted");
    else 
        alertMessages = Localize(@"UnLikeActionCannotBeCompleted");
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessages delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    
    [alertView show];
}

- (void)callProxiesToReloadActivityStream {
    // reset activity stream proxy
    self.socialActivityStreamProxy = nil;
    if (_selectedTabItem == ActivityStreamTabItemAllUpdate) {
        [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeAllUpdates];
    } else if (_selectedTabItem == ActivityStreamTabItemMyConnections) {
        [self.socialActivityStreamProxy getActivityStreams:ActivityStreamTabItemMyConnections];
    } else if (_selectedTabItem == ActivityStreamTabItemMySpaces) {
        [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeMySpaces];
    } else if (_selectedTabItem == ActivityStreamTabItemMyStatus) {
        if (self.userProfile == nil)
            // To get my status activities, get user profile first
            [self.userProfileProxy getUserProfileFromUsername:[ServerPreferencesManager sharedInstance].username];
        else {
            self.socialActivityStreamProxy.userProfile = self.userProfile;
            [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeMyStatus];
        }
        
    }
}

#pragma mark - Update Acitivity From ActivityDetail
-(void)updateActivity{
    //ActivityBasicTableViewCell *cell;
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:_indexpathSelectedActivity];
    /*switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:
        {
            cell = (ActivityWikiTableViewCell *)[_tblvActivityStream cellForRowAtIndexPath:_indexpathSelectedActivity];
        }
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:{
            cell = (ActivityForumTableViewCell *)[_tblvActivityStream cellForRowAtIndexPath:_indexpathSelectedActivity];
        }
            break;
        default:{
            cell = (ActivityBasicTableViewCell *)[_tblvActivityStream cellForRowAtIndexPath:_indexpathSelectedActivity];
            
        }
            break;
    }*/
    
    ActivityBasicTableViewCell *cell = (ActivityBasicTableViewCell *)[_tblvActivityStream cellForRowAtIndexPath:_indexpathSelectedActivity];
    [cell setSocialActivityStream:socialActivityStream];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActivity) name:EXO_NOTIFICATION_ACTIVITY_UPDATED object:nil];    
	[self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    
    
    self.title = Localize(@"News");
    
    _tblvActivityStream.backgroundColor = [UIColor clearColor];
    _tblvActivityStream.scrollsToTop = YES;
    _tblvActivityStream.contentInset = UIEdgeInsetsMake(kStreamTabbarHeight, 0, 0, 0);
    _tblvActivityStream.scrollIndicatorInsets = UIEdgeInsetsMake(kStreamTabbarHeight, 0, 0, 0);
    // filter tab bar
    CGRect activityStreamFrame = _tblvActivityStream.frame;
    self.filterTabbar = [[[ActivityStreamTabbar alloc] initWithFrame:CGRectMake(activityStreamFrame.origin.x, activityStreamFrame.origin.y, activityStreamFrame.size.width, kStreamTabbarHeight)] autorelease];
    self.filterTabbar.tabView.delegate = self;
    [self.filterTabbar selectTabItem:[ServerPreferencesManager sharedInstance].selectedSocialStream];
    [self.view insertSubview:self.filterTabbar aboveSubview:_tblvActivityStream];
    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityStream.bounds.size.height, self.view.frame.size.width, _tblvActivityStream.bounds.size.height)];
		view.delegate = self;
        view.originalContentInset = _tblvActivityStream.contentInset;
		[_tblvActivityStream addSubview:view];
		_refreshHeaderView = view;
		[view release];
        _reloading = FALSE;
        
	}
    
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
        
}

- (void)viewDidUnload
{
    [_refreshHeaderView release]; _refreshHeaderView =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text picture:(BOOL)isPicture;
{
    //Default value is 0, to force the developper to implement this method
    return 0.0;
}


- (void)addTimeToActivities:(NSDate*)dateOfLastUpdate 
{
    int intervalBetweenNowAndLastUpdate = [dateOfLastUpdate timeIntervalSinceNow];
    //Browse each activities
    for (SocialActivity *a in _arrActivityStreams) {
        a.postedTime += intervalBetweenNowAndLastUpdate;
        
        //Change the value of the label displayed
        [a convertToPostedTimeInWords];
    }
}


- (void)sortActivities 
{
    self.arrayOfSectionsTitle = [[[NSMutableArray alloc] init] autorelease];
    
    self.sortedActivities = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"postedTime"
                                                                    ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.arrActivityStreams = [[[NSMutableArray alloc] initWithArray:[self.arrActivityStreams sortedArrayUsingDescriptors:sortDescriptors]] autorelease];
    
    //Browse each activities
    for (SocialActivity *a in _arrActivityStreams) {
        
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
                arrayOfToday = [[[NSMutableArray alloc] init] autorelease];
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
                arrayOfCurrentKeys = [[[NSMutableArray alloc] init] autorelease];
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


- (SocialActivity *)getSocialActivityStreamForIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrayForSection = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:indexPath.section]];
    return [arrayForSection objectAtIndex:indexPath.row];
}

- (void)clearActivityData
{
    [_arrActivityStreams removeAllObjects];
    [_arrayOfSectionsTitle removeAllObjects];
}

#pragma mark - JMTabviewDelegate 

- (void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    if (!_reloading && _selectedTabItem == itemIndex) {
        return;
    } else {
        _selectedTabItem = itemIndex;
    }
    [ServerPreferencesManager sharedInstance].selectedSocialStream = itemIndex;
    [self clearActivityData];
    [_tblvActivityStream reloadData];
    [self displayHudLoader];
    [self callProxiesToReloadActivityStream];
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
    headerLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    headerLabel.shadowOffset = CGSizeMake(0,1);
    headerLabel.textAlignment = UITextAlignmentRight;
	headerLabel.frame = CGRectMake(0.0, 0.0, _tblvActivityStream.frame.size.width-5, kHeightForSectionHeader);
    NSString *headerTitle = [_arrayOfSectionsTitle objectAtIndex:section];
    if ([headerTitle isEqualToString:@"Today"]) {
        headerLabel.text = Localize([_arrayOfSectionsTitle objectAtIndex:section]);
    } else {
        SocialActivity *firstAct = [[_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:section]] objectAtIndex:0];
        headerLabel.text = [[NSDate dateWithTimeIntervalSince1970:firstAct.postedTime/1000] distanceOfTimeInWords:[NSDate date]];
    }
    
    CGSize theSize = [headerLabel.text sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(_tblvActivityStream.frame.size.width-5, CGFLOAT_MAX) 
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"SocialActivityBrowseHeaderNormalBg.png"];
    if ([(NSString *) [_arrayOfSectionsTitle objectAtIndex:section] isEqualToString:@"Today"]) {
        imgForSection = [UIImage imageNamed:@"SocialActivityBrowseHeaderHighlightedBg.png"];
        headerLabel.textColor = [UIColor colorWithRed:21./255 green:94./255 blue:173./255 alpha:1.];
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
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    return  socialActivityStream.cellHeight;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    ActivityBasicTableViewCell *cell;
    
    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:
        case ACTIVITY_CONTENTS_SPACE:{
            cell  = (ActivityPictureTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierPicture];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityPictureTableViewCell" owner:self options:nil];
                cell = (ActivityPictureTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
                
            }
        }
            break;
            
        case ACTIVITY_LINK:{
            cell  = (ActivityLinkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierLink];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityLinkTableViewCell" owner:self options:nil];
                cell = (ActivityLinkTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            cell  = (ActivityWikiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierWiki];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityWikiTableViewCell" owner:self options:nil];
                cell = (ActivityWikiTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
            
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:{
            cell  = (ActivityForumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierForum];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityForumTableViewCell" owner:self options:nil];
                cell = (ActivityForumTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        {
            //We dequeue a cell
            cell  = (ActivityAnswerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierAnswer];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityAnswerTableViewCell" owner:self options:nil];
                cell = (ActivityAnswerTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_ADD_TASK:
        {
            //We dequeue a cell
            cell  = (ActivityCalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifierCalendar];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityCalendarTableViewCell" owner:self options:nil];
                cell = (ActivityCalendarTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
        }
            break;
        
        default:{
            //We dequeue a cell
            cell  = (ActivityBasicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityBasicTableViewCell" owner:self options:nil];
                cell = (ActivityBasicTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some Configurations
                [cell configureCellForWidth:tableView.frame.size.width];
            }
        }
            break;
    }
    
    cell.delegate = self;
    cell.imgType.image = [UIImage imageNamed:[self getIconForType:socialActivityStream.type]];
    [cell setSocialActivityStream:socialActivityStream];
    
    //Load images
    if ((_tblvActivityStream.dragging == NO) && (_tblvActivityStream.decelerating == NO)) {        
        // Display the newly loaded image
        cell.imgvAvatar.imageURL = [NSURL URLWithString:socialActivityStream.posterIdentity.avatarUrl];
        
        if ([cell respondsToSelector:@selector(startLoadingImageAttached)]) {
            [(ActivityPictureTableViewCell *)cell startLoadingImageAttached];
        }
    } else {
        //reset the imgAttached
        if ([cell respondsToSelector:@selector(startLoadingImageAttached)]) {
            [(ActivityPictureTableViewCell *)cell resetImageAttached];
        }
    }

    return cell;
}




-(NSString *)getIconForType:(NSString *)type {
    NSString *nameIcon = @"";
    if([type rangeOfString:@"forum"].length > 0){
        nameIcon = @"ActivityTypeForum.png";
    }else if([type rangeOfString:@"answer"].length > 0){
        nameIcon = @"ActivityTypeAnswer.png";
    }else if([type rangeOfString:@"DOC_ACTIVITY"].length > 0 || [type rangeOfString:@"contents:spaces"].length > 0){
        nameIcon = @"ActivityTypeDocument.png";
    }else if([type rangeOfString:@"wiki"].length > 0){
        nameIcon = @"ActivityTypeWiki.png";
    }else if([type rangeOfString:@"exosocial:relationship"].length > 0){
        nameIcon = @"ActivityTypeConnection.png";
    }else if([type rangeOfString:@"calendar"].length > 0){
        nameIcon = @"ActivityTypeCalendar.png";
    }else if([type rangeOfString:@"DEFAULT_ACTIVITY"].length > 0){
        nameIcon = @"ActivityTypeNormal.png";
    }else if([type rangeOfString:@"LINK_ACTIVITY"].length > 0){
        nameIcon = @"ActivityTypeLink.png";
    }else {
        nameIcon = @"ActivityTypeNormal.png";
    }
    
    return nameIcon;
}

- (void)likeDislikeActivity:(NSString *)activity like:(BOOL)isLike
{
    //NSLog(@"%@")//SocialLikeActivityProxy
    self.likeActivityProxy = [[[SocialLikeActivityProxy alloc] init] autorelease];
    self.likeActivityProxy.delegate = self;
    
    if(!isLike)
    {
        _activityAction = 2;
        [self.likeActivityProxy likeActivity:activity];
    }
    else
    {
        _activityAction = 3;
        [self.likeActivityProxy dislikeActivity:activity];
    }
}



- (void)postACommentOnActivity:(NSString *)activity {
    //Default Implementation
}



#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

#pragma mark - activity stream management

- (void)startLoadingActivityStream {
    
    [self clearActivityData];
    
    [self displayHudLoader];
    
    self.socialRestProxy = [[[SocialRestProxy alloc] init] autorelease];
    self.socialRestProxy.delegate = self;
    [self.socialRestProxy getVersion];    
}


- (void)updateActivityStream {
    _reloading = YES;
    [self callProxiesToReloadActivityStream];
}

- (void)finishLoadingAllDataForActivityStream {
    
    _tblvActivityStream.scrollEnabled = YES;
    
    //if the empty is, remove it
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
    
    //Remove the loader
    [self hideLoader:YES];
    
    //Prevent any reloading status
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityStream];
    
    if ([_arrActivityStreams count] == 0) {
        [self performSelector:@selector(emptyState) withObject:nil afterDelay:.1];
    }
    
    //We have retreive new datas from API
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
    
    //Ask the controller to sort activities
    [self sortActivities];
    [_tblvActivityStream reloadData];
//    [_tblvActivityStream scrollRectToVisible:CGRectMake(0, 0, 1., 1.) animated:YES];
    
}

// Empty State
-(void)emptyState {
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:_tblvActivityStream.frame withImageName:@"IconForNoActivities.png" andContent:Localize(@"NoActivities")];
    emptyView.tag = TAG_EMPTY;
    [self.view insertSubview:emptyView belowSubview:_tblvActivityStream];
    [emptyView release];
}

#pragma mark - MessageComposer Methods
- (void)messageComposerDidSendData {
    [self updateActivityStream];
}


// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([_arrActivityStreams count] > 0)
    {
        NSArray *visiblePaths = [_tblvActivityStream indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
            
            ActivityBasicTableViewCell *cell = (ActivityBasicTableViewCell*)[_tblvActivityStream cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imgvAvatar.imageURL = [NSURL URLWithString:socialActivityStream.posterIdentity.avatarUrl];
            
            if ([cell respondsToSelector:@selector(startLoadingImageAttached)]) {
                [(ActivityPictureTableViewCell *)cell startLoadingImageAttached];
            }
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        [self.filterTabbar translucentView:YES];
    } else {
        [self.filterTabbar translucentView:NO];
    }
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    //[self loadImagesForOnscreenRows];
}
         
#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    _activityAction = 1;
    [self updateActivityStream];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _dateOfLastUpdate; // should return date data source was last changed
	
}

#pragma mark - 
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Remove the loader
    
    [self hideLoader:NO];
    
    if(_activityAction == 1)
    {
        //Prevent any reloading status
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityStream];
    }
    else if(_activityAction == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end

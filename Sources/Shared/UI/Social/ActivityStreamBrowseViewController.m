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
#import "UserPreferencesManager.h"

#define kStreamTabbarHeight 35.

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
- (BOOL)shoudAutoLoadMore;


@end


@implementation ActivityStreamBrowseViewController {
    float plfVersion;
}

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
        _activityAction = ActivityActionLoad;
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
            if (_activityAction == ActivityActionLoadMore)
                [self.socialActivityStreamProxy getActivitiesOfType:ActivityStreamProxyActivityTypeMyStatus BeforeActivity:_lastActivity];
            else
                [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeMyStatus];
        }
    } else if (proxy == self.socialActivityStreamProxy) {
        //We have to check if the request for ActivityStream was an update request or not
        if (self.socialActivityStreamProxy.isUpdateRequest) {                
            //We need to update the postedTime of all previous activities
            [self addTimeToActivities:_dateOfLastUpdate];
        }
        
        // Retrieve activities and start preparing data
        // If the user is loading more activities (when he reaches the bottom of the list)
        // we DO NOT empty the current list of activities.
        // For any other action (cf enum ActivityAction) we reload the stream entirely
        if (_activityAction!=ActivityActionLoadMore)
        {
            [_arrActivityStreams removeAllObjects];
        } 
        for (int i = 0; i < [self.socialActivityStreamProxy.arrActivityStreams count]; i++) 
        {
            SocialActivity *socialActivityStream = [self.socialActivityStreamProxy.arrActivityStreams objectAtIndex:i];
            
            [socialActivityStream convertToPostedTimeInWords];
            [socialActivityStream convertToUpdatedTimeInWords];
            [socialActivityStream convertHTMLEncoding];
            [socialActivityStream getActivityType];
            [socialActivityStream convertToAttributedMessage];
            [_arrActivityStreams addObject:socialActivityStream];
        }

        // All information have been retrieved, we can now display them
        [self finishLoadingAllDataForActivityStream];
        
        // Release the RKObjectLoader because we don't need RK anymore
        if (_activityAction==ActivityActionLoadMore || _activityAction==ActivityActionUpdateAfterError)
            [[proxy RKObjectLoader] release];
        _lastActivity = nil;
    } 
    else if (proxy == self.likeActivityProxy) 
    {
        self.likeActivityProxy = nil;
        [self updateActivityStream];
    }
    
    if (self.hudLoadWaiting.view.superview){
        [self.hudLoadWaiting.view removeFromSuperview];
    }
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    NSMutableString *alertMessages = nil;
    _lastActivity = nil;
    
    if(_activityAction == ActivityActionLoad)
        alertMessages = [NSMutableString stringWithString:Localize(@"GettingActionCannotBeCompleted")];
    else if(_activityAction == ActivityActionUpdate)
        alertMessages = [NSMutableString stringWithString:Localize(@"UpdatingActionCannotBeCompleted")];
    else if (_activityAction == ActivityActionLike)
        alertMessages = [NSMutableString stringWithString:Localize(@"LikingActionCannotBeCompleted")];
    else if (_activityAction == ActivityActionUnlike)
        alertMessages = [NSMutableString stringWithString:Localize(@"UnLikeActionCannotBeCompleted")];
    else if (_activityAction == ActivityActionLoadMore) {
        // Stop the activity indicator after the loading failed
        if (_loadingMoreActivitiesIndicator!=nil)
            [_loadingMoreActivitiesIndicator stopAnimating];
        // Reload all activities
        [self reloadActivitiesAfterError];
        // We don't release RKObjectLoader here because we need it for the new RK request
    } else if (_activityAction == ActivityActionUpdateAfterError) {
        // Release the RKObjectLoader because we don't need RK anymore
        [[proxy RKObjectLoader] release];
        alertMessages = [NSMutableString stringWithString:Localize(@"UpdatingActionCannotBeCompleted")];
    }

// Error codes:    
//    RKObjectLoaderRemoteSystemError             =   1
//	  RKRequestBaseURLOfflineError                =   2
//    RKRequestUnexpectedResponseError            =   3
//    RKObjectLoaderUnexpectedResponseError       =   4

    if (alertMessages!=nil) {

        if (error.code == RKObjectLoaderUnexpectedResponseError) {
            [alertMessages appendString:@"\n"];
            [alertMessages appendString:Localize(@"BadResponse")];
        } else if(error.code == RKRequestBaseURLOfflineError) {
            [alertMessages appendString:@"\n"];
            [alertMessages appendString:Localize(@"NetworkConnection")];
        }

        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessages delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

// Called when the user scrolls down the activity stream. It loads more activities.
- (void)callProxiesToLoadActivitiesBefore:(SocialActivity*)activity {    
    // reset activity stream proxy
    self.socialActivityStreamProxy = nil;
    if (_selectedTabItem == ActivityStreamTabItemAllUpdate) {
        [self.socialActivityStreamProxy getActivitiesOfType:ActivityStreamProxyActivityTypeAllUpdates BeforeActivity:activity];
        
    } else if (_selectedTabItem == ActivityStreamTabItemMyConnections) {
        [self.socialActivityStreamProxy getActivitiesOfType:ActivityStreamTabItemMyConnections BeforeActivity:activity];
        
    } else if (_selectedTabItem == ActivityStreamTabItemMySpaces) {
        [self.socialActivityStreamProxy getActivitiesOfType:ActivityStreamProxyActivityTypeMySpaces BeforeActivity:activity];
        
    } else if (_selectedTabItem == ActivityStreamTabItemMyStatus) {
        if (self.userProfile == nil) {
            // To get my status activities, get user profile first
            _lastActivity = activity;
            [self.userProfileProxy getUserProfileFromUsername:[UserPreferencesManager sharedInstance].username];
        } else {
            self.socialActivityStreamProxy.userProfile = self.userProfile;
            [self.socialActivityStreamProxy getActivitiesOfType:ActivityStreamProxyActivityTypeMyStatus BeforeActivity:activity];
        }
    }
}

// Called when the user "pulls to refresh". It loads the 100 newest activities.
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
            [self.userProfileProxy getUserProfileFromUsername:[UserPreferencesManager sharedInstance].username];
        else {
            self.socialActivityStreamProxy.userProfile = self.userProfile;
            [self.socialActivityStreamProxy getActivityStreams:ActivityStreamProxyActivityTypeMyStatus];
        }   
    }
}

#pragma mark - Update Activity From ActivityDetail
-(void)updateActivity{

    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:_indexpathSelectedActivity];
    
    ActivityBasicTableViewCell *cell = (ActivityBasicTableViewCell *)[_tblvActivityStream cellForRowAtIndexPath:_indexpathSelectedActivity];
    [cell setSocialActivityStream:socialActivityStream];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityWikiTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierWiki];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityPictureTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierPicture];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityLinkTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierLink];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityForumTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierForum];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierAnswer];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityCalendarTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierCalendar];
    [self.tblvActivityStream registerNib: [UINib nibWithNibName:@"ActivityBasicTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];

    
    plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActivity) name:EXO_NOTIFICATION_ACTIVITY_UPDATED object:nil];    
	[self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
    
    self.title = Localize(@"News");
    _navigation.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    _tblvActivityStream.backgroundColor = [UIColor clearColor];
    _tblvActivityStream.scrollsToTop = YES;
    _tblvActivityStream.contentInset = UIEdgeInsetsMake(kStreamTabbarHeight, 0, 0, 0);
    _tblvActivityStream.scrollIndicatorInsets = UIEdgeInsetsMake(kStreamTabbarHeight, 0, 0, 0);
    
    
    // filter tab bar
    CGRect activityStreamFrame = _tblvActivityStream.frame;
    self.filterTabbar = [[[ActivityStreamTabbar alloc] initWithFrame:CGRectMake(activityStreamFrame.origin.x, activityStreamFrame.origin.y, activityStreamFrame.size.width, kStreamTabbarHeight)] autorelease];
    self.filterTabbar.tabView.delegate = self;    
    [self.view insertSubview:self.filterTabbar aboveSubview:_tblvActivityStream];
    [self.filterTabbar selectTabItem:[UserPreferencesManager sharedInstance].selectedSocialStream];

    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityStream.bounds.size.height, self.view.frame.size.width, _tblvActivityStream.bounds.size.height)];
		view.delegate = self;
        view.originalContentInset = _tblvActivityStream.contentInset;
		[_tblvActivityStream addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
        _reloading = FALSE;
        
	}
    
    //Set the last update date at now 
    self.dateOfLastUpdate = [NSDate date];
        
    // Observe the change language notif to update the labels
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelsWithNewLanguage) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    
    // The footer view that contains the activity indicator
    [self setupActivityIndicator];
    

}
- (void)viewDidUnload
{
    [_refreshHeaderView release];
    _refreshHeaderView =nil;
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
        if(plfVersion < 4) {
            a.postedTime += intervalBetweenNowAndLastUpdate;
            //Change the value of the label displayed
            [a convertToPostedTimeInWords];
        } else {
            a.lastUpdated += intervalBetweenNowAndLastUpdate;
            //Change the value of the label displayed
            [a convertToUpdatedTimeInWords];
        }
    }
}


- (void)sortActivities 
{
    self.arrayOfSectionsTitle = [[[NSMutableArray alloc] init] autorelease];
    
    self.sortedActivities = [[[NSMutableDictionary alloc] init] autorelease];
    
    //from Plf 4, the activities are sorted by last updated time
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:(plfVersion < 4) ? @"postedTime" : @"lastUpdated"
                                                                    ascending:NO] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.arrActivityStreams = [[[NSMutableArray alloc] initWithArray:[self.arrActivityStreams sortedArrayUsingDescriptors:sortDescriptors]] autorelease];
    
    //Browse each activities
    for (SocialActivity *a in _arrActivityStreams) {
        
        //Check activities of today
        long timeInSecond = plfVersion < 4 ? round(a.postedTime/1000) : round(a.lastUpdated/1000);
        long timeIntervalNow = [[NSDate date] timeIntervalSince1970];
        
        int time = (timeIntervalNow - timeInSecond);
        
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
            NSMutableArray *arrayOfCurrentKeys = [_sortedActivities objectForKey:(plfVersion < 4) ? a.postedTimeInWords : a.updatedTimeInWords];
            
            // if the array not yet exist, we create it
            if (arrayOfCurrentKeys == nil) {
                //create the array
                arrayOfCurrentKeys = [[[NSMutableArray alloc] init] autorelease];
                //set it into the dictonary
                [_sortedActivities setObject:arrayOfCurrentKeys forKey:(plfVersion < 4) ? a.postedTimeInWords : a.updatedTimeInWords];
                
                //set the key to the array of sections title 
                [_arrayOfSectionsTitle addObject:(plfVersion < 4) ? a.postedTimeInWords : a.updatedTimeInWords];
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
    [UserPreferencesManager sharedInstance].selectedSocialStream = itemIndex;
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
    if (socialActivityStream.cellHeight >0) {
        return socialActivityStream.cellHeight;
    }
    return [self heightForRowAtIndexPath:indexPath];

}

-(CGFloat) heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];

    NSString * identCell;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:
        case ACTIVITY_CONTENTS_SPACE:{
            identCell = kCellIdentifierPicture;
        }
            break;
        case ACTIVITY_LINK:{
            identCell = kCellIdentifierLink;
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            identCell = kCellIdentifierWiki;
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST:
        case ACTIVITY_FORUM_CREATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:{
            identCell = kCellIdentifierForum;
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        {
            identCell = kCellIdentifierAnswer;
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_ADD_TASK:
        {
            identCell = kCellIdentifierCalendar;
        }
            break;
        default:{
            identCell = kCellIdentifier;
        }
            break;
    }
    
    static ActivityBasicTableViewCell *sizingCell = nil;

    sizingCell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
    
    [sizingCell setSocialActivityStreamForSpecificContent:socialActivityStream];
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    socialActivityStream.cellHeight = size.height +1.0f;
    
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    ActivityBasicTableViewCell *cell;
    
    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:
        case ACTIVITY_CONTENTS_SPACE:{
            NSString * identCell = kCellIdentifierPicture;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
            
        case ACTIVITY_LINK:{
            NSString * identCell = kCellIdentifierLink;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];

        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            NSString * identCell = kCellIdentifierWiki;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
        case ACTIVITY_FORUM_CREATE_POST: 
        case ACTIVITY_FORUM_CREATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_TOPIC:
        case ACTIVITY_FORUM_UPDATE_POST:{
            NSString * identCell = kCellIdentifierForum;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:
        case ACTIVITY_ANSWER_ADD_QUESTION:
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
        {
            //We dequeue a cell
            NSString * identCell = kCellIdentifierAnswer;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
        case ACTIVITY_CALENDAR_UPDATE_TASK:
        case ACTIVITY_CALENDAR_UPDATE_EVENT:
        case ACTIVITY_CALENDAR_ADD_EVENT:
        case ACTIVITY_CALENDAR_ADD_TASK:
        {
            NSString * identCell = kCellIdentifierCalendar;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
        
        default:{
            NSString * identCell = kCellIdentifier;
            cell = [self.tblvActivityStream dequeueReusableCellWithIdentifier:identCell];
            [cell setSocialActivityStreamForSpecificContent:socialActivityStream];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
            break;
    }
    
    [cell setPlatformVersion:plfVersion];
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
    cell.backgroundColor = [UIColor clearColor];
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
        _activityAction = ActivityActionLike;
        [self.likeActivityProxy likeActivity:activity];
    }
    else
    {
        _activityAction = ActivityActionUnlike;
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

- (void)setupActivityIndicator {
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tblvActivityStream.frame.size.width, 44)]autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    _loadingMoreActivitiesIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
    [footerView addSubview:_loadingMoreActivitiesIndicator];
    _loadingMoreActivitiesIndicator.center = CGPointMake(footerView.center.x, footerView.center.y);
    _tblvActivityStream.tableFooterView = footerView;
}

#pragma mark - activity stream management

- (void)startLoadingActivityStream {
    
    [self clearActivityData];
    
    [self displayHudLoader];
    
    self.socialRestProxy = [[[SocialRestProxy alloc] init] autorelease];
    self.socialRestProxy.delegate = self;
    [self.socialRestProxy getVersion];    
}

/*
 * Informs the user that an error occurred and reload the activity stream.
 */
- (void)reloadActivitiesAfterError {
    _activityAction = ActivityActionUpdateAfterError;
    [self displayHUDLoaderWithMessage:Localize(@"LoadMoreActionCannotBeCompleted")];
    [self updateActivityStream];
}

/*
 * Loads the 100 activities that were published before 'activity'
 */
- (void)loadActivitiesBeforeActivity:(SocialActivity*)activity {
    // Start the ActivityIndicator
    if (_loadingMoreActivitiesIndicator!=nil)
        [_loadingMoreActivitiesIndicator startAnimating];
    [self callProxiesToLoadActivitiesBefore:activity];
}

/*
 * Reloads the 100 newest activities
 */
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
    
    //Stop the activity indicator at the bottom
    if (_loadingMoreActivitiesIndicator!=nil)
        [_loadingMoreActivitiesIndicator stopAnimating];
    
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
    [self.view insertSubview:emptyView belowSubview:_filterTabbar];
    [emptyView release];
}

- (UITableView*) tblvActivityStream {
    return _tblvActivityStream;
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
    
    // When the user has reached the bottom of the list, load more activities
       
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height) {
        if([self shoudAutoLoadMore]) {
            // First we get the last activity of the table
            NSMutableArray *lastSectionArray = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:_arrayOfSectionsTitle.count-1]];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:lastSectionArray.count-1 inSection:_tblvActivityStream.numberOfSections-1];
            _activityAction = ActivityActionLoadMore;
            SocialActivity* lastActivity = [self getSocialActivityStreamForIndexPath:indexPath];
            // Then we load the activities before that
            [self loadActivitiesBeforeActivity:lastActivity];
        }
    }
}
         
#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    _activityAction = ActivityActionUpdate;
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
    
    if(_activityAction == ActivityActionUpdate)
    {
        //Prevent any reloading status
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityStream];
    }
    else if(_activityAction == ActivityActionLoad)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_activityAction == ActivityActionLoadMore)
    {
        _activityAction = ActivityActionUpdate;
        [self updateActivityStream];
    }
    
}

#pragma mark - change language management
- (void)updateLabelsWithNewLanguage {
    // The activity filter tabs bar
    [_filterTabbar updateLabelsWithNewLanguage];
    [_filterTabbar selectTabItem:_selectedTabItem];
    // update empty view labels
    [(EmptyView *)[self.view viewWithTag:TAG_EMPTY] setLabelContent:Localize(@"NoActivities")];
    // The list of activities
    [_tblvActivityStream reloadData];
    for (SocialActivity *a in _arrActivityStreams) {
        [a convertToPostedTimeInWords];
        [a convertToUpdatedTimeInWords];
    }
    [self.view setNeedsDisplay];
}

#pragma mark - auto load more helpers
- (BOOL)shoudAutoLoadMore
{
    NSString *plfVersionStr = [[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER];
    
    //no auto load more for plf 4.0.0
    return [plfVersionStr rangeOfString:@"4.0.0"].location == NSNotFound; }

@end

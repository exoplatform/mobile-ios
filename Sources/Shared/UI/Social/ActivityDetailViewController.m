//
//  AcitivityDetailViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityDetailCommentTableViewCell.h"
#import "ActivityDetailMessageTableViewCell.h"
#import "ActivityDetailLikeTableViewCell.h"
#import "ActivityStreamBrowseViewController.h"
#import "MessageComposerViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "SocialActivityStream.h"
#import "SocialActivityDetailsProxy.h"
#import "SocialUserProfileProxy.h"
#import "SocialActivityDetails.h"
#import "SocialComment.h"
#import "SocialLikeActivityProxy.h"
#import "ActivityDetailLikeTableViewCell.h"
#import "SocialUserProfileCache.h"

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _activity = [[Activity alloc] init];        
        _socialActivityDetails = [[SocialActivityDetails alloc] init];
        _socialActivityDetails.comments = [[NSArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_tblvActivityDetail release];
    [_navigationBar release];
    [_activity release];
    [_socialActivityStream release];
    
    [_cellForMessage release];
    [_cellForLikes release];

    [_activityDetail release];
    [_socialActivityDetails release];
    [_socialUserProfile release];
    
    [_txtvMsgComposer release];
    [_btnMsgComposer release];    
    
    [_refreshHeaderView release];
    [_dateOfLastUpdate release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)startLoadingActivityDetail
{
    _reloading = YES;
    SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:10];
    socialActivityDetailsProxy.delegate = self;
    [socialActivityDetailsProxy getActivityDetail:_socialActivityStream.activityId];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the title of the screen
    //TODO Localize
    self.title = @"Activity Details";
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    _tblvActivityDetail.backgroundView = backgroundView;
    
    [_btnMsgComposer addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
    UIImage *strechBg = [[UIImage imageNamed:@"SocialYourCommentButtonBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [_btnMsgComposer setBackgroundImage:strechBg forState:UIControlStateNormal];
    
    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityDetail.bounds.size.height, self.view.frame.size.width, _tblvActivityDetail.bounds.size.height)];
		view.delegate = self;
		[_tblvActivityDetail addSubview:view];
		_refreshHeaderView = view;
		[view release];
        _reloading = FALSE;
        
	}
    
}

/*
- (void)viewWillAppear:(BOOL)animated
{
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andActivityDetail:(ActivityDetail*)activityDetail andActivityUserProfile:(SocialUserProfile*)socialUserProfile andCurrentUserProfile:(SocialUserProfile *)currentUserProfile
{
    _socialActivityStream = socialActivityStream;
    _activityDetail = activityDetail;
    _socialUserProfile = socialUserProfile;
    _activityDetail.activityID = socialActivityStream.activityId;
    _currentUserProfile = currentUserProfile;
    
    [self startLoadingActivityDetail];
}

// Specific method to retrieve the height of the cell
// This method override the inherited one.
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 85; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 100;
    }
    
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if (theSize.height < 30) 
    {
        fHeight = 100;
    }
    else
    {
        fHeight = 75 + theSize.height;
    }
    
    if (fHeight > 200) {
        fHeight = 200;
    }
    return fHeight;
}



#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = 3;
    if ([_socialActivityDetails.likedByIdentities count] == 0) 
    {
        //n --;
    }
    if ([_socialActivityDetails.comments count] == 0) 
    {
        n--;
    }
    return n;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int n = 0;
    if (section == 0) 
    {
        n = 1;
    }
    if (section == 1) 
    {
        n = 1;
    }
    if (section == 2) 
    {
        n = [_socialActivityDetails.comments count];
    }
    return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //return 44.;
    int n = 0;
    if (indexPath.section == 0) 
    {
        n = [self getHeighSizeForTableView:tableView andText:_socialActivityStream.title];
    }
    if (indexPath.section == 1) 
    {
        NSMutableString* strLikes = [NSMutableString stringWithString:@""];
        
        if ([_socialActivityDetails.likedByIdentities count] > 0)
        { 
            
            for (int i = 0; i < [_socialActivityDetails.likedByIdentities count]; i++) 
            {
                NSDictionary *dicActivity = [_socialActivityDetails.likedByIdentities objectAtIndex:i];
                
                NSString *username = [dicActivity objectForKey:@"remoteId"];
                
                if ([_currentUserProfile.identity isEqualToString:[dicActivity objectForKey:@"id"]]) {
                    username = @"You";
                }
                
                if (i < [_activityDetail.arrLikes count] - 2) 
                {
                    [strLikes appendFormat:@"%@, ", username];
                }
                else if (i < [_activityDetail.arrLikes count] - 1) 
                {
                    [strLikes appendFormat:@"%@ ", username];
                } 
                else
                {
                    [strLikes appendFormat:@"and %@", username];
                }     
            }
            if([_activityDetail.arrLikes count] > 1)
                [strLikes appendString:@" like this"];
            else
            {
                [strLikes appendString:@"likes this"];
                strLikes = (NSMutableString *)[strLikes stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            
        }
        else
        {
            [strLikes appendString:@"No like for the moment"];
        }
        //n = [self getHeighSizeForTableView:tableView andText:strLikes];
        n = 55;
    }
    if (indexPath.section == 2) 
    {
        NSString* comment = [_activityDetail.arrComments objectAtIndex:indexPath.row];
        n = [self getHeighSizeForTableView:tableView andText:comment];

    }
    return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *kIdentifierActivityDetailMessageTableViewCell = @"ActivityDetailMessageTableViewCell";
    static NSString *kIdentifierActivityDetailLikeTableViewCell = @"ActivityDetailLikeTableViewCell";
    static NSString *kIdentifierActivityDetailCommentTableViewCell = @"ActivityDetailCommentTableViewCell";
	
    //If section for messages
    if (indexPath.section == 0) 
    {
        ActivityDetailMessageTableViewCell* cell = (ActivityDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailMessageTableViewCell];
        
        //Check if we found a cell
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailMessageTableViewCell" owner:self options:nil];
            cell = (ActivityDetailMessageTableViewCell *)[nib objectAtIndex:0];
            //Create a cell, need to do some configurations
            [cell configureCell];
        }
        cell.userInteractionEnabled = NO;
        [cell setSocialActivityDetail:_socialActivityDetails andUserName:_socialUserProfile.fullName];
        
        return cell;
    }
    else if (indexPath.section == 1) 
    {
        ActivityDetailLikeTableViewCell* cell = (ActivityDetailLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailLikeTableViewCell];
        
        //Check if we found a cell
        
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailLikeTableViewCell" owner:self options:nil];
            cell = (ActivityDetailLikeTableViewCell *)[nib objectAtIndex:0];    
            //Create a cell, need to do some configurations
            [cell configureCell];
        }
    
        cell.delegate = self;
        [cell setContent:@""];
        
        NSMutableString* strLikes = [NSMutableString stringWithString:@""];
        _currentUserLikeThisActivity = NO;
        
        if ([_socialActivityDetails.likedByIdentities count] > 0)
        { 
            for (int i = 0; i < [_socialActivityDetails.likedByIdentities count]; i++) 
            {
                NSDictionary *dicActivity = [_socialActivityDetails.likedByIdentities objectAtIndex:i];
                
                NSString *username = [dicActivity objectForKey:@"remoteId"];
                
                if ([_currentUserProfile.identity isEqualToString:[dicActivity objectForKey:@"id"]]) {
                    username = @"You";
                    _currentUserLikeThisActivity = YES;
                }
                
                if (i < [_activityDetail.arrLikes count] - 2) 
                {
                    [strLikes appendFormat:@"%@, ", username];
                }
                else if (i < [_activityDetail.arrLikes count] - 1) 
                {
                    [strLikes appendFormat:@"%@ ", username];
                } 
                else
                {
                    [strLikes appendFormat:@"and %@", username];
                }       
            }
            if (_currentUserLikeThisActivity) {
                [strLikes appendString:@"like this"];
                strLikes = (NSMutableString *)[strLikes stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            else if([_socialActivityDetails.likedByIdentities count] > 1) {
                [strLikes appendString:@"like this"];
            } else {
                [strLikes appendString:@"likes this"];
                strLikes = (NSMutableString *)[strLikes stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            
        }
        else
        {
            [strLikes appendString:@"No like for the moment"];
        }
        [cell setUserProfile:_socialUserProfile];
        [cell setContent:strLikes];
        [cell setUserLikeThisActivity:_currentUserLikeThisActivity];
        [cell setSocialActivityDetails:_socialActivityDetails];
        
        return cell;
    }
    else
    {
        ActivityDetailCommentTableViewCell* cell = (ActivityDetailCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailCommentTableViewCell];
    
        //Check if we found a cell
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailCommentTableViewCell" owner:self options:nil];
            cell = (ActivityDetailCommentTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
        }
        
        SocialComment* socialComment = [_socialActivityDetails.comments objectAtIndex:indexPath.row];
        [cell setSocialComment:socialComment];
        
        cell.userInteractionEnabled = NO;
        return cell;
    }
}



- (void)finishLoadingAllDataForActivityDetails {
    
    //Prevent any reloading status
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityDetail];
    
    //Prepare data to be displayed
    for (SocialComment* comment in _socialActivityDetails.comments) 
    {
        comment.userProfile = [[SocialUserProfileCache sharedInstance] cachedProfileForIdentity:comment.identityId];
        [comment convertToPostedTimeInWords];
    }
    
    //We have retreive new datas from API
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date] retain];
    
    [_tblvActivityDetail reloadData];
    
    
}


#pragma mark - Social Proxy Delegate

- (void)proxyDidFinishLoading:(SocialProxy *)proxy 
{
    if ([proxy isKindOfClass:[SocialActivityDetailsProxy class]]) {
        [_socialActivityDetails release];
        _socialActivityDetails = [(SocialActivityDetailsProxy*)proxy socialActivityDetails];
        [_socialActivityDetails convertToPostedTimeInWords];
        [_tblvActivityDetail reloadData];
        
        
        NSMutableSet* setOfIdentities = [[NSMutableSet alloc] init];
        
        //Retrieve all identities of comments
        for (SocialComment* comment in _socialActivityDetails.comments) {
            [setOfIdentities addObject:comment.identityId];
        }
        
        //Retrieve all identities informations
        SocialUserProfileProxy* socialUserProfile = [[SocialUserProfileProxy alloc] init];
        socialUserProfile.delegate = self;
        [socialUserProfile retrieveIdentitiesSet:setOfIdentities];
        
        //Set the last update date at now 
        _dateOfLastUpdate = [[NSDate date]retain];
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityDetail];
    }
    else if ([proxy isKindOfClass:[SocialUserProfileProxy class]]) {
        [self finishLoadingAllDataForActivityDetails];
    }else{
        SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:10];
        socialActivityDetailsProxy.delegate = self;
        [socialActivityDetailsProxy getActivityDetail:_socialActivityStream.activityId];
    }
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    
}

- (void)likeDislikeActivity:(NSString *)activity
{
    [_socialActivityDetails release];
    SocialLikeActivityProxy* likeDislikeActProxy = [[SocialLikeActivityProxy alloc] init];
    likeDislikeActProxy.delegate = self;
    
    if(_currentUserLikeThisActivity)
    {
        [likeDislikeActProxy dislikeActivity:activity];
    }
    else
    {
        [likeDislikeActProxy likeActivity:activity];
    }
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
	
    [self startLoadingActivityDetail];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _dateOfLastUpdate; // should return date data source was last changed
	
}


@end

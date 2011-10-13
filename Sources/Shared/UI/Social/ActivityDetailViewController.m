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
#import "defines.h"

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _socialActivityDetails = [[SocialActivityDetails alloc] init];
        _socialActivityDetails.comments = [[NSArray alloc] init];
        
        _activityAction = 0;
    }
    return self;
}

- (void)dealloc
{
    [_tblvActivityDetail release];
    [_navigationBar release];
    [_socialActivityStream release];
    
    [_cellForMessage release];
    [_cellForLikes release];

    [_socialActivityDetails release];
    
    [_txtvMsgComposer release];
    [_btnMsgComposer release];    
    
    [_refreshHeaderView release];
    [_dateOfLastUpdate release];

    [_hudActivityDetails release];
    _hudActivityDetails = nil;
        
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date]retain];
    
    //Add the loader
    _hudActivityDetails = [[ATMHud alloc] initWithDelegate:self];
    [_hudActivityDetails setAllowSuperviewInteraction:NO];
    [self setHudPosition];
	[self.view addSubview:_hudActivityDetails.view];
    
    //Set the title of the screen
    //TODO Localize
    self.title = @"Activity Details";
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    _tblvActivityDetail.backgroundView = backgroundView;
    [backgroundView release];
    
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
        n = 55;
    }
    if (indexPath.section == 2) 
    {
        SocialComment* comment = [_socialActivityDetails.comments objectAtIndex:indexPath.row];
        n = [self getHeighSizeForTableView:tableView andText:comment.text];

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
        [cell setSocialActivityDetail:_socialActivityDetails];
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
        
        NSString *strLike;
        NSMutableArray *arrLikes = [[NSMutableArray alloc] initWithCapacity:[_socialActivityDetails.likedByIdentities count]];
        _currentUserLikeThisActivity = NO;
        
        if ([_socialActivityDetails.likedByIdentities count] > 0)
        { 
            for (int i = 0; i < [_socialActivityDetails.likedByIdentities count]; i++) 
            {
                SocialUserProfile *userProfile = (SocialUserProfile*) [_socialActivityDetails.likedByIdentities objectAtIndex:i];
                     
                NSString *username = userProfile.fullName;
                
                if ([_socialUserProfile.identity isEqualToString:userProfile.identity]) {
                    _currentUserLikeThisActivity = YES;
                    continue;
                }
                [arrLikes addObject:[NSString stringWithFormat:@" %@", [username retain]]];
            }
//            [arrLikes addObject:@" Nguyen Dai Duong"];
//            [arrLikes addObject:@" Nguyen Dai Hai"];
//            [arrLikes addObject:@" Nguyen Dai Hai"];
            if (_currentUserLikeThisActivity) {
                [arrLikes insertObject:@"You" atIndex:0];
            }
            
            //rearrange like
            int n = [arrLikes count];
            NSMutableArray *arrCopy = [[NSMutableArray alloc] init];
            if(n == 2){
                strLike = [NSString stringWithFormat:@"%@ and%@",[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], [arrLikes objectAtIndex:1]];
            } else if(n == 3){
                if(_currentUserLikeThisActivity){
                    strLike = [NSString stringWithFormat:@"%@,%@ and%@", [[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               [arrLikes objectAtIndex:1], [arrLikes objectAtIndex:2]];
                } else {
                    strLike = [NSString stringWithFormat:@"%@,%@,%@", [[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               [arrLikes objectAtIndex:1], [arrLikes objectAtIndex:2]];
                }

            } else if(n >= 4){
                [arrCopy addObject:[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                [arrCopy addObject:[arrLikes objectAtIndex:1]];
                [arrCopy addObject:[arrLikes objectAtIndex:2]];
                
                strLike = [arrCopy componentsJoinedByString:@","];
                strLike = [strLike stringByAppendingString:[NSString stringWithFormat:@" and %d more", n-3]];
            } else if (n == 1){
                strLike = [NSString stringWithFormat:@"%@",[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
            if(n == 1 && !_currentUserLikeThisActivity)
                strLike = [strLike stringByAppendingString:@" likes this Activity"];
            else 
                strLike = [strLike stringByAppendingString:@" like this Activity"];
            [arrCopy release];
        }
        else
        {
            strLike = @"No like for the moment";
        }
        [arrLikes release];
        NSLog(@"%@", strLike);
        [cell setUserProfile:_socialActivityDetails.posterIdentity];
        [cell setContent:strLike];
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


#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoaderForAction:(int)action {
    [self setHudPosition];
    
    if(action == 0)
        [_hudActivityDetails setCaption:ACTIVITY_DETAIL_GETTING_TITLE];
    else if(action == 1)
        [_hudActivityDetails setCaption:ACTIVITY_DETAIL_UPDATING_TITLE];
    else
        [_hudActivityDetails setCaption:ACTIVITY_LIKING_TITLE];
    
    [_hudActivityDetails setActivity:YES];
    [_hudActivityDetails show];
}



- (void)hideLoader:(BOOL)successful {
    //Now update the HUD

    [self setHudPosition];
    [_hudActivityDetails hideAfter:0.1];
    
    if(successful)
    {
        [_hudActivityDetails setCaption:@"Details loaded"];    
        [_hudActivityDetails setImage:[UIImage imageNamed:@"19-check"]];
        [_hudActivityDetails hideAfter:0.5];
    }
    
    [_hudActivityDetails setActivity:NO];
    [_hudActivityDetails update];

}


#pragma mark - Data Management

- (void)updateActivityInActivityStream {
    
    
    _socialActivityStream.totalNumberOfLikes = [_socialActivityDetails.totalNumberOfLikes intValue];
    _socialActivityStream.totalNumberOfComments = [_socialActivityDetails.totalNumberOfComments intValue];  
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_ACTIVITY_UPDATED object:nil];
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
        [comment convertHTMLEncoding];
    }
    
    //We have retreive new datas from API
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date] retain];
    
    //Hide the loader
    [self hideLoader:YES];
    
    [_tblvActivityDetail reloadData];
    
    [self updateActivityInActivityStream];
}

#pragma - Proxy Management
- (void)startLoadingActivityDetail
{
    [self showLoaderForAction:_activityAction];
    
    _reloading = YES;
    SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:10 andNumberOfLikes:4];
    socialActivityDetailsProxy.delegate = self;
    [socialActivityDetailsProxy getActivityDetail:_socialActivityStream.activityId];
    
}

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andCurrentUserProfile:(SocialUserProfile *)currentUserProfile
{
    _socialActivityStream = socialActivityStream;
    _socialUserProfile = currentUserProfile;
    _activityAction = 0;
    [self startLoadingActivityDetail];
}


#pragma mark - Social Proxy Delegate

- (void)proxyDidFinishLoading:(SocialProxy *)proxy 
{
    if ([proxy isKindOfClass:[SocialActivityDetailsProxy class]]) {
        [_socialActivityDetails release];
        _socialActivityDetails = [(SocialActivityDetailsProxy*)proxy socialActivityDetails];
        [_socialActivityDetails convertToPostedTimeInWords];
        
        //Set the last update date at now 
        _dateOfLastUpdate = [[NSDate date]retain];
        
        [self finishLoadingAllDataForActivityDetails];
        //SocialLikeActivityProxy
    }else{
        SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:10 andNumberOfLikes:4];
        socialActivityDetailsProxy.delegate = self;
        [socialActivityDetailsProxy getActivityDetail:_socialActivityStream.activityId];
    }
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    //    [error localizedDescription] 
    
    NSString *alertMessage = nil;
    if(_activityAction == 0)
        alertMessage = ACTIVITY_GETTING_MESSAGE_ERROR;
    else if(_activityAction == 1)
        alertMessage = ACTIVITY_UPDATING_MESSAGE_ERROR;
    else
        alertMessage = ACTIVITY_LIKING_MESSAGE_ERROR;
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"Error" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
     
    [alertView show];
//    [alertView release];
}

- (void)likeDislikeActivity:(NSString *)activity
{
    
    [self showLoaderForAction:_activityAction];
    [_socialActivityDetails release];
    SocialLikeActivityProxy* likeDislikeActProxy = [[SocialLikeActivityProxy alloc] init];
    likeDislikeActProxy.delegate = self;
    
    if(_currentUserLikeThisActivity)
    {
        _activityAction = 3;
        [likeDislikeActProxy dislikeActivity:activity];
    }
    else
    {
        _activityAction = 2;
        [likeDislikeActProxy likeActivity:activity];
    }
}

#pragma mark -
#pragma mark MessageComposer Methods
- (void)messageComposerDidSendData{
    [self startLoadingActivityDetail];
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
	
    _activityAction = 1;
    [self startLoadingActivityDetail];	
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityDetail];
    }
    
}
@end

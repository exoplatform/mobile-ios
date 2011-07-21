//
//  ActivityStreamBrowseViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController.h"
#import "MockSocial_Activity.h"
#import "ActivityBasicTableViewCell.h"
#import "NSDate+Formatting.h"
#import "ActivityDetailViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageComposerViewController.h"
#import "ActivityDetailViewController_iPad.h"
#import "ActivityDetailViewController_iPhone.h"
#import "SocialIdentityProxy.h"
#import "SocialActivityStreamProxy.h"
#import "SocialUserProfileProxy.h"
#import "SocialActivityStream.h"

#define TEST_ON_MOCK 1


@implementation ActivityStreamBrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //_bbtnPost = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBbtnPost)];
        _bbtnPost = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnPost)];
        self.navigationItem.rightBarButtonItem = _bbtnPost;
        _txtvEditor = [[UITextView alloc] init];
        [_txtvEditor setFrame:CGRectMake(0, -100, 1, 1)];
        [self.view addSubview:_txtvEditor];
        
        _bIsPostClicked = NO;
        _bIsIPad = NO;
        
        _arrActivityStreams = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    
    _tblvActivityStream = nil ;
    MockSocial_Activity*            _mockSocial_Activity;
    
    [_arrayOfSectionsTitle release];
    _arrayOfSectionsTitle = nil;
    
    [_sortedActivities release];
    _sortedActivities=nil;
    
    [_arrActivityStreams release];
    
#if TEST_ON_MOCK        
    [_mockSocial_Activity release];
    _mockSocial_Activity = nil;
#endif
    
    [_bbtnPost release];
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
    
    self.title = @"Activity Stream";
    
    //Load Activities
#if TEST_ON_MOCK        
    //_mockSocial_Activity = [[MockSocial_Activity alloc] init];
#endif
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    
    _tblvActivityStream.backgroundView = backgroundView;
    
    //[self sortActivities];
    
    [_txtvEditor setBackgroundColor:[UIColor whiteColor]];
	[_txtvEditor setFont:[UIFont boldSystemFontOfSize:13.0]];
	[_txtvEditor setTextAlignment:UITextAlignmentLeft];
	[_txtvEditor setEditable:YES];
	
	[[_txtvEditor layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[_txtvEditor layer] setBorderWidth:1];
	[[_txtvEditor layer] setCornerRadius:8];
	[_txtvEditor setClipsToBounds: YES];
	[_txtvEditor setText:@""];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //Download datas
    [self loadActivityStream];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = _tblvActivityStream.frame;
    if (rect.size.width > 320) 
    {
        _bIsIPad = YES;
    }
    else
    {
        _bIsIPad = NO;
    }
}

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


#pragma mark - Helpers methods
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    //Default value is 0, to force the developper to implement this method
    return 0.0;
}


- (void)sortActivities 
{
    _arrayOfSectionsTitle = [[NSMutableArray alloc] init];
    
    _sortedActivities =[[NSMutableDictionary alloc] init];
    
    
    //Browse each activities
    //for (Activity *a in _mockSocial_Activity.arrayOfActivities) {
    //for (Activity *a in _arrActivityStreams) {
    for (SocialActivityStream *a in _arrActivityStreams) {    
        NSRange rangeMinute = [a.postedTimeInWords rangeOfString:@"minute"];
        NSRange rangeMinute2 = [a.postedTimeInWords rangeOfString:@"Minute"];
        NSRange rangeHour = [a.postedTimeInWords rangeOfString:@"hour"];
        NSRange rangeHour2 = [a.postedTimeInWords rangeOfString:@"Hour"];
        
        if(rangeMinute.length > 0 || rangeMinute2.length > 0 || rangeHour.length > 0 || rangeHour2.length > 0)
        {
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


//- (Activity *)getActivityForIndexPath:(NSIndexPath *)indexPath
//{
//    NSMutableArray *arrayForSection = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:indexPath.section]];
//    return [arrayForSection objectAtIndex:indexPath.row];
//}


- (SocialActivityStream *)getSocialActivityStreamForIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrayForSection = [_sortedActivities objectForKey:[_arrayOfSectionsTitle objectAtIndex:indexPath.section]];
    return [arrayForSection objectAtIndex:indexPath.row];
}


- (void)onBbtnPost
{
    [self onBbtnPost];
    //    MessageComposerViewController*  messageComposerViewController;
    //    
    //    if (_bIsIPad) 
    //    {
    //        messageComposerViewController = [[MessageComposerViewController alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    //    }
    //    else
    //    {
    //        messageComposerViewController = [[MessageComposerViewController alloc] initWithNibName:@"MessageComposerViewController" bundle:nil];
    //    }
    //    
    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    //    [messageComposerViewController release];
    //    
    //    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    
    //    if (_bIsIPad) 
    //    {
    //        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    //        [[AppDelegate_iPad instance].rootViewController presentModalViewController:navController animated:YES];
    //    }
    //    else
    //    {
    //        [self.navigationController presentModalViewController:navController animated:YES];
    //    }
    //    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post a message" message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Post", nil];
     
     if (_txtvMsgComposer ==  nil) 
     {
     _txtvMsgComposer = [[UITextView alloc] initWithFrame:CGRectMake(15, 50, 255, 100)];
     [_txtvMsgComposer setDelegate:self];
     }
     [_txtvMsgComposer becomeFirstResponder];
     [[_txtvMsgComposer layer] setCornerRadius:6.0];
     [[_txtvMsgComposer layer] setMasksToBounds:YES];
     [alert addSubview:_txtvMsgComposer];
     [alert show];
     [alert release];
     */
    
    /*
     if (_bIsPostClicked) 
     {
     [_txtvEditor resignFirstResponder];
     _bIsPostClicked = NO;
     }
     else
     {
     [_txtvEditor becomeFirstResponder];
     _bIsPostClicked = YES;
     }
     */
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    //    CGRect rectTableView = _tblvActivityDetail.frame;
    //    if (rectTableView.size.width > 320) 
    //    {
    //        _navigationBar.topItem.rightBarButtonItem = _bbtnDone;
    //    }
    //    else
    //    {
    //        self.navigationItem.rightBarButtonItem = _bbtnDone;
    //    }
    
    self.navigationItem.rightBarButtonItem = _bbtnPost;
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
	_sizeOrigin = _txtvEditor.frame;
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    CGRect rectTableView = _tblvActivityStream.frame;
    if (rectTableView.size.width > 320) 
    {
        newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y - 44;
        newTextViewFrame.origin.y = 44;
    }
    else
    {
        newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    }
    //newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    _txtvEditor.frame = newTextViewFrame;
	
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification 
{        
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
	
	//18-5
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    _txtvEditor.frame = _sizeOrigin;
    [UIView commitAnimations];
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
    
    [customView addSubview:headerLabel];
    
    
    [headerLabel release];
    
	return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
#if TEST_ON_MOCK        
    Activity* activity = [_mockSocial_Activity.arrayOfActivities objectAtIndex:indexPath.row];
    NSString* text = activity.title;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    
    return  fHeight;
#endif
    
    return 44.;
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
    
    //ActivityBasicCellViewController* activityBasicCellViewController = [[ActivityBasicCellViewController alloc] initWithNibName:@"ActivityBasicCellViewController" bundle:nil];
    
//#if TEST_ON_MOCK        
//    Activity* activity = [self getActivityForIndexPath:indexPath];
//#endif
    
    SocialActivityStream* socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    
    NSString* text = socialActivityStream.title;
    
    float fWidth = tableView.frame.size.width;
    float fHeight = [self getHeighSizeForTableView:tableView andText:text];
    [cell setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    //[activityBasicCellViewController.view setFrame:CGRectMake(0, 0, fWidth, fHeight)];
    //[cell addSubview:activityBasicCellViewController.view];
    [cell setSocialActivityStream:socialActivityStream];
    //[activityBasicCellViewController release];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //Activity* activity = [self getActivityForIndexPath:indexPath];
    SocialActivityStream* socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
    
    if (_activityDetailViewController == nil) 
    {
        CGRect rectTableView = tableView.frame;
        if (rectTableView.size.width > 320) 
        {
            _activityDetailViewController = [[ActivityDetailViewController_iPad alloc] initWithNibName:@"ActivityDetailViewController_iPad" bundle:nil];
        }
        else
        {
            ActivityDetailViewController_iPhone *activityDetailViewController = [[ActivityDetailViewController_iPhone alloc] initWithNibName:@"ActivityDetailViewController_iPhone" bundle:nil];
            activityDetailViewController._delegate = self;
            _activityDetailViewController = activityDetailViewController;
        }
        
    }
    
//    ActivityDetail* activityDetail = [[ActivityDetail alloc] initWithUserID:activity.userID arrLikes:_mockSocial_Activity.arrLikes arrComments:_mockSocial_Activity.arrComments];
//    
//    [_activityDetailViewController setActivity:activity andActivityDetail:activityDetail];

    ActivityDetail* activityDetail = [[ActivityDetail alloc] initWithUserID:socialActivityStream.identityId arrLikes:socialActivityStream.likedByIdentities arrComments:socialActivityStream.comments];
    
    [_activityDetailViewController setSocialActivityStream:socialActivityStream andActivityDetail:activityDetail];
    
    CGRect rectTableView = tableView.frame;
    
    if (rectTableView.size.width > 320)
    {
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_activityDetailViewController invokeByController:self isStackStartView:FALSE];
    }
    else
    {
        if ([self.navigationController.viewControllers containsObject:_activityDetailViewController]) 
        {
            [self.navigationController popToViewController:_activityDetailViewController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_activityDetailViewController animated:YES];
        }
    }    
}



#pragma Social WS Management
- (void)loadActivityStream {
    SocialIdentityProxy* identityProxy = [[SocialIdentityProxy alloc] init];
    identityProxy.delegate = self;
    [identityProxy getIdentityFromUser];
}


#pragma mark - Social Proxy Delegate

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
        SocialActivityStreamProxy* socialActivityStreamProxy = [[SocialActivityStreamProxy alloc] initWithSocialUserProfileProxy:(SocialUserProfileProxy *)proxy];
        socialActivityStreamProxy.delegate = self;
        [socialActivityStreamProxy getActivityStreams];
    }
    else if ([proxy isKindOfClass:[SocialActivityStreamProxy class]]) 
    {
        SocialActivityStreamProxy* socialActivityStreamProxy = (SocialActivityStreamProxy *)proxy;
        for (int i = 0; i < [socialActivityStreamProxy._arrActivityStreams count]; i++) 
        {
            SocialActivityStream* socialActivityStream = [socialActivityStreamProxy._arrActivityStreams objectAtIndex:i];
            [socialActivityStream convertToPostedTimeInWords];
            [socialActivityStream setFullName:socialActivityStreamProxy._socialUserProfileProxy.userProfile.fullName];
            [_arrActivityStreams addObject:socialActivityStream];
            /*
            Activity* activity = [[Activity alloc] initWithUserID:socialActivityStream.identityId activityID:socialActivityStream.identify  avatarUrl:nil title:socialActivityStream.title body:nil postedTime:socialActivityStream.postedTime numberOfLikes:[socialActivityStream.likedByIdentities count] numberOfComments:socialActivityStream.totalNumberOfComments];
            activity.userFullName = socialActivityStreamProxy._socialUserProfileProxy.userProfile.fullName;
            
            [_arrActivityStreams addObject:activity];
            [activity release];
            */ 
        }
        [self sortActivities];
        [_tblvActivityStream reloadData];
    } 
}


@end

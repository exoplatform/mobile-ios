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

@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _activity = [[Activity alloc] init];
        _bbtnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBbtnDone)];
        _bIsIPad = NO;
    }
    return self;
}

- (void)dealloc
{
    [_activity release];

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
    
	[_txtvEditor setBackgroundColor:[UIColor whiteColor]];
	[_txtvEditor setFont:[UIFont boldSystemFontOfSize:13.0]];
	[_txtvEditor setTextAlignment:UITextAlignmentLeft];
	[_txtvEditor setEditable:YES];
	
	[[_txtvEditor layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[_txtvEditor layer] setBorderWidth:1];
	[[_txtvEditor layer] setCornerRadius:8];
	[_txtvEditor setClipsToBounds: YES];
	[_txtvEditor setText:@""];
    
    [_btnMsgComposer addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UIImage *strechBg = [[UIImage imageNamed:@"MessageComposerButtonBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    [_btnMsgComposer setBackgroundImage:strechBg forState:UIControlStateNormal];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = _tblvActivityDetail.frame;
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

- (void)removeNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGRect rectTableView = _tblvActivityDetail.frame;
    if (rectTableView.size.width > 320) 
    {
        _navigationBar.topItem.rightBarButtonItem = _bbtnDone;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = _bbtnDone;
    }
    
    
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
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
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

- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGRect rectTableView = _tblvActivityDetail.frame;
    if (rectTableView.size.width > 320) 
    {
        _navigationBar.topItem.rightBarButtonItem = nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
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

- (void)onBbtnDone
{
    [_txtvEditor resignFirstResponder];	
}

//- (void)setActivity:(Activity*)activity andActivityDetail:(ActivityDetail*)activityDetail
//{
//    _activity = activity;
//    _activityDetail = activityDetail;
//    [_tblvActivityDetail reloadData];
//}

- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andActivityDetail:(ActivityDetail*)activityDetail
{
    _socialActivityStream = socialActivityStream;
    _activityDetail = activityDetail;
    //[_tblvActivityDetail reloadData];
    
    SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] init];
    socialActivityDetailsProxy.delegate = self;
    [socialActivityDetailsProxy getActivityDetail:socialActivityStream.identify];
}

- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 100; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 150;
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

- (void)onBtnMessageComposer
//- (IBAction)onBtnMessageComposer:(id)sender
{
    [self onBtnMessageComposer];
}


#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = 3;
    if ([_socialActivityStream.likedByIdentities count] == 0) 
    {
        n --;
    }
    if (_socialActivityStream.totalNumberOfComments == 0) 
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
        n = [_activityDetail.arrComments count];
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
        NSString* strLikes = @"";
        for (int i = 0; i < [_activityDetail.arrLikes count]; i++) 
        {
            NSString* identify = [_activityDetail.arrLikes objectAtIndex:i];
            if (i < [_activityDetail.arrLikes count] - 1) 
            {
                strLikes = [strLikes stringByAppendingString:[NSString stringWithFormat:@"%@, ", identify]];
            }
            else
            {
                strLikes = [strLikes stringByAppendingString:[NSString stringWithFormat:@"and %@", identify]];
            }
        }
        strLikes = [strLikes stringByAppendingString:@" like"];
        n = [self getHeighSizeForTableView:tableView andText:strLikes];
    }
    if (indexPath.section == 2) 
    {
        //Activity* activity = [_activityDetail.arrComments objectAtIndex:indexPath.row];
        //n = [self getHeighSizeForTableView:tableView andText:activity.title];
        
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
        //[cell setActivity:_activity];
        [cell setSocialActivityStream:_socialActivityStream];
        
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
    
        NSMutableString* strLikes = [NSMutableString stringWithString:@""];
        
        if ([_activityDetail.arrLikes count] > 0)
        { 
            
            for (int i = 0; i < [_activityDetail.arrLikes count]; i++) 
            {
                NSDictionary *dicActivity = [_activityDetail.arrLikes objectAtIndex:i];
                //                NSString* identify = [dicActivity objectForKey:@"id"];
                
                if (i < [_activityDetail.arrLikes count] - 2) 
                {
                    [strLikes appendFormat:@"%@, ", [dicActivity objectForKey:@"remoteId"]];
                }
                else if (i < [_activityDetail.arrLikes count] - 1) 
                {
                    [strLikes appendFormat:@"%@ ", [dicActivity objectForKey:@"remoteId"]];
                } 
                
                else
                {
                    [strLikes appendFormat:@"and %@", [dicActivity objectForKey:@"remoteId"]];
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
        
        cell.userInteractionEnabled = NO;
        [cell setContent:strLikes];
        
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
        
        //Activity* activity = [_activityDetail.arrComments objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = NO;
        //[cell setActivity:activity];
    
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}

#pragma mark - Social Proxy Delegate

- (void)proxyDidFinishLoading:(SocialProxy *)proxy 
{
    if ([proxy isKindOfClass:[SocialActivityDetailsProxy class]]) 
    {
        
    }
}


@end

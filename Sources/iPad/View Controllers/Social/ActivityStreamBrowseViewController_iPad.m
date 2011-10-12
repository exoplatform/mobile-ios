//
//  ActivityStreamBrowseViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "ActivityDetailViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "MessageComposerViewController.h"
#import "SocialUserProfileCache.h"
#import "StackScrollViewController.h"

@implementation ActivityStreamBrowseViewController_iPad


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_navigation.topItem setRightBarButtonItem:_bbtnPost];
}

// Specific method to retrieve the height of the cell
// This method override the inherited one.
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text  picture:(BOOL)isPicture
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
        if (isPicture){
            fHeight = 177;
        }
    }
    else
    {
        fHeight = 75 + theSize.height;
        if(isPicture){
            fHeight = 130 + theSize.height;
        }
    }
    
    if (fHeight > 200) {
        fHeight = 200;
    }
    return fHeight;
}

- (void)setHudPosition {
    NSLog(@"self.view.frame.height : %2f",self.view.frame.size.height);
    _hudActivityStream.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


- (void)onBbtnPost
{
    MessageComposerViewController_iPad* messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = YES;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[AppDelegate_iPad instance].rootViewController.menuViewController presentModalViewController:navController animated:YES];
    [messageComposerViewController release];
        
    int x, y;
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        x = 114;
        y = 300;
    }
    else 
    {
        x = 242;
        y = 70;
    }

    navController.view.superview.autoresizingMask = UIViewAutoresizingNone;
    navController.view.superview.frame = CGRectMake(x,y, 540.0f, 265.0f);
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SocialActivityStream* socialActivityStream = [super getSocialActivityStreamForIndexPath:indexPath];
    
    if (_activityDetailViewController == nil) 
    {
        _activityDetailViewController = [[ActivityDetailViewController_iPad alloc] initWithNibName:@"ActivityDetailViewController_iPad" bundle:nil];
    }
    
    _indexpathSelectedActivity = indexPath;

    [_activityDetailViewController setSocialActivityStream:socialActivityStream 
                                     andCurrentUserProfile:_socialUserProfile];

        
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_activityDetailViewController invokeByController:self isStackStartView:FALSE];
}


@end

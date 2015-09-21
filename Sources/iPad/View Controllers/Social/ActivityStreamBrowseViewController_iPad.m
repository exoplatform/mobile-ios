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

#import "ActivityStreamBrowseViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "ActivityDetailViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "MessageComposerViewController.h"
#import "SocialUserProfileCache.h"
#import "ExoStackScrollViewController.h"
#import "EGOImageView.h"
#import "SocialPictureAttach.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "LanguageHelper.h"
#import "RoundRectView.h"

@implementation ActivityStreamBrowseViewController_iPad


- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigation.topItem.title = self.title;
    self.view.backgroundColor = [UIColor clearColor];
    RoundRectView *containerView = (RoundRectView *) [self.view subviews][0];
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    containerView.squareCorners = NO;
    [_navigation.topItem setRightBarButtonItem:_bbtnPost];
    
    //Remove & re-Add the loading indicator here to be sure that this view is above the table view (& the filter view)
    [self.hudLoadWaitingWithPositionUpdated.view removeFromSuperview];
    [self.view addSubview:self.hudLoadWaitingWithPositionUpdated.view];
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
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize theSize = [textWithoutHtml boundingRectWithSize:CGSizeMake(fWidth, CGFLOAT_MAX)
                                             options:nil
                                          attributes:@{ NSFontAttributeName: kFontForMessage, NSParagraphStyleAttributeName: style }
                                             context:nil].size;
    
    if (theSize.height < 30) 
    {
        fHeight = 100;
    }
    else
    {
        fHeight = 95 + theSize.height;
    }
    
    if (isPicture) {
        fHeight += 70;
    }
    
        
    return fHeight;
}


- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


- (void)postACommentOnActivity:(NSString *)activity {
    MessageComposerViewController_iPad* messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    
    messageComposerViewController.delegate = self;    
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = activity;
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];

    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    UIViewController * menuVC =(UIViewController *)[AppDelegate_iPad instance].rootViewController.menuViewController;
    
    [menuVC presentViewController:navController animated:YES completion:nil];
        
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


- (void)onBbtnPost
{
    MessageComposerViewController_iPad* messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = YES;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController * menuVC =(UIViewController *)[AppDelegate_iPad instance].rootViewController.menuViewController;
    [menuVC presentViewController:navController animated:YES completion:nil];

        
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
    SocialActivity *socialActivityStream = [super getSocialActivityStreamForIndexPath:indexPath];
    
    if (_activityDetailViewController != nil) 
    {
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:_activityDetailViewController];
    } 
    
    _activityDetailViewController = [[ActivityDetailViewController_iPad alloc] initWithNibName:@"ActivityDetailViewController_iPad" bundle:nil];

    [_activityDetailViewController setSocialActivityStream:socialActivityStream
                                     andCurrentUserProfile:self.userProfile];

    _activityDetailViewController.iconType = [self getIconForType:socialActivityStream.type];

    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_activityDetailViewController invokeByController:self isStackStartView:FALSE];
    
    _indexpathSelectedActivity = [indexPath copy];


        
    
}

- (void)clearActivityData {
    [super clearActivityData];
    // Remove any opened activity detail panel
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:self];
}

#pragma mark - change language management

- (void)updateLabelsWithNewLanguage{
    [super updateLabelsWithNewLanguage];
    _navigation.topItem.title = Localize(@"News");
}

#pragma mark - handle orientation

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, SCREEN_HEIGHT)];    
}

@end

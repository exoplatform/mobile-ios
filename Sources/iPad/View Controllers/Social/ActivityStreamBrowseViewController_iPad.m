//
//  ActivityStreamBrowseViewController_iPad.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 eXo. All rights reserved.
//

#import "ActivityStreamBrowseViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"

@implementation ActivityStreamBrowseViewController_iPad


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_navigation.topItem setRightBarButtonItem:_bbtnPost];
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


- (void)onBbtnPost
{
    MessageComposerViewController_iPad*  messageComposerViewController;
    messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
        
    messageComposerViewController._delegate = self;
    messageComposerViewController._isPostMessage = YES;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [[AppDelegate_iPad instance].rootViewController.menuViewController presentModalViewController:navController animated:YES];
}

@end

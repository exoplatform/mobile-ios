//
//  ActivityStreamBrowseViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ActivityStreamBrowseViewController_iPhone.h"
#import "MessageComposerViewController.h"

@implementation ActivityStreamBrowseViewController_iPhone

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
        fWidth = rectTableView.size.width - 70;
    }
    
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                          lineBreakMode:UILineBreakModeWordWrap];
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
    MessageComposerViewController*  messageComposerViewController;
    
    messageComposerViewController = [[MessageComposerViewController alloc] initWithNibName:@"MessageComposerViewController" bundle:nil];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
}


@end

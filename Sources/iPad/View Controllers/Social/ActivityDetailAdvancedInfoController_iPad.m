//
//  ActivityDetailAdvancedInfoController_iPad.m
//  eXo Platform
//
//  Created by exoplatform on 6/7/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ActivityDetailAdvancedInfoController_iPad.h"
#import "SocialActivity.h"
#import "SocialComment.h"
#import "ActivityDetailCommentTableViewCell.h"
#import "ActivityLikersViewController.h"
#import "ActivityHelper.h"

#define kAdvancedCellLeftRightMargin 20.0
#define kAdvancedCellBottomMargin 10.0
#define kAdvancedCellTabBarHeight 60.0

static NSString *kTabType = @"kTapType";
static NSString *kTabTitle = @"kTapTitle";
static NSString *kTabImageName = @"kTapImageName";

@interface ActivityDetailAdvancedInfoController_iPad () {
    ActivityAdvancedInfoCellTab _selectedTab;
    NSArray *_dataSourceArray;
}
- (void)doInit;

@end

@implementation ActivityDetailAdvancedInfoController_iPad

@synthesize tabView = _tabView;
@synthesize infoView = _infoView;
@synthesize socialActivity = _socialActivity;
@synthesize likersViewController = _likersViewController;


- (void)dealloc {
    [_tabView release];
    [_infoView release];
    [_socialActivity release];
    [_likersViewController release];
    [_dataSourceArray release];
    [super dealloc];
}

- (void)doInit {
    _dataSourceArray = [[NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:ActivityAdvancedInfoCellTabComment], kTabType,
                            @"comments", kTabTitle, 
                            @"activity-detail-tabs-comment-icon", kTabImageName, 
                            nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:ActivityAdvancedInfoCellTabLike], kTabType,
                            @"Likes", kTabTitle, 
                            @"activity-detail-tabs-likers-icon", kTabImageName, 
                            nil],
                        nil] retain];
}

- (id)init {
    if (self = [super init]) {
        [self doInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectZero;
    [self.view setAutoresizesSubviews:YES];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    for (NSDictionary *tabData in _dataSourceArray) {
        [self.tabView addTabItemWithTitle:[tabData valueForKey:kTabTitle] icon:[UIImage imageNamed:[tabData valueForKey:kTabImageName]]];        
    }
    
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.infoView];
    [self selectTab:ActivityAdvancedInfoCellTabComment];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - subviews initialization
- (JMTabView *)tabView {
    if (!_tabView) {
        _tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kAdvancedCellTabBarHeight)];
        _tabView.delegate = self;
        [_tabView setBackgroundLayer:nil];
    }
    return _tabView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoView.delegate = self;
        _infoView.dataSource = self;
        [_infoView.layer setCornerRadius:10.0];
        [_infoView.layer setMasksToBounds:YES];
        [_infoView setBackgroundColor:[UIColor colorWithRed:220./255 green:220./255 blue:220./255 alpha:1]];

    }
    return _infoView;
}

- (ActivityLikersViewController *)likersViewController {
    if (!_likersViewController) {
        _likersViewController = [[ActivityLikersViewController alloc] init];
    }
    return _likersViewController;
}

- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [socialActivity retain];
    [_socialActivity release];
    _socialActivity = socialActivity;
    self.likersViewController.socialActivity = socialActivity;
}

#pragma mark - controller methods 
- (void)selectTab:(ActivityAdvancedInfoCellTab)selectedTab {
    [self.tabView setSelectedIndex:selectedTab];
}


- (void)updateSubViews {
    CGRect viewBounds = self.view.bounds;
    self.tabView.frame = CGRectMake(0, 0, viewBounds.size.width, kAdvancedCellTabBarHeight);
    CGRect infoFrame = CGRectZero;
    infoFrame.origin.x = kAdvancedCellLeftRightMargin;
    infoFrame.origin.y = self.tabView.frame.origin.y + self.tabView.frame.size.height;
    infoFrame.size.width = viewBounds.size.width - kAdvancedCellLeftRightMargin * 2;
    infoFrame.size.height = viewBounds.size.height - kAdvancedCellBottomMargin - infoFrame.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.infoView.frame = infoFrame;
    [UIView commitAnimations];
//    [self.infoView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifierActivityDetailCommentTableViewCell = @"ActivityDetailCommentTableViewCell";
    static NSString *kIdentifierActivityDetailLikersTableViewCell = @"ActivityDetailLikersTableViewCell";
    if (_selectedTab == ActivityAdvancedInfoCellTabComment) {
        ActivityDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailCommentTableViewCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailCommentTableViewCell" owner:self options:nil];
            cell = (ActivityDetailCommentTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
            cell.width = tableView.frame.size.width;
        }
        SocialComment* socialComment = [self.socialActivity.comments objectAtIndex:indexPath.row];
        [cell setSocialComment:socialComment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;        
    } else if (_selectedTab == ActivityAdvancedInfoCellTabLike) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailLikersTableViewCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifierActivityDetailLikersTableViewCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.likersViewController.view];            
            self.likersViewController.view.backgroundColor = [UIColor clearColor];
            [self.likersViewController updateListOfLikers];
        }
        CGRect likerRect = CGRectZero;
        likerRect.size.width = self.infoView.frame.size.width;
        likerRect.size.height = self.infoView.frame.size.height;
        self.likersViewController.view.frame = likerRect;
        [self.likersViewController updateLikerViews];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_selectedTab) {
        case ActivityAdvancedInfoCellTabLike: {
            return self.infoView.frame.size.height;
        }
        case ActivityAdvancedInfoCellTabComment: {
            SocialComment *comment = [self.socialActivity.comments objectAtIndex:indexPath.row];
            return [ActivityHelper calculateCellHeighForTableView:tableView andText:comment.text];
        }
        default:
            return 0;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_selectedTab) {
        case ActivityAdvancedInfoCellTabLike:
            return 1;
        case ActivityAdvancedInfoCellTabComment:
            return [self.socialActivity.comments count];
        default:
            return 0;
    }
}
#pragma mark - JMTabViewDelegate 
- (void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    _selectedTab = [[[_dataSourceArray objectAtIndex:itemIndex] valueForKey:kTabType] intValue];
    [self updateSubViews];
}

@end

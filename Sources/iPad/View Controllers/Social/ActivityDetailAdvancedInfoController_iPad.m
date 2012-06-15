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
#import "LanguageHelper.h"
#import "EmptyView.h"


#define kAdvancedCellLeftRightMargin 20.0
#define kAdvancedCellLeftRightPadding 1.0
#define kAdvancedCellBottomPadding 7.0
#define kAdvancedCellBottomMargin 10.0
#define kAdvancedCellTabBarHeight 60.0
#define kCommentButtonHeight 50.0

#pragma mark - Customize JMSelectionView & JMTabItem

#define kTriangleHeight 10.0
@interface CustomTabItem : JMTabItem

@end

@implementation CustomTabItem 

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = [super sizeThatFits:size];
    newSize.height += kTriangleHeight;
    return newSize;
}

- (void)drawRect:(CGRect)rect {
    CGRect contentRect = rect;
    contentRect.size.height -= kTriangleHeight;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * shadowColor = [UIColor blackColor];
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 1.0f, [shadowColor CGColor]);
    CGContextSaveGState(context);   
    
    CGFloat xOffset = self.padding.width;
    
    if (self.icon)
    {
        [self.icon drawAtPoint:CGPointMake(xOffset, self.padding.height)];
        xOffset += [self.icon size].width + kTabItemIconMargin;
    }
    
    [kTabItemTextColor set];
    
    CGFloat heightTitle = [self.title sizeWithFont:kTabItemFont].height;
    CGFloat titleYOffset = (contentRect.size.height - heightTitle) / 2;
    [self.title drawAtPoint:CGPointMake(xOffset, titleYOffset) withFont:kTabItemFont];
    
    CGContextRestoreGState(context);
}

@end

@interface CustomSelectionView : JMSelectionView 

@end

@implementation CustomSelectionView 

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.7f;
        self.clipsToBounds = NO;
    }
    return self;
}

CGMutablePathRef createCommentShapeForRect(CGRect rect, CGFloat radius) {
    CGRect squareRect = rect;
    squareRect.size.height -= kTriangleHeight;
    CGFloat minx = CGRectGetMinX(squareRect), midx = CGRectGetMidX(squareRect), maxx = CGRectGetMaxX(squareRect); 
    CGFloat miny = CGRectGetMinY(squareRect), maxy = CGRectGetMaxY(squareRect);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, midx, miny);
    CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, radius);
    CGPathAddArcToPoint(path, NULL, maxx, maxy, minx, maxy, radius);
    CGPathAddLineToPoint(path, NULL, midx + kTriangleHeight, maxy);
    CGPathAddLineToPoint(path, NULL, midx, maxy + kTriangleHeight);
    CGPathAddLineToPoint(path, NULL, midx - kTriangleHeight, maxy);
    CGPathAddArcToPoint(path, NULL, minx, maxy, minx, miny, radius);
    CGPathAddArcToPoint(path, NULL, minx, miny, maxx, miny, radius);
    CGPathCloseSubpath(path);
    
    return path;        
}




- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    float borderWidth = 1.;
    CGRect squareRect = CGRectOffset(rect, borderWidth, borderWidth);
    squareRect.size.width -= borderWidth * 2;
    squareRect.size.height -= borderWidth * 2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern-button"]].CGColor);
    CGPathRef shapePath = createCommentShapeForRect(squareRect, 8.);
    CGContextAddPath(context, shapePath);
    CGContextFillPath(context);
    
    
    CGRect borderRect = CGRectMake(rect.origin.x + borderWidth / 2, rect.origin.y + borderWidth / 2, rect.size.width - borderWidth, rect.size.height - borderWidth);
    CGPathRef borderPath = createCommentShapeForRect(borderRect, 8.);
    CGContextAddPath(context, borderPath);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:120./255 green:157./255 blue:185./255 alpha:1].CGColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextStrokePath(context);
    
    CGPathRelease(shapePath);
    CGPathRelease(borderPath);
    CGContextRestoreGState(context);
}

@end

#pragma mark - Custom View for activity detail info 
@interface InfoContainerView : UIView 

@end

@implementation InfoContainerView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 7.0;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.7f;
        self.clipsToBounds = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIBezierPath *contentPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:7.0];
    CGContextAddPath(context, contentPath.CGPath);
    CGContextClip(context);
    CGRect contentRect = CGRectInset(rect, 0.5, 0.5);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal"]].CGColor);
    CGContextFillRect(context, contentRect);

    UIImage *borderImg = [UIImage imageNamed:@"activity-detail-info-container-bg"];
    borderImg = [borderImg stretchableImageWithLeftCapWidth:borderImg.size.width/2 topCapHeight:borderImg.size.height/2];
    [borderImg drawInRect:rect];
    
    CGContextRestoreGState(context);
}

@end


#pragma mark - ActivityDetailAdvancedInfoController_iPad implementation

static NSString *kTabType = @"kTapType";
static NSString *kTabTitle = @"kTapTitle";
static NSString *kTabImageName = @"kTapImageName";
static NSString *kTabItem = @"kTabItem";

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
@synthesize emptyView = _emptyView;
@synthesize commentButton = _commentButton;
@synthesize infoContainer = _infoContainer;

- (void)dealloc {
    [_tabView release];
    [_infoView release];
    [_socialActivity release];
    [_likersViewController release];
    [_emptyView release];
    [_commentButton release];
    [_infoContainer release];
    [_dataSourceArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    self.emptyView = nil;
    self.likersViewController = nil;
    self.infoView = nil;
    self.tabView = nil;
    self.commentButton = nil;
    [super didReceiveMemoryWarning];
}

- (void)doInit {
    _dataSourceArray = [[NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:ActivityAdvancedInfoCellTabComment], kTabType,
                            @"comments(%d)", kTabTitle, 
                            [[[CustomTabItem alloc] initWithTitle:@"" icon:[UIImage imageNamed:@"activity-detail-tabs-comment-icon"]] autorelease], kTabItem,
                            nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:ActivityAdvancedInfoCellTabLike], kTabType,
                            @"likes(%d)", kTabTitle, 
                            [[[CustomTabItem alloc] initWithTitle:@"" icon:[UIImage imageNamed:@"activity-detail-tabs-likers-icon"]] autorelease], kTabItem, 
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
        JMTabItem *tabItem = [tabData objectForKey:kTabItem];
        tabItem.highlighted = NO;
        [self.tabView addTabItem:tabItem];
    }
    
    [self.view addSubview:self.tabView];
    [self.view insertSubview:self.infoContainer belowSubview:self.tabView];
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
        [_tabView setSelectionView:[[[CustomSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
        [_tabView setItemPadding:CGSizeMake(16.0, 7.0)];
    }
    return _tabView;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoView.delegate = self;
        _infoView.dataSource = self;
        _infoView.backgroundColor = [UIColor clearColor];
        
    }
    return _infoView;
}

- (ActivityLikersViewController *)likersViewController {
    if (!_likersViewController) {
        _likersViewController = [[ActivityLikersViewController alloc] init];
    }
    return _likersViewController;
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoActivities" andContent:Localize(@"NoComment")];
    }
    return _emptyView;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        _commentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        UIImage *backgroundImage = [UIImage imageNamed:@"activity-detail-comment-textfield-bg"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width / 2 topCapHeight:backgroundImage.size.height / 2];
        [_commentButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage *selectedImg = [UIImage imageNamed:@"activity-detail-comment-textfield-bg-selected"];
        selectedImg = [selectedImg stretchableImageWithLeftCapWidth:selectedImg.size.width/2 topCapHeight:selectedImg.size.height/2];
        [_commentButton setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        [_commentButton setTitle:Localize(@"YourComment") forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.]];
        _commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30., 0, 0);
        
    }
    return _commentButton;
}

- (UIView *)infoContainer {
    if (!_infoContainer) {
        _infoContainer = [[InfoContainerView alloc] init];
        _infoContainer.autoresizesSubviews = YES;

        [_infoContainer addSubview:self.infoView];
        [_infoContainer insertSubview:self.commentButton belowSubview:self.infoView];
    }
    return _infoContainer;
}

- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [socialActivity retain];
    [_socialActivity release];
    _socialActivity = socialActivity;
    self.likersViewController.socialActivity = socialActivity;
    [self updateTabLabels];
}

#pragma mark - controller methods 
- (void)jumpToLastCommentIfExist {
    if(_selectedTab == ActivityAdvancedInfoCellTabComment && [self.socialActivity.comments count] > 0){
        [self.infoView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.socialActivity.comments count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)selectTab:(ActivityAdvancedInfoCellTab)selectedTab {
    [self.tabView setSelectedIndex:selectedTab];
}

- (void)updateTabLabels {
    for (NSDictionary *tabData in _dataSourceArray) {
        JMTabItem *tabItem = [tabData objectForKey:kTabItem];
        int number = 0;
        ActivityAdvancedInfoCellTab tabType = [[tabData objectForKey:kTabType] intValue];
        switch (tabType) {
            case ActivityAdvancedInfoCellTabComment:
                number = self.socialActivity.totalNumberOfComments;
                break;
            case ActivityAdvancedInfoCellTabLike:
                number = self.socialActivity.totalNumberOfLikes;
                break;
            default:
                break;
        }
        tabItem.title = [NSString stringWithFormat:Localize([tabData objectForKey:kTabTitle]), number];
    }
}

- (void)updateSubViews {
    CGRect viewBounds = self.view.bounds;
    self.tabView.frame = CGRectMake(0, 0, viewBounds.size.width, kAdvancedCellTabBarHeight);
    CGRect infoFrame = CGRectZero;
    infoFrame.origin.x = kAdvancedCellLeftRightMargin;
    infoFrame.origin.y = self.tabView.frame.origin.y + self.tabView.frame.size.height - kTriangleHeight;
    infoFrame.size.width = viewBounds.size.width - kAdvancedCellLeftRightMargin * 2;
    infoFrame.size.height = viewBounds.size.height - kAdvancedCellBottomMargin - infoFrame.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.infoContainer.frame = infoFrame;
    [UIView commitAnimations];
    
    [self reloadInfoContainerWithAnimated:NO];
}

- (void)reloadInfoContainerWithAnimated:(BOOL)animated {
    CGRect infoFrame = self.infoContainer.frame;
    if (_selectedTab == ActivityAdvancedInfoCellTabComment) {
        self.infoView.frame = CGRectMake(kAdvancedCellLeftRightPadding, 0, infoFrame.size.width - kAdvancedCellLeftRightPadding * 2, infoFrame.size.height - kCommentButtonHeight - kAdvancedCellBottomPadding);
        self.commentButton.frame = CGRectMake(kAdvancedCellLeftRightPadding, infoFrame.size.height - kCommentButtonHeight - kAdvancedCellBottomPadding, infoFrame.size.width - kAdvancedCellLeftRightPadding * 2, kCommentButtonHeight);
        
        [self.infoView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(animated ? UITableViewRowAnimationLeft : UITableViewRowAnimationNone)];
    } else if (_selectedTab == ActivityAdvancedInfoCellTabLike) {
        self.infoView.frame = CGRectMake(kAdvancedCellLeftRightPadding, 0, infoFrame.size.width - kAdvancedCellLeftRightPadding * 2, infoFrame.size.height - kAdvancedCellBottomPadding);
        self.commentButton.frame = CGRectZero;
        [self.infoView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(animated ? UITableViewRowAnimationRight : UITableViewRowAnimationNone)];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedTab == ActivityAdvancedInfoCellTabComment && self.socialActivity.totalNumberOfComments == 0) {
        [self.emptyView removeFromSuperview];
        [cell.contentView addSubview:self.emptyView];
        self.emptyView.frame = self.infoView.bounds;
        self.emptyView.frame = self.infoView.bounds;
    } else if (_selectedTab == ActivityAdvancedInfoCellTabLike) {
        CGRect likerRect = CGRectZero;
        likerRect.size.width = self.infoView.frame.size.width;
        likerRect.size.height = self.infoView.frame.size.height;
        self.likersViewController.view.frame = likerRect;
        [self.likersViewController updateLikerViews];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifierActivityDetailCommentTableViewCell = @"ActivityDetailCommentTableViewCell";
    static NSString *kIdentifierActivityDetailLikersTableViewCell = @"ActivityDetailLikersTableViewCell";
    static NSString *kIdentifierActivityDetailEmptyViewCell = @"ActivityDetailEmptyViewCell";
    if (_selectedTab == ActivityAdvancedInfoCellTabComment) {
        if (self.socialActivity.totalNumberOfComments == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailEmptyViewCell];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifierActivityDetailEmptyViewCell] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
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
            if (self.socialActivity.totalNumberOfComments > 0) {
                SocialComment *comment = [self.socialActivity.comments objectAtIndex:indexPath.row];
                return [ActivityHelper calculateCellHeighForTableView:tableView andText:comment.text];                
            } else {
                return self.infoView.frame.size.height;
            }
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
            return self.socialActivity.totalNumberOfComments == 0 ? 1 : [self.socialActivity.comments count];
        default:
            return 0;
    }
}
#pragma mark - JMTabViewDelegate 
- (void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    ActivityAdvancedInfoCellTab selectedTab = [[[_dataSourceArray objectAtIndex:itemIndex] valueForKey:kTabType] intValue];
    if (_selectedTab != selectedTab) {
        _selectedTab = selectedTab;
        [self reloadInfoContainerWithAnimated:YES];
    }
}

@end

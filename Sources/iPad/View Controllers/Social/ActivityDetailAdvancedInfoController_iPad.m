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
#define kAdvancedCellBottomMargin 10.0
#define kAdvancedCellTabBarHeight 60.0

@interface CustomTabItem : JMTabItem

@end

@implementation CustomTabItem 

- (void)drawRect:(CGRect)rect {
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
    CGFloat titleYOffset = (self.bounds.size.height - heightTitle) / 2;
    [self.title drawAtPoint:CGPointMake(xOffset, titleYOffset) withFont:kTabItemFont];
    
    CGContextRestoreGState(context);
}

@end

@interface CustomSelectionView : JMSelectionView 

@end

#define kTriangleHeight 8.0
@implementation CustomSelectionView 

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(0, -3.0);
        self.layer.shadowRadius = 0.;
        self.layer.shadowColor = [[UIColor whiteColor] CGColor];
        self.layer.shadowOpacity = 0;
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
    CGContextClosePath(context);
    
    // draw Shadow
    CGContextSaveGState(context);
    float offset = 20.;
    CGRect largerRect = CGRectInset(squareRect, -offset, -offset);
    largerRect.size.height -= offset;
    CGMutablePathRef largerPath = createCommentShapeForRect(largerRect, 8.);
    CGPathAddPath(largerPath, NULL, shapePath);
    CGContextAddPath(context, shapePath);
    CGContextClip(context);
    
    
    UIColor * shadowColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 8.0f, [shadowColor CGColor]);
    [shadowColor setFill];   
    
    CGContextAddPath(context, largerPath);
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
    // ------
    
    CGRect borderRect = CGRectMake(rect.origin.x + borderWidth / 2, rect.origin.y + borderWidth / 2, rect.size.width - borderWidth, rect.size.height - borderWidth);
    CGPathRef borderPath = createCommentShapeForRect(borderRect, 8.);
    CGContextAddPath(context, borderPath);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:120./255 green:157./255 blue:185./255 alpha:1].CGColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    
    CGPathRelease(shapePath);
    CGPathRelease(borderPath);
    CGPathRelease(largerPath);
    CGContextRestoreGState(context);
}

@end


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

- (void)dealloc {
    [_tabView release];
    [_infoView release];
    [_socialActivity release];
    [_likersViewController release];
    [_emptyView release];
    [_dataSourceArray release];
    [super dealloc];
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
        [_tabView setSelectionView:[[[CustomSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoActivities" andContent:Localize(@"NoComment")];
    }
    return _emptyView;
}

- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [socialActivity retain];
    [_socialActivity release];
    _socialActivity = socialActivity;
    self.likersViewController.socialActivity = socialActivity;
    [self updateTabLabels];
}

#pragma mark - controller methods 
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
    infoFrame.origin.y = self.tabView.frame.origin.y + self.tabView.frame.size.height;
    infoFrame.size.width = viewBounds.size.width - kAdvancedCellLeftRightMargin * 2;
    infoFrame.size.height = viewBounds.size.height - kAdvancedCellBottomMargin - infoFrame.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    self.infoView.frame = infoFrame;
    [UIView commitAnimations];
    [self.infoView reloadData];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
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
                [cell.contentView addSubview:self.emptyView];
            }
            self.emptyView.frame = self.infoView.bounds;
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
    _selectedTab = [[[_dataSourceArray objectAtIndex:itemIndex] valueForKey:kTabType] intValue];
    [self.infoView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
}

@end

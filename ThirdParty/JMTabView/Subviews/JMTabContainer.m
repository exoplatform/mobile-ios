//  Created by Jason Morrissey

#import "JMTabContainer.h"
#import "JMTabView.h"
#import "UIView+Positioning.h"

#define kSelectionAnimation @"kSelectionAnimation"

@interface JMTabContainer()
@property (nonatomic,retain) NSMutableArray * tabItems;
@end

@implementation JMTabContainer

@synthesize tabItems = tabItems_;
@synthesize selectionView = selectionView_;
@synthesize selectedIndex = selectedIndex_;
@synthesize momentary = momentary_;
@synthesize itemSpacing = itemSpacing_;

- (void)dealloc
{
    self.tabItems = nil;
    self.selectionView = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {   
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabItems = [NSMutableArray array];
        self.selectionView = [[[JMSelectionView alloc] initWithFrame:CGRectZero] autorelease];
        self.itemSpacing = kTabSpacing;
        self.bounces = YES;
        self.scrollEnabled = YES;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self addSubview:self.selectionView];
    }
    return self;
}

- (void)layoutSubviews;
{
   
    CGFloat xOffset = self.itemSpacing;
    CGFloat yOffset = 0.;
    CGFloat itemHeight = 0.;

    for (JMTabItem * item in self.tabItems)
    {
        [item sizeToFit];
        [item setFrame:CGRectMake(xOffset, yOffset, item.frame.size.width, item.frame.size.height)];
        
        xOffset += item.frame.size.width + self.itemSpacing;

        itemHeight = MAX(itemHeight, item.frame.size.height);
    }
    
    CGRect f = CGRectMake(self.frame.origin.x,
                          self.frame.origin.y,
                          xOffset < self.superview.frame.size.width
                            ? xOffset
                            : self.superview.frame.size.width,
                          itemHeight
                          );
    
    if (!CGRectEqualToRect(f, self.frame)) {
        self.frame = f;
    }
    
    self.contentSize = CGSizeMake(xOffset, itemHeight);
    [self centerInSuperView];
    self.scrollEnabled = self.frame.size.width < self.contentSize.width;
}

- (void)addTabItem:(JMTabItem *)tabItem;
{
    [self.tabItems addObject:tabItem];
    [self addSubview:tabItem];
    [self setNeedsLayout];
}

- (void)removeTabItem:(JMTabItem *)tabItem {
    [self.tabItems removeObject:tabItem];
    [tabItem removeFromSuperview];
    [self setNeedsLayout];
}

- (void)removeAllTabItems {
    for (JMTabItem *tabItem in self.tabItems) {
        [tabItem removeFromSuperview];
    }
    [[self tabItems] removeAllObjects];
    [self setNeedsLayout];
}

- (BOOL)isItemSelected:(JMTabItem *)tabItem;
{
    return ([self.tabItems indexOfObject:tabItem] == self.selectedIndex);
} 

- (void)itemSelected:(JMTabItem *)tabItem;
{
    self.selectedIndex = [self.tabItems indexOfObject:tabItem];
    
    if (!self.momentary)
    {
        [self animateSelectionToItemAtIndex:self.selectedIndex];
    }
    
    for (JMTabItem * item in self.tabItems)
    {
        [item setNeedsDisplay];
    }
    
    // notify parent tabView
    JMTabView * tabView = (JMTabView *)[self superview];
    [tabView didSelectItemAtIndex:self.selectedIndex];
}

- (void)animateSelectionToItemAtIndex:(NSUInteger)itemIndex;
{
    JMTabItem * tabItem = (self.tabItems)[itemIndex];
    [UIView beginAnimations:kSelectionAnimation context:self.selectionView];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:(CGRectIsEmpty(self.selectionView.frame) ? 0. : kTabSelectionAnimationDuration)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.selectionView.frame = tabItem.frame;
    
    if (tabItem.frame.origin.x - self.itemSpacing < self.contentOffset.x) {
        [self setContentOffset:CGPointMake(tabItem.frame.origin.x - self.itemSpacing, 0) animated:FALSE];
    } else if (self.frame.size.width > 0 && tabItem.frame.origin.x + tabItem.frame.size.width + self.itemSpacing > self.contentOffset.x + self.frame.size.width) {
        [self setContentOffset:CGPointMake(self.contentOffset.x + (tabItem.frame.origin.x + tabItem.frame.size.width + self.itemSpacing) - (self.contentOffset.x + self.frame.size.width), 0) animated:FALSE];
    }

    [UIView commitAnimations];
}

- (NSUInteger)numberOfTabItems;
{
    return [self.tabItems count];
}

#pragma mark - Tab Item Accessors

- (JMTabItem *)tabItemAtIndex:(NSUInteger)index {
    return (self.tabItems)[index];
}

@end

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

#import "ActivityStreamTabbar.h"
#import <QuartzCore/QuartzCore.h>
#import "LanguageHelper.h"

#define kFilterTabTopBottomPadding 5.0
#define kFilterTabLeftRightPadding 10.0
#define kFilterTabItemSeparateSpace 0.0
#define kFilterTabItemPadding (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 25. : 10.)

#define kActivityStreamTabItemTitle @"item title"
#define kActivityStreamTabItem @"custom JMItem"
#define kActivityStreamTabItemFont [UIFont systemFontOfSize:12.]

@interface ActivityStreamTabbar (PrivateMethods)
- (float)calculateItemSpacing; 
@end

@interface CustomFilterItem : JMTabItem

@property (nonatomic) CGSize itemSize;

@end

@implementation CustomFilterItem

@synthesize itemSize = _itemSize;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    if (self = [super initWithTitle:title icon:icon]) {
        self.showsTouchWhenHighlighted = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName:kActivityStreamTabItemFont}];
    return CGSizeMake(titleSize.width + kFilterTabItemPadding * 2, _itemSize.height);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIColor *textColor = self.isSelectedTabItem ? [UIColor colorWithRed:84./255 green:84./255 blue:84./255 alpha:1.] : [UIColor colorWithRed:122./255 green:122./255 blue:122./255 alpha:1.];
    [textColor set];
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName:kActivityStreamTabItemFont}];
    float xOffset = (rect.size.width - titleSize.width) / 2;
    float yOffset = (rect.size.height - titleSize.height) / 2;
    [self.title drawAtPoint:CGPointMake(xOffset, yOffset) withAttributes:@{NSFontAttributeName:kActivityStreamTabItemFont}];
    CGContextRestoreGState(context);
}

@end

@interface CustomActivityFilterSelectionView : JMSelectionView

@end

@implementation CustomActivityFilterSelectionView 

- (void)drawRect:(CGRect)rect {
    UIImage *bgImage = [UIImage imageNamed:@"activity-stream-filter-item-active-state.png"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    [bgImage drawInRect:rect];
}

@end

@interface ActivityStreamTabbar () {
    BOOL _istranslucent;
}

- (void)initData;

@end

@implementation ActivityStreamTabbar

@synthesize tabView = _tabView;

#pragma mark - initilization

- (void)dealloc {
    [_listOfItems release];
    [_tabView release];
    [super dealloc];
}

- (void)initData {
    _listOfItems = [[NSMutableArray alloc] init];
    for (int i = 0; ;i++) {
        NSString *title = nil;
        if (i == ActivityStreamTabItemAllUpdate) {
            title = @"All Updates";
        } else if (i == ActivityStreamTabItemMyConnections) {
            title = @"My Connections";
        } else if (i == ActivityStreamTabItemMySpaces) {
            title = @"My Spaces";
        } else if (i == ActivityStreamTabItemMyStatus) {
            title = @"My Status";
        } else {
            break;
        }
        CustomFilterItem *item = [[[CustomFilterItem alloc] initWithTitle:Localize(title) icon:nil] autorelease];
        [self.tabView addTabItem:item];
        NSDictionary *dict = @{kActivityStreamTabItemTitle: title,
                              kActivityStreamTabItem: item};
        [_listOfItems insertObject:dict atIndex:i];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _istranslucent = NO;
        self.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"activity-stream-filter-tabbar-bg.png"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        UIImageView *backgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView];
        
        self.tabView = [[[JMTabView alloc] initWithFrame:CGRectInset(self.bounds, kFilterTabLeftRightPadding, kFilterTabTopBottomPadding)] autorelease];
        [self initData];
        [self.tabView setSelectionView:[[[CustomActivityFilterSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
        [self.tabView setBackgroundLayer:nil];
        CGRect contentRect = self.tabView.bounds;
        float itemSpacing = (contentRect.size.width - [self calculateItemSpacing]) / ([_listOfItems count] - 1);
        // we keep a minimum space between items of 3 pts
        // if the total width of the items is larger than the screen, the area becomes scrollable
        if (itemSpacing < 3.) itemSpacing = 3.;
        [self.tabView setItemSpacing:itemSpacing];
        float itemWidth = (contentRect.size.width - kFilterTabItemSeparateSpace * (_listOfItems.count - 1)) / (_listOfItems.count);
        for (NSDictionary *dict in _listOfItems) {
            CustomFilterItem *item = dict[kActivityStreamTabItem];
            item.itemSize = CGSizeMake(itemWidth, contentRect.size.height);
        }
        [self insertSubview:self.tabView aboveSubview:backgroundView];
        
    }
    return self;
}

- (float)calculateItemSpacing; 
{
    float itemsWidth = 0;
    for (NSDictionary *itemData in _listOfItems) {
        NSString *title = Localize(itemData[kActivityStreamTabItemTitle]);
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: kActivityStreamTabItemFont}];
        itemsWidth += titleSize.width + kFilterTabItemPadding * 2;
        
    }
    return itemsWidth;
}

#pragma mark - view management

- (void)translucentView:(BOOL)translucent {
    
    if (translucent ^ _istranslucent) {
        if (translucent) 
            self.backgroundColor = [UIColor clearColor];
        else 
            self.backgroundColor = [UIColor whiteColor];
        _istranslucent = translucent;
    }
}

- (void)selectTabItem:(ActivityStreamTabItem)selectedTabItem {
    [self.tabView setSelectedIndex:selectedTabItem];
    [self.tabView didSelectItemAtIndex:selectedTabItem];
}

#pragma mark - language change management

- (void)updateLabelsWithNewLanguage {
    for(int i=0; i<_listOfItems.count; i++) {
        // Update the title of each tab
        NSDictionary *dict = _listOfItems[i];
        CustomFilterItem* item = dict[kActivityStreamTabItem];
        if (i == ActivityStreamTabItemAllUpdate) {
            item.title = Localize(@"All Updates");
        } else if (i == ActivityStreamTabItemMyConnections) {
            item.title = Localize(@"My Connections");
        } else if (i == ActivityStreamTabItemMySpaces) {
            item.title = Localize(@"My Spaces");
        } else if (i == ActivityStreamTabItemMyStatus) {
            item.title = Localize(@"My Status");
        }
        [item setNeedsDisplay];
    }
}

@end

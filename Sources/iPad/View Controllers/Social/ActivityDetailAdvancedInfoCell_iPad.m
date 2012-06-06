//
//  ActivityDetailAdvancedInfoCell.m
//  eXo Platform
//
//  Created by exoplatform on 6/5/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "ActivityDetailAdvancedInfoCell_iPad.h"
#import "JMTabView.h"
#import "SocialActivity.h"

#define kAdvancedCellLeftRightMargin 10.0
#define kAdvancedCellBottomMargin 10.0
#define kAdvancedCellTabBarHeight 60.0

@interface ActivityDetailAdvancedInfoCell_iPad () 

- (void)doInit;

@end

@implementation ActivityDetailAdvancedInfoCell_iPad

@synthesize tabView = _tabView;
@synthesize socialActivity = _socialActivity;
@synthesize infoView = _infoView;

- (void)dealloc {
    [_socialActivity release];
    [_tabView release];
    [_infoView release];
    [super dealloc];
}

- (void)doInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.tabView];
    [self.tabView addTabItemWithTitle:@"Comments" icon:[UIImage imageNamed:@"activity-detail-tabs-comment-icon"]];
    [self.tabView addTabItemWithTitle:@"Likes" icon:[UIImage imageNamed:@"activity-detail-tabs-likers-icon"]];
    [self.contentView addSubview:self.infoView];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tabView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, kAdvancedCellTabBarHeight);
    CGRect infoFrame = CGRectZero;
    CGRect contentViewBounds = self.contentView.bounds;
    infoFrame.origin.x = kAdvancedCellLeftRightMargin;
    infoFrame.origin.y = self.tabView.frame.origin.y + self.tabView.frame.size.height;
    infoFrame.size.width = contentViewBounds.size.width - kAdvancedCellLeftRightMargin * 2;
    infoFrame.size.height = contentViewBounds.size.height - kAdvancedCellBottomMargin - self.tabView.frame.origin.y - self.tabView.frame.size.height;
    self.infoView.frame = infoFrame;
    self.infoView.backgroundColor = [UIColor redColor];
}

- (JMTabView *)tabView {
    if (!_tabView) {
        _tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 60.0)];
        [_tabView setBackgroundLayer:nil];
    }
    return _tabView;
}

- (UIView *)infoView {
    if (_infoView) {
        _infoView = [[UITableView alloc] init];
    }
    return _infoView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.socialActivity.comments count];
}

#pragma mark - JMTabViewDelegate implementation
- (void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    
}

@end

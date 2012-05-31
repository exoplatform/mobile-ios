//
//  ActivityLikersViewController.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 5/23/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import "ActivityLikersViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "AvatarView.h"
#import "defines.h"
#import "SocialActivityDetailsProxy.h"

#define kLikersViewTopBottomMargin 10.0
#define kLikersViewLeftRightMargin 10.0
#define kLikersViewPadding 10.0
#define kLikersViewColumns 3


@interface ActivityLikersViewController ()

@property (nonatomic, retain) NSMutableArray *avatarViews;
@property (nonatomic, retain) NSMutableArray *nameLabels;

- (void)updateLikerViews;
- (AvatarView *)newAvatarView;
- (UILabel *)newNameLabel;
- (void)updateListOfLikers;

@end

@implementation ActivityLikersViewController 

@synthesize socialActivity = _socialActivity;
@synthesize avatarViews = _avatarViews;
@synthesize nameLabels = _nameLabels;
@synthesize likersHeader = _likersHeader;

- (void)dealloc {
    [_socialActivity release];
    [_avatarViews release];
    [_nameLabels release];
    [_likersHeader release];
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        _avatarViews = [[NSMutableArray alloc] init];
        _nameLabels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

//- (void)loadView
//{
//    UIScrollView *view = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.view = [view autorelease];
//    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = EXO_BACKGROUND_COLOR;
    scrollView.scrollEnabled = YES;
    
    self.view = [scrollView autorelease];
    
    [self.view addSubview:self.likersHeader];
    [self updateLikerViews];
    [self updateListOfLikers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - getters & setters

- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [_socialActivity release];
    _socialActivity = [socialActivity retain];
    
    [self updateLikerViews];
}

- (UILabel *)likersHeader {
    if (_likersHeader) {
        _likersHeader = [[UILabel alloc] init];
    }
    return _likersHeader;
}

#pragma mark - liker views
- (void)updateLikerViews {
    // remove avatar views
    for (UIView *view in _avatarViews) {
        [view removeFromSuperview];
    }
    [_avatarViews removeAllObjects];
    // remove name labels
    for (UIView *label in _nameLabels) {
        [label removeFromSuperview];
    }
    [_nameLabels removeAllObjects];
    // **********
    
    CGRect viewBounds = self.view.bounds;
    // calculate avatar width 
    float avatarWidth = (viewBounds.size.width - kLikersViewLeftRightMargin * 2 - kLikersViewPadding * (kLikersViewColumns - 1)) / kLikersViewColumns;
    avatarWidth = ceilf(avatarWidth);
    int columnCount = 0;
    float columnY = kLikersViewTopBottomMargin;
    
    for (SocialUserProfile *user in self.socialActivity.likedByIdentities) {
        EGOImageView *avatarView = [self newAvatarView];
        avatarView.imageURL = [NSURL URLWithString:user.avatarUrl];
        // update position of avatar
        avatarView.frame = CGRectMake(kLikersViewLeftRightMargin + (avatarWidth + kLikersViewPadding) * columnCount, columnY, avatarWidth, avatarWidth);
        
        UILabel *label = [self newNameLabel];
        label.text = user.fullName;
        // update position of the avatar 
        CGSize labelSize = [label.text sizeWithFont:label.font];
        label.frame = CGRectMake(avatarView.frame.origin.x, avatarView.frame.origin.y + avatarWidth, avatarWidth, labelSize.height);
        
        columnCount++;
        
        if (columnCount == kLikersViewColumns) {
            columnCount = 0;
            columnY = label.frame.origin.y + label.frame.size.height + kLikersViewPadding;
        }
        
        [self.avatarViews addObject:avatarView];
        [self.view addSubview:avatarView];

        [self.nameLabels addObject:label];
        [self.view addSubview:label];
    }
    // update scrollview's content size
    UILabel *lastLabel = [self.nameLabels lastObject];
    float contentHeight = lastLabel ? (lastLabel.frame.origin.y + lastLabel.frame.size.height + kLikersViewTopBottomMargin) : 0.0;
    [((UIScrollView *)self.view) setContentSize:CGSizeMake(viewBounds.size.width, contentHeight)];
}

- (AvatarView *)newAvatarView {
    AvatarView *imageView = [[[AvatarView alloc] init] autorelease];
    //Add the CornerRadius
    [[imageView layer] setCornerRadius:6.0];
    [[imageView layer] setMasksToBounds:YES];
    
    //Add the border
    [[imageView layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    return imageView;
}

- (UILabel *)newNameLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:11.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:58.0/255 green:118.0/255 blue:178.0/255 alpha:1];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    return [label autorelease];
}

- (void)updateListOfLikers {
    SocialActivityDetailsProxy *activityProxy = [[SocialActivityDetailsProxy alloc] init];
    activityProxy.delegate = self;
    [activityProxy getLikers:self.socialActivity.activityId];
}

#pragma mark - SocialProxyDelegate 
- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    SocialActivityDetailsProxy *activityProxy = (SocialActivityDetailsProxy *)proxy;
    self.socialActivity.likedByIdentities = activityProxy.socialActivityDetails.likedByIdentities;
    [self updateLikerViews];
}

- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error {
    
}

@end

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

#import "ActivityLikersViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "AvatarView.h"
#import "defines.h"
#import "SocialActivityDetailsProxy.h"
#import "EmptyView.h"

#define kLikersViewTopBottomMargin 10.0
#define kLikersViewLeftRightMargin 10.0
#define kLikersViewPadding 10.0
#define kLikersViewColumns (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4 : 3)
#define kNoLikerViewTag 100


@interface ActivityLikersViewController ()

@property (nonatomic, retain) NSMutableArray *avatarViews;
@property (nonatomic, retain) NSMutableArray *nameLabels;
@property (nonatomic, retain) EmptyView *noLikerView;
@property (nonatomic, retain) SocialActivityDetailsProxy *activityDetailsProxy;

- (AvatarView *)newAvatarView;
- (UILabel *)newNameLabel;

@end

@implementation ActivityLikersViewController 

@synthesize socialActivity = _socialActivity;
@synthesize avatarViews = _avatarViews;
@synthesize nameLabels = _nameLabels;
@synthesize likersHeader = _likersHeader;
@synthesize noLikerView = _noLikerView;
@synthesize activityDetailsProxy = _activityDetailsProxy;

- (void)dealloc {
    [_activityDetailsProxy release];
    [_socialActivity release];
    [_avatarViews release];
    [_nameLabels release];
    [_likersHeader release];
    [_noLikerView release];
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
    self.noLikerView = nil;
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)loadView {
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = EXO_BACKGROUND_COLOR;
    scrollView.scrollEnabled = YES;
    
    self.view = [scrollView autorelease];
    
    [self.view addSubview:self.likersHeader];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLikerViews];
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

- (EmptyView *)noLikerView {
    if (!_noLikerView) {
        _noLikerView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoActivities" andContent:Localize(@"NoOneLikeThis")];
        [_noLikerView setTag:kNoLikerViewTag];
    }
    return _noLikerView;
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
    
    [[self.view viewWithTag:kNoLikerViewTag] removeFromSuperview];
    self.noLikerView = nil;
    // **********
    
    CGRect viewBounds = self.view.bounds;
    if (self.socialActivity.totalNumberOfLikes == 0) {     
        [self.view addSubview:self.noLikerView];
        return;
    }
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
    self.activityDetailsProxy = [[[SocialActivityDetailsProxy alloc] init] autorelease];
    self.activityDetailsProxy.delegate = self;
    [self.activityDetailsProxy getLikers:self.socialActivity.activityId];
}

#pragma mark - SocialProxyDelegate 
- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    SocialActivityDetailsProxy *activityProxy = (SocialActivityDetailsProxy *)proxy;
    self.socialActivity.likedByIdentities = activityProxy.socialActivityDetails.likedByIdentities;
    [self updateLikerViews];
    self.activityDetailsProxy = nil;
}

- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error {
    
}

@end

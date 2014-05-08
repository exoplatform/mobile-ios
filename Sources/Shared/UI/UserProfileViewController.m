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

#import "UserProfileViewController.h"
#import "SocialUserProfileProxy.h"
#import "SocialRestConfiguration.h"
#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>

@interface UserProfileView : UIView 

@end

@implementation UserProfileView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = [UIColor colorWithRed:40./255 green:40./255 blue:40./255 alpha:1].CGColor;
    CGColorRef endColor = [UIColor colorWithRed:20./255 green:20./255 blue:20./255 alpha:1].CGColor;

    // draw gradient 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id) startColor, (id) endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}
@end

@interface UserProfileViewController () <SocialProxyDelegate>

@property (nonatomic, retain) SocialUserProfileProxy *userProfileProxy;


@end

#define kUserProfileViewTopBottomMargin 10.0
#define kUserProfileViewLefRightMargin 10.0
#define kUserProfileViewLefRightPadding 20.0

@implementation UserProfileViewController

@synthesize username = _username;
@synthesize userProfile = _userProfile;
@synthesize userProfileProxy = _userProfileProxy;
@synthesize avatarView = _avatarView;
@synthesize fullNameLabel = _fullNameLabel;

- (void)dealloc {
    [_username release];
    [_userProfile release];
    [_avatarView release];
    [_fullNameLabel release];
    [_userProfileProxy release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        _viewFrame = frame;
    }
    return self;
}

- (void)loadView {
    self.view = [[[UserProfileView alloc] initWithFrame:_viewFrame] autorelease];
    self.view.layer.borderWidth = 1.0;
    self.view.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeFeatureSeparator.png"]].CGColor;
    CGRect viewBounds = self.view.bounds;
    float avatarHeight = viewBounds.size.height - kUserProfileViewTopBottomMargin * 2;
    self.avatarView = [[[AvatarView alloc] init] autorelease];
    self.avatarView.frame = CGRectMake(kUserProfileViewLefRightMargin, kUserProfileViewTopBottomMargin, avatarHeight, avatarHeight);
    [self.view addSubview:self.avatarView];
    
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    float labelHeight = [@"A" sizeWithFont:font].height;
    CGRect labelFrame = CGRectZero;
    labelFrame.origin.x = _avatarView.frame.origin.x + _avatarView.frame.size.width + kUserProfileViewLefRightPadding;
    labelFrame.origin.y = (viewBounds.size.height - labelHeight) / 2;
    labelFrame.size.width = viewBounds.size.width - labelFrame.origin.x - kUserProfileViewLefRightMargin;
    labelFrame.size.height = labelHeight;
    self.fullNameLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    self.fullNameLabel.font = font;
    self.fullNameLabel.textColor = [UIColor whiteColor];
    self.fullNameLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.fullNameLabel.backgroundColor = [UIColor clearColor];
    self.fullNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.fullNameLabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - proxy management 
- (void)proxyDidFinishLoading:(SocialProxy *)proxy {
    self.userProfile = self.userProfileProxy.userProfile;
    [self.avatarView setImageURL:[NSURL URLWithString:self.userProfile.avatarUrl]];
    self.fullNameLabel.text = self.userProfile.fullName;
    self.userProfileProxy = nil;
}

- (void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error {
    LogDebug(@"Couldn't get user profile of user %@ due to %@", self.username, error);
}

#pragma mark - User profile management 
- (void)startUpdateCurrentUserProfile {
    self.userProfileProxy = [[[SocialUserProfileProxy alloc] init] autorelease];
    self.userProfileProxy.delegate = self;
    [self.userProfileProxy getUserProfileFromUsername:self.username];
}

@end

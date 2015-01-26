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
#import "ApplicationPreferencesManager.h"
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
@synthesize accountNameLabel = _accountNameLabel;

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
    
    // Calculate the height of each label
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    float labelHeight = [@"A" sizeWithFont:font].height;
    // Create user's full name label
    CGRect fullnameFrame = CGRectZero;
    fullnameFrame.origin.x = _avatarView.frame.origin.x + _avatarView.frame.size.width + kUserProfileViewLefRightPadding;
    fullnameFrame.origin.y = (viewBounds.size.height / 2) - labelHeight;
    fullnameFrame.size.width = viewBounds.size.width - fullnameFrame.origin.x - kUserProfileViewLefRightMargin;
    fullnameFrame.size.height = labelHeight;
    self.fullNameLabel = [[[UILabel alloc] initWithFrame:fullnameFrame] autorelease];
    self.fullNameLabel.font = font;
    self.fullNameLabel.textColor = [UIColor whiteColor];
    self.fullNameLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.fullNameLabel.backgroundColor = [UIColor clearColor];
    self.fullNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.fullNameLabel];
    // Create account name label and put it just under the full name label
    CGRect accountNameFrame = CGRectZero;
    accountNameFrame.origin.x = fullnameFrame.origin.x;
    accountNameFrame.origin.y = fullnameFrame.origin.y + labelHeight;
    accountNameFrame.size.height = fullnameFrame.size.height;
    accountNameFrame.size.width = fullnameFrame.size.width;
    self.accountNameLabel = [[[UILabel alloc] initWithFrame:accountNameFrame] autorelease];
    self.accountNameLabel.font = font;
    self.accountNameLabel.textColor = [UIColor whiteColor];
    self.accountNameLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.accountNameLabel.backgroundColor = [UIColor clearColor];
    self.accountNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.accountNameLabel];
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
    self.accountNameLabel.text = [NSString stringWithFormat:@"(%@)", [[ApplicationPreferencesManager sharedInstance] getSelectedAccount].accountName];
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

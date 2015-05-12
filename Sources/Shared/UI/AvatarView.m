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

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialUserProfile.h"

@interface InnerShadowView : UIView

@end

@implementation InnerShadowView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = self.layer.cornerRadius;
    float shadowOffset = 20.0;
    CGPathRef visiblePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;

    CGRect shadowRect = CGRectInset(rect, -shadowOffset, -shadowOffset);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, shadowRect);
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, visiblePath); 
    CGContextClip(context);
    
    UIColor * shadowColor = [UIColor blackColor];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 8.0f, [shadowColor CGColor]);
    [[UIColor whiteColor] setFill];   
    
    CGContextSaveGState(context);   

    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    CGPathRelease(path);    
    CGContextRestoreGState(context);
}

@end

@interface AvatarView ()

- (void)configureAvatar;

@end

@implementation AvatarView

@synthesize userProfile = _userProfile;

- (void)dealloc {
    [_userProfile release];
    [super dealloc];
}

- (instancetype)init {
    if (self = [super init]) {
        [self configureAvatar];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureAvatar];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self configureAvatar];
    }
    return self;
}

- (void)setUserProfile:(SocialUserProfile *)userProfile {
    [userProfile retain];
    [_userProfile release];
    _userProfile = userProfile;
    self.imageURL = [NSURL URLWithString:_userProfile.avatarUrl];
}

- (void)configureAvatar {
    //Add the CornerRadius
    [[self layer] setCornerRadius:6.0];
    self.clipsToBounds = YES;
    
    //Add the border
    [[self layer] setBorderColor:[UIColor whiteColor].CGColor];
    CGFloat borderWidth = 1.0;
    [self.layer setBorderWidth:borderWidth];
    self.placeholderImage = [UIImage imageNamed:@"default-avatar"];
    
    //Add the inner shadow
    InnerShadowView *innerShadowView = [[InnerShadowView alloc] initWithFrame:self.bounds];
    innerShadowView.backgroundColor = [UIColor clearColor];
    innerShadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:innerShadowView];
    [innerShadowView release];
}

- (void)imageLoaderDidLoad:(NSNotification *)notification {
    [super imageLoaderDidLoad:notification];
    // Animate display of avatar
    self.alpha = 0.3;
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.alpha = 1.0;
    }];
}

@end

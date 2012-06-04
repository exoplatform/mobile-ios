//
//  AvatarView.m
//  eXo Platform
//
//  Created by exoplatform on 5/31/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import "AvatarView.h"
#import <QuartzCore/QuartzCore.h>

@interface AvatarView ()

@property (nonatomic, retain) CALayer *innerShadowLayer;
- (void)configureAvatar;

@end

@implementation AvatarView

@synthesize innerShadowLayer = _innerShadowLayer;

- (void)dealloc {
    [_innerShadowLayer release];
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        [self configureAvatar];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureAvatar];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        [self configureAvatar];
    }
    return self;
}

- (void)configureAvatar {
    //Add the CornerRadius
    [[self layer] setCornerRadius:5.5];
    [[self layer] setMasksToBounds:YES];
    
    //Add the border
    [[self layer] setBorderColor:[UIColor whiteColor].CGColor];
    CGFloat borderWidth = 1.0;
    [self.layer setBorderWidth:borderWidth];
    self.placeholderImage = [UIImage imageNamed:@"default-avatar"];
    
    //Add the inner shadow
    self.innerShadowLayer = [CALayer layer];
    self.innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow"].CGImage;
    self.innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    self.innerShadowLayer.frame = CGRectMake(borderWidth, borderWidth, self.bounds.size.width - 2 * borderWidth, self.bounds.size.height - 2 * borderWidth);
    [self.layer addSublayer:self.innerShadowLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float borderWidth = self.layer.borderWidth;
    self.innerShadowLayer.frame = CGRectMake(borderWidth, borderWidth, self.bounds.size.width - 2 * borderWidth, self.bounds.size.height - 2 * borderWidth);
}

@end

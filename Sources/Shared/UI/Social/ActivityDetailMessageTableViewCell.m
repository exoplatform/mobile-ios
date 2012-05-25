//
//  ActivityDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailMessageTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialActivity.h"
#import "defines.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

@implementation ActivityDetailMessageTableViewCell

@synthesize socialActivity = _socialActivity;
@synthesize lbMessage=_lbMessage, lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize webViewForContent = _webViewForContent;
@synthesize webViewComment =  _webViewComment;

@synthesize imgType = _imgType;
@synthesize imgvAttach = _imgvAttach;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [_imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
}

- (void)dealloc
{
    
    self.lbMessage = nil;
    self.lbDate = nil;
    self.lbName = nil;
    self.webViewForContent = nil;
    self.imgvAvatar = nil;
    [super dealloc];
}

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    
}

#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {
    //Add the CornerRadius
    [[_imgvAvatar layer] setCornerRadius:6.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    
    //Add the border
    [[_imgvAvatar layer] setBorderColor:[UIColor colorWithRed:113./255 green:113./255 blue:113./255 alpha:1.].CGColor];
    CGFloat borderWidth = 1.0;
    [[_imgvAvatar layer] setBorderWidth:borderWidth];
    _imgvAvatar.placeholderImage = [UIImage imageNamed:@"default-avatar"];
    
    //Add the inner shadow
    /*CALayer *innerShadowLayer = [CALayer layer];
    innerShadowLayer.contents = (id)[UIImage imageNamed: @"ActivityAvatarShadow.png"].CGImage;
    innerShadowLayer.contentsCenter = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    innerShadowLayer.frame = CGRectMake(borderWidth,borderWidth,_imgvAvatar.frame.size.width-2*borderWidth, _imgvAvatar.frame.size.height-2*borderWidth);
    [_imgvAvatar.layer addSublayer:innerShadowLayer];*/
}


- (void)configureFonts {
    
}


- (void)configureCell {
    [self customizeAvatarDecorations];
    
    
    //_webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    [[_webViewForContent.subviews objectAtIndex:0] setScrollEnabled:NO];
    [_webViewForContent setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewForContent subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    scrollView.scrollsToTop = YES;
    
    [_webViewForContent setOpaque:NO];
}


- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail
{
    self.socialActivity = socialActivityDetail;
    switch (self.socialActivity.activityType) {
        case ACTIVITY_DEFAULT:
        {
            NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",[socialActivityDetail.title copy]?[socialActivityDetail.title copy]:@""];
            [_webViewForContent loadHTMLString:htmlStr ? htmlStr :@""
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            NSLog(@"title :%@", socialActivityDetail.title);
            _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
            //Set the position of lbMessage
            CGRect tmpFrame = _webViewForContent.frame;
            tmpFrame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height + 5;
            _webViewForContent.frame = tmpFrame;
        }
            break;
    }
    
    _lbMessage.text = @"";
    
    _lbDate.text = [socialActivityDetail.postedTimeInWords copy];
    _imgvAvatar.imageURL = [NSURL URLWithString:socialActivityDetail.posterIdentity.avatarUrl];
    
}



@end

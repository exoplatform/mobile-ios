//
//  ActivityDetailCommentTableViewCell.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailCommentTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialComment.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"

@implementation ActivityDetailCommentTableViewCell

@synthesize lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize imgvMessageBg=_imgvMessageBg;
@synthesize imgvCellBg = _imgvCellBg;
@synthesize webViewForContent = _webViewForContent;
@synthesize width;

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
    
    self.webViewForContent = nil;
    self.lbDate = nil;
    self.lbName = nil;
    self.imgvAvatar = nil;
    
    self.imgvMessageBg = nil;
    self.imgvCellBg = nil;
    
    [super dealloc];
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
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    
    
    [[_webViewForContent.subviews objectAtIndex:0] setScrollEnabled:NO];
    [_webViewForContent setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[_webViewForContent subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    [scrollView flashScrollIndicators];
    scrollView.scrollsToTop = YES;
    
    [_webViewForContent setOpaque:NO];
}


- (void)setSocialComment:(SocialComment*)socialComment
{
    NSString* tmp = socialComment.userProfile.avatarUrl;
    NSString* domainName = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] copy];
    NSRange rang = [tmp rangeOfString:domainName];
    if (rang.length == 0) 
    {
        tmp = [NSString stringWithFormat:@"%@%@",domainName,tmp];
    }
    
    
    _imgvAvatar.imageURL = [NSURL URLWithString:tmp];  
    _lbName.text = [socialComment.userProfile.fullName copy];
    
    
    NSString *text = [[socialComment.text stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",text?text:@""];
    
    [_webViewForContent loadHTMLString:htmlStr ? htmlStr :@""
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    //Set the position of web
    CGSize theSize = [text sizeWithFont:kFontForTitle 
                      constrainedToSize:CGSizeMake((width > 320)?WIDTH_FOR_CONTENT_IPAD:WIDTH_FOR_CONTENT_IPHONE, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    _webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height;
    tmpFrame.size.height = theSize.height + 10;
    _webViewForContent.frame = tmpFrame;
    
    _lbDate.text = [socialComment.postedTimeInWords copy];
}


@end
 

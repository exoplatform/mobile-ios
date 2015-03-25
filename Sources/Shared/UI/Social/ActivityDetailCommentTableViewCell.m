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
@synthesize extraDelegateForWebView;
@synthesize width;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    self.webViewForContent.delegate = nil;
    [self.webViewForContent stopLoading];
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

}


- (void)configureFonts {
    
}


- (void)configureCell {
    
    [self customizeAvatarDecorations];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    self.backgroundColor = [UIColor clearColor];
    
    [(_webViewForContent.subviews)[0] setScrollEnabled:NO];
    [_webViewForContent setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[_webViewForContent subviews][0];
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
    
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body>%@</body></html>",socialComment.text ? socialComment.text : @""];
    
    [_webViewForContent loadHTMLString:htmlStr ? htmlStr :@""
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    
    
    _lbDate.text = socialComment.postedTimeInWords;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    frame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height;
    frame.size.height += 10.;
    webView.frame = frame;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([self.extraDelegateForWebView respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.extraDelegateForWebView webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return NO;
    }
}

@end
 

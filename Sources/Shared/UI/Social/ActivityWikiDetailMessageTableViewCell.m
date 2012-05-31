//
//  ActivityWikiDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityWikiDetailMessageTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"

@implementation ActivityWikiDetailMessageTableViewCell

@synthesize htmlMessage = _htmlMessage;
@synthesize htmlName = _htmlName;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    _htmlName.textColor = [UIColor grayColor];
    [self.contentView addSubview:_htmlName];
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.textColor = [UIColor grayColor];
    [self.contentView addSubview:_htmlMessage];
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    NSString *htmlStr = nil;
    NSDictionary *_templateParams = self.socialActivity.templateParams;
    switch (self.socialActivity.activityType) {
        case ACTIVITY_WIKI_ADD_PAGE:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"CreateWiki")];         
        }
            break;
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"EditWiki")];
        }
            break;
    }
    // Name
    _htmlName.html = htmlStr;
    [_htmlName sizeToFit];
    
    CGRect tmpFrame = _htmlName.frame;
    tmpFrame.origin.y = 5;
    _htmlName.frame = tmpFrame;
    
    // Title
    CGSize theSize = [[[_templateParams valueForKey:@"page_name"] stringByConvertingHTMLToPlainText] sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#F5F5F5;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><a href=\"%@\">%@</a></body></html>", [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]]
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]];
    _webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    //Set the position of web
    tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y + 5;
    tmpFrame.size.height = theSize.height + 10;
    _webViewForContent.frame = tmpFrame;
    
    // Content
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
    _htmlMessage.frame = tmpFrame;
    
    NSLog(@"%@", [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText]);
    _htmlMessage.html = [NSString stringWithFormat:@"<p>%@</p>", [[[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
    [_htmlMessage sizeToFit];
    [_webViewForContent sizeToFit];
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end

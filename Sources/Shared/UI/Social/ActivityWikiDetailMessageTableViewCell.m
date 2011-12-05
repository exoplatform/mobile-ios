//
//  ActivityWikiDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityWikiDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
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
    _htmlName.backgroundColor = [UIColor whiteColor];
    //_htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;// |UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:_htmlName];
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.textColor = [UIColor grayColor];
    _htmlMessage.backgroundColor = [UIColor whiteColor];
    //_htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;// |UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:_htmlMessage];
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    
    NSString *textWithoutHtml = @"";
    NSString *htmlStr = nil;
    switch (_activityType) {
        case ACTIVITY_WIKI_ADD_PAGE:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"CreateWiki")];         
            
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"CreateWiki"),[_templateParams valueForKey:@"page_name"]];
        }
            break;
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, Localize(@"EditWiki")];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EditWiki"),[_templateParams valueForKey:@"page_name"]];
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
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a href=\"%@\">%@</a></body></html>", [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]]
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]];
     
    _webViewForContent.contentMode = UIViewContentModeScaleAspectFit;
    //Set the position of web
    tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y ;
    tmpFrame.size.height = theSize.height;
    _webViewForContent.frame = tmpFrame;
    [_webViewForContent sizeToFit];
    // Content
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y;
    _htmlMessage.frame = tmpFrame;
    
    NSLog(@"%@", [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText]);
    _htmlMessage.html = [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    [_htmlMessage sizeToFit];
    
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end

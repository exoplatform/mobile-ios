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


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 0, WIDTH_FOR_CONTENT_IPHONE - 10, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
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

    switch (_activityType) {
        case ACTIVITY_WIKI_ADD_PAGE:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"CreateWiki"), [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"CreateWiki"),[_templateParams valueForKey:@"page_name"]];
        }
            break;
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;} a{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><a>%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, Localize(@"EditWiki"), [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
            textWithoutHtml = [NSString stringWithFormat:@"%@ %@ %@", socialActivityDetail.posterIdentity.fullName, Localize(@"EditWiki"),[_templateParams valueForKey:@"page_name"]];
        }
            break;
    }
    //Set the position of web
    CGRect tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = 2;
    _webViewForContent.frame = tmpFrame;
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = theSize.height + 20;
    _htmlMessage.frame = tmpFrame;
    
    NSLog(@"%@", [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText]);
    //_lbMessage.text = [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    _htmlMessage.text = [_templateParams valueForKey:@"page_exceprt"];
    [_htmlMessage sizeToFit];
    
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end

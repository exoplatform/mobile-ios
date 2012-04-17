//
//  ActivityAnswerDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnswerDetailMessageTableViewCell.h"

#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"

@implementation ActivityAnswerDetailMessageTableViewCell

@synthesize htmlMessage = _htmlMessage;
@synthesize htmlTitle = _htmlTitle;
@synthesize htmlName = _htmlName;

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth{
    CGRect tmpFrame = CGRectZero;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(67, 0, WIDTH_FOR_CONTENT_IPHONE , 21);
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
    
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    //NSString *textWithoutHtml = @"";
    NSString *htmlStr = nil;
    switch (_activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Asked")];
        }
            break;
        case ACTIVITY_ANSWER_QUESTION:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"Answered")];
        }
            break;
        case ACTIVITY_ANSWER_UPDATE_QUESTION:{
            htmlStr = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityDetail.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",Localize(@"UpdateQuestion")]; 
        }
            break;
    }
    // Name
    _htmlName.html = htmlStr;
    [_htmlName sizeToFit];
    
    CGRect tmpFrame = _htmlName.frame;
    tmpFrame.origin.y = 5;
    _htmlName.frame = tmpFrame;
    
    //Set the position of web
    //Title
    [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><a href=\"%@\">%@</a></html>",  [_templateParams valueForKey:@"Link"], [[_templateParams valueForKey:@"Name"] stringByConvertingHTMLToPlainText]]
                               baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
     ];
    CGSize theSize = [[[_templateParams valueForKey:@"Name"] stringByConvertingHTMLToPlainText] sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y;
    tmpFrame.size.height = theSize.height + 5;
    _webViewForContent.frame = tmpFrame;
    
    
    //content
    _htmlMessage.html = [[socialActivityDetail.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    theSize = [[socialActivityDetail.body stringByConvertingHTMLToPlainText] sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                                                                        lineBreakMode:UILineBreakModeWordWrap];
    tmpFrame = _htmlMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + 5;
    tmpFrame.size.height = theSize.height + 5;
    _htmlMessage.frame = tmpFrame;
    [_htmlMessage sizeToFit];
    
    [_webViewForContent sizeToFit];
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end
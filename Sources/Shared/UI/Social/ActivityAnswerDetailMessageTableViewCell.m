//
//  ActivityAnswerDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnswerDetailMessageTableViewCell.h"

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
    [self.contentView addSubview:_htmlName];
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.backgroundColor = [UIColor clearColor];
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.textColor = [UIColor grayColor];
    [self.contentView addSubview:_htmlMessage];
}

- (void)updateSizeToFitSubViews {
    CGRect frame = _htmlMessage.frame;
    frame.origin.y = _webViewForContent.frame.size.height + _webViewForContent.frame.origin.y + kPadding;
    _htmlMessage.frame = frame;
    
    frame = self.frame;
    frame.size.height = _htmlMessage.frame.origin.y + _htmlMessage.frame.size.height + kPadding + self.lbDate.frame.size.height + kBottomMargin;
    self.frame = frame;
}

- (void)setSocialActivityDetail:(SocialActivity *)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    
    NSString *type = [socialActivityDetail.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityDetail.activityStream valueForKey:@"fullName"];
    }
    
    //NSString *textWithoutHtml = @"";
    NSString *htmlStr = nil;
    NSDictionary *_templateParams = self.socialActivity.templateParams;
    switch (self.socialActivity.activityType) {
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
    
    float plfVersion = [[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
    // in plf 4, there is no "Name" in template params, we take the title of activity instead.
    if(plfVersion >= 4.0) {
        [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><a href=\"%@\">%@</a></html>",  [_templateParams valueForKey:@"Link"], [socialActivityDetail.title stringByConvertingHTMLToPlainText]]
                                   baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
         ];
    } else {
        [_webViewForContent loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #115EAD; text-decoration: none; font-weight: bold;}</style> </head><body><a href=\"%@\">%@</a></html>",  [_templateParams valueForKey:@"Link"], [[_templateParams valueForKey:@"Name" ] stringByConvertingHTMLToPlainText]] baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
         ];
    }
    
    CGSize theSize = [[[_templateParams valueForKey:@"Name"] stringByConvertingHTMLToPlainText] sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                     lineBreakMode:UILineBreakModeWordWrap];
    
    tmpFrame = _webViewForContent.frame;
    tmpFrame.origin.y = _htmlName.frame.size.height + _htmlName.frame.origin.y;
    tmpFrame.size.height = theSize.height + 5;
    _webViewForContent.frame = tmpFrame;
    
    _htmlMessage.html = [[socialActivityDetail.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    [_htmlMessage sizeToFit];
    
    [_webViewForContent sizeToFit];
    [self updateSizeToFitSubViews];
}

- (void)dealloc {
    [_htmlMessage release];
    _htmlMessage = nil;
    
    [super dealloc];
}

@end
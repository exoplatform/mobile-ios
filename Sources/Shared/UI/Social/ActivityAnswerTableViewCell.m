//
//  ActivityAnswerTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityAnswerTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityAnswerTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize htmlName = _htmlName;
@synthesize htmlTitle = _htmlTitle;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _htmlTitle.textColor = [UIColor grayColor];
        _htmlTitle.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _htmlTitle.textColor = [UIColor darkGrayColor];
        _htmlTitle.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
    }
    
    [super configureFonts:highlighted];
}


- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
    }
    
    //Use an html styled label to display informations about the author of the wiki page
    _htmlName = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlName.userInteractionEnabled = NO;
    _htmlName.backgroundColor = [UIColor clearColor];
    _htmlName.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_htmlName];
    
    _htmlTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlTitle.userInteractionEnabled = NO;
    _htmlTitle.backgroundColor = [UIColor clearColor];
    _htmlTitle.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_htmlTitle];
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbMessage];
}




- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    switch (socialActivityStream.activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"Asked")];
            break;
        case ACTIVITY_ANSWER_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"Answered")];
            break; 
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdateQuestion")];
            break; 
        default:
            break;
    }
    
    [_htmlName sizeToFit];
    
    //Set the position of Title
    _htmlTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[socialActivityStream.templateParams valueForKey:@"Name"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
    
    [_htmlTitle sizeToFit];
    
    _lbMessage.html = [[socialActivityStream.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    [_lbMessage sizeToFit];
    
    
    // for title
    CGRect tmpFrame = _htmlTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    double heigthForTTLabel = [[[self htmlTitle] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    tmpFrame.size.height = heigthForTTLabel;
    _htmlTitle.frame = tmpFrame;
    
    
    //Set the position of lbMessage
    tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _htmlTitle.frame.origin.y + _htmlTitle.frame.size.height + 5;
    heigthForTTLabel = [[[self lbMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    tmpFrame.size.height = heigthForTTLabel;
    _lbMessage.frame = tmpFrame;
    
}


- (void)dealloc {
    
    _lbMessage = nil;
    
    [_htmlName release];
    _htmlName = nil;
    
    [super dealloc];
}


@end

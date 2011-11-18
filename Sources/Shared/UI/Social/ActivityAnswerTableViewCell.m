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

@implementation ActivityAnswerTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize htmlName = _htmlName;



- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
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
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbMessage];
}




- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    switch (socialActivityStream.activityType) {
        case ACTIVITY_ANSWER_ADD_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"Asked"), [socialActivityStream.templateParams valueForKey:@"Name"]];
            break;
        case ACTIVITY_ANSWER_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"Answered"), [socialActivityStream.templateParams valueForKey:@"Name"]];
            break; 
        case ACTIVITY_ANSWER_UPDATE_QUESTION:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdateQuestion"), [socialActivityStream.templateParams valueForKey:@"Name"]];
            break; 
        default:
            break;
    }
    
    [_htmlName sizeToFit];
    
    NSLog(@"%@", [socialActivityStream.title stringByConvertingHTMLToPlainText]);
    
    //Set the position of lbMessage
    CGRect tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    _lbMessage.frame = tmpFrame;
    
    _lbMessage.html = [socialActivityStream.title stringByConvertingHTMLToPlainText];
    [_lbMessage sizeToFit];
    
}


- (void)dealloc {
    
    _lbMessage = nil;
    
    [_htmlName release];
    _htmlName = nil;
    
    [super dealloc];
}


@end

//
//  ActivityForumTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityForumTableViewCell.h"
#import "SocialActivityStream.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityForumTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize htmlName = _htmlName;
@synthesize lbTitle = _lbTitle;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
        
        
        _lbTitle.textColor = [UIColor grayColor];
        _lbTitle.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbTitle.textColor = [UIColor darkGrayColor];
        _lbTitle.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
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
    
    //Use an html styled label to display informations about the author of the wiki page
    _lbTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbTitle.userInteractionEnabled = NO;
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbTitle];
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbMessage];
}




- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {

    switch (socialActivityStream.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewPost"), [socialActivityStream.templateParams valueForKey:@"PostName"]];
            _lbTitle.html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [socialActivityStream.templateParams valueForKey:@"PostName"]];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"NewTopic")];
            _lbTitle.html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [socialActivityStream.templateParams valueForKey:@"TopicName"]];
            break; 
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdateTopic")];
            _lbTitle.html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [socialActivityStream.templateParams valueForKey:@"TopicName"]];
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@</a> %@</p>", socialActivityStream.posterUserProfile.fullName, Localize(@"UpdatePost")];
            _lbTitle.html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [socialActivityStream.templateParams valueForKey:@"PostName"]];
            break; 
        default:
            break;
    }
    
    [_htmlName sizeToFit];
    [_lbTitle sizeToFit];
    
    _lbMessage.html = [socialActivityStream.body stringByConvertingHTMLToPlainText];
    [_lbMessage sizeToFit];
    
    NSLog(@"%@", [socialActivityStream.body stringByConvertingHTMLToPlainText]);
    
    //Set the position of Title
    CGRect tmpFrame = _lbTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    tmpFrame.size.width = _htmlName.frame.size.width;
    
    _lbTitle.frame = tmpFrame;
    
    //Set the position of lbMessage
    tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _lbTitle.frame.origin.y + _lbTitle.frame.size.height + 5;
    double heigthForTTLabel = [[[self lbMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT)
        heigthForTTLabel = EXO_MAX_HEIGHT;  // Do not exceed the maximum height for the TTStyledTextLabel.
    // The Text was supposed to clip here when maximum height is set!**
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

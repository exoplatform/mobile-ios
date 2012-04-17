//
//  ActivityWikiTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityWikiTableViewCell.h"
#import "SocialActivityStream.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"

#define MAX_LENGTH 80

@implementation ActivityWikiTableViewCell

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
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", 
                             socialActivityStream.posterUserProfile.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",
                             Localize(@"EditWiki")];
            
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        {
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", 
                              socialActivityStream.posterUserProfile.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"",
                              Localize(@"CreateWiki")];
        }
            
            break; 
        default:
            break;
    }
    [_htmlName sizeToFit];

    _lbTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[socialActivityStream.templateParams valueForKey:@"page_name"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
    [_lbTitle sizeToFit];
    
    _lbMessage.html =  [[[socialActivityStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    [_lbMessage sizeToFit];

    
    //Set the position of Title
    CGRect tmpFrame = _lbTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    tmpFrame.size.width = _htmlName.frame.size.width;
    
    double heigthForTTLabel = [[[self lbTitle] text] height];
    if (heigthForTTLabel > MAX_LENGTH)
        heigthForTTLabel = MAX_LENGTH;  // Do not exceed the maximum height for the TTStyledTextLabel.
    // The Text was supposed to clip here when maximum height is set!**
    tmpFrame.size.height = heigthForTTLabel;
    _lbTitle.frame = tmpFrame;
    
    tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _lbTitle.frame.origin.y + _lbTitle.frame.size.height + 5;
    tmpFrame.size.width = _lbTitle.frame.size.width;
    heigthForTTLabel = [[[self lbMessage] text] height];
    if (heigthForTTLabel > MAX_LENGTH)
        heigthForTTLabel = MAX_LENGTH;  // Do not exceed the maximum height for the TTStyledTextLabel.
    // The Text was supposed to clip here when maximum height is set!**
    tmpFrame.size.height = heigthForTTLabel;
    _lbMessage.frame = tmpFrame;
}



- (void)dealloc {
    
    _lbMessage = nil;
    
    _lbTitle = nil;
    
    [_htmlName release];
    _htmlName = nil;
    
    
    [super dealloc];
}

@end

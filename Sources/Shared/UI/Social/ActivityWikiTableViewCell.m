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



@implementation ActivityWikiTableViewCell

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
        
        
        NSLog(@"Size width:%2f  height:%2f",_htmlName.frame.size.width, _htmlName.frame.size.height);
        
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
        case ACTIVITY_WIKI_MODIFY_PAGE:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", 
                             socialActivityStream.posterUserProfile.fullName, 
                             Localize(@"EditWiki"), 
                             [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
            _htmlName.html = [NSString stringWithFormat:@"<a>%@</a> %@<a> %@</a>", 
                             socialActivityStream.posterUserProfile.fullName, 
                             Localize(@"CreateWiki"), 
                             [socialActivityStream.templateParams valueForKey:@"page_name"]];
            break; 
        default:
            break;
    }
    
    
    NSLog(@"%@ --- Size width:%2f  height:%2f",_htmlName.html,_htmlName.frame.size.width, _htmlName.frame.size.height);

    [_htmlName sizeToFit];
    
    NSLog(@"%@ --- Size width:%2f  height:%2f",_htmlName.html,_htmlName.frame.size.width, _htmlName.frame.size.height);

    
    //Set the position of lbMessage
    CGRect tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    _lbMessage.frame = tmpFrame;
    _lbMessage.html = [[socialActivityStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    
    [_lbMessage sizeToFit];
    
}



- (void)dealloc {
    
    _lbMessage = nil;
    
    [_htmlName release];
    _htmlName = nil;
    
    
    [super dealloc];
}

@end

//
//  ActivityLinkTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkTableViewCell.h"
#import "SocialActivityStream.h"
#import "EGOImageView.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"

@implementation ActivityLinkTableViewCell

@synthesize imgvAttach = _imgvAttach;
@synthesize htmlActivityMessage = _htmlActivityMessage;
@synthesize htmlLinkTitle =  _htmlLinkTitle;
@synthesize htmlName = _htmlName;
@synthesize htmlLinkMessage = _htmlLinkMessage;
@synthesize htmlLinkDescription = _htmlLinkDescription;

- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlLinkDescription.textColor = [UIColor grayColor];
        _htmlLinkDescription.backgroundColor = [UIColor whiteColor];
        
        _htmlLinkTitle.textColor = [UIColor grayColor];
        _htmlLinkTitle.backgroundColor = [UIColor whiteColor];
        
        _htmlLinkMessage.textColor = [UIColor grayColor];
        _htmlLinkMessage.backgroundColor = [UIColor whiteColor];
        
        _htmlActivityMessage.textColor = [UIColor grayColor];
        _htmlActivityMessage.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlLinkDescription.textColor = [UIColor darkGrayColor];
        _htmlLinkDescription.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _htmlLinkTitle.textColor = [UIColor darkGrayColor];
        _htmlLinkTitle.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _htmlLinkMessage.textColor = [UIColor darkGrayColor];
        _htmlLinkMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _htmlActivityMessage.textColor = [UIColor darkGrayColor];
        _htmlActivityMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
    }
    
    [super configureFonts:highlighted];
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
    }

    _htmlActivityMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlActivityMessage.userInteractionEnabled = NO;
    _htmlActivityMessage.backgroundColor = [UIColor clearColor];
    _htmlActivityMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlActivityMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlActivityMessage];
    
    _htmlLinkTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlLinkTitle.userInteractionEnabled = NO;
    _htmlLinkTitle.backgroundColor = [UIColor clearColor];
    _htmlLinkTitle.font = [UIFont systemFontOfSize:13.0];
    _htmlLinkTitle.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlLinkTitle];
    
    
    _htmlLinkDescription = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlLinkDescription.userInteractionEnabled = NO;
    _htmlLinkDescription.backgroundColor = [UIColor clearColor];
    _htmlLinkDescription.font = [UIFont systemFontOfSize:13.0];
    _htmlLinkDescription.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlLinkDescription];
    
    _htmlLinkMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlLinkMessage.userInteractionEnabled = NO;
    _htmlLinkMessage.backgroundColor = [UIColor clearColor];
    _htmlLinkMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlLinkMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlLinkMessage];
        
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
//    _lbName.text = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterUserProfile.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterUserProfile.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    CGSize theSize = [title sizeWithFont:kFontForTitle constrainedToSize:CGSizeMake((width > 320)?WIDTH_FOR_CONTENT_IPAD:WIDTH_FOR_CONTENT_IPHONE, CGFLOAT_MAX) 
                           lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = _lbName.frame;
    frame.size.height = theSize.height;
    _lbName.frame = frame;
    
    _lbName.text = title;

    // Activity Message
    _htmlActivityMessage.html = [[[socialActivityStream.templateParams valueForKey:@"comment"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    //SLM : Bug fix
    //When _htmlActivityMessage is empty, _htmlActivityMessage's frame is set to width:0 in sizeToFit
    //When the the view is recycle, the reuse will keep the width to 0
    // so _htmlActivityMessage will not be correctly displayed
    if (![(NSString*)[socialActivityStream.templateParams valueForKey:@"comment"] isEqualToString:@""]) {
        [_htmlActivityMessage sizeToFit];
    } else {
        CGRect rect = _htmlActivityMessage.frame;
        rect.size.height = 0;
        _htmlActivityMessage.frame = rect;
    }
    
    // Link Title
    _htmlLinkTitle.html = [NSString stringWithFormat:@"<a>%@</a>", [[[socialActivityStream.templateParams valueForKey:@"title"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML]];
     
    
    // Link Message
    _htmlLinkDescription.html = [[[socialActivityStream.templateParams valueForKey:@"description"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    if (![(NSString*)[socialActivityStream.templateParams valueForKey:@"description"] isEqualToString:@""]) {
        [_htmlLinkDescription sizeToFit];
    } else {
        CGRect rect = _htmlLinkDescription.frame;
        rect.size.height = 0;
        _htmlLinkDescription.frame = rect;
    }
    
    NSLog(@"%@", NSStringFromCGRect(_htmlLinkMessage.frame));
    _htmlLinkMessage.html = [NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    
    [_htmlLinkMessage sizeToFit];
    
    CGRect rect = _htmlActivityMessage.frame;
    rect.origin.y = _lbName.frame.size.height + _lbName.frame.origin.y;
    double heigthForTTLabel = [[[self htmlActivityMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    _htmlActivityMessage.frame = rect;

    NSURL *url = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        self.imgvAttach.hidden = NO;
        rect = self.imgvAttach.frame;
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
        rect.origin.y = _htmlActivityMessage.frame.size.height + _htmlActivityMessage.frame.origin.y + 5;
        rect.origin.x = (width > 320)? (width/3 + 60) : (width/3 + 40);
        self.imgvAttach.frame = rect;
        
        rect = _htmlLinkTitle.frame;
        rect.origin.y = self.imgvAttach.frame.size.height + self.imgvAttach.frame.origin.y + 5;
        _htmlLinkTitle.frame = rect;
    } else {
        rect = _htmlLinkTitle.frame;
        rect.origin.y = _htmlActivityMessage.frame.size.height + _htmlActivityMessage.frame.origin.y;
        _htmlLinkTitle.frame = rect;
        self.imgvAttach.hidden = YES;
    }
    [_htmlLinkTitle sizeToFit];
    rect = _htmlLinkDescription.frame;
    rect.origin.y = _htmlLinkTitle.frame.size.height + _htmlLinkTitle.frame.origin.y;
    heigthForTTLabel = _htmlLinkDescription.frame.size.height;
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    _htmlLinkDescription.frame = rect;
    NSLog(@"%@", NSStringFromCGRect(rect));
    
    rect = _htmlLinkMessage.frame;
    rect.origin.y = _htmlLinkDescription.frame.size.height + _htmlLinkDescription.frame.origin.y;
    
    
    NSString *link = [NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    theSize = [link sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake((width > 320)?WIDTH_FOR_CONTENT_IPAD:WIDTH_FOR_CONTENT_IPHONE, CGFLOAT_MAX) 
                           lineBreakMode:UILineBreakModeWordWrap];
    rect.size.height = theSize.height;
    rect.size.width = _htmlLinkDescription.frame.size.width;
    
    
    heigthForTTLabel = rect.size.height;
    if (heigthForTTLabel > EXO_MAX_HEIGHT) heigthForTTLabel = EXO_MAX_HEIGHT;  
    rect.size.height = heigthForTTLabel;
    _htmlLinkMessage.frame = rect;
    NSLog(@"%@", NSStringFromCGRect(rect));
    
}



- (void)dealloc {
    _lbName = nil;

    [_htmlLinkTitle release];
    _htmlLinkTitle = nil;
    
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;

    [_htmlActivityMessage release];
    _htmlActivityMessage = nil;
    
    [super dealloc];
}


@end

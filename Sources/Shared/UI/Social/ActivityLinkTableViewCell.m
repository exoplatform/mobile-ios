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

@implementation ActivityLinkTableViewCell

@synthesize imgvAttach = _imgvAttach;
@synthesize lbComment = _lbComment;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlLinkMessage.textColor = [UIColor grayColor];
        _htmlLinkMessage.backgroundColor = [UIColor whiteColor];
        
        _lbComment.textColor = [UIColor grayColor];
        _lbComment.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlLinkMessage.textColor = [UIColor darkGrayColor];
        _htmlLinkMessage.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
        _lbComment.textColor = [UIColor darkGrayColor];
        _lbComment.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
    }
    
    [super configureFonts:highlighted];
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPAD, 21);
    } else {
        tmpFrame = CGRectMake(70, 38, WIDTH_FOR_CONTENT_IPHONE, 21);
    }
    
    _htmlLinkMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlLinkMessage.userInteractionEnabled = NO;
    _htmlLinkMessage.autoresizesSubviews = YES;
    _htmlLinkMessage.backgroundColor = [UIColor clearColor];
    _htmlLinkMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlLinkMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlLinkMessage];
    
    _lbComment = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbComment.userInteractionEnabled = NO;
    _lbComment.autoresizesSubviews = YES;
    _lbComment.backgroundColor = [UIColor clearColor];
    _lbComment.font = [UIFont systemFontOfSize:13.0];
    _lbComment.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_lbComment];
        
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    
    //Set the UserName of the activity
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];

    _htmlLinkMessage.html = socialActivityStream.title;
    [_htmlLinkMessage sizeToFit];
    
    
    CGRect rect = _lbComment.frame;
    rect.origin.y = _htmlLinkMessage.frame.origin.y + _htmlLinkMessage.frame.size.height + 15;
    
    if([[socialActivityStream.templateParams valueForKey:@"image"] isEqualToString:@""]){
    
        rect.size.width = _htmlLinkMessage.frame.size.width - 10;
        
    } else {
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];

        rect.origin.x = _imgvAttach.frame.size.width + _imgvAttach.frame.origin.x + 10;
        rect.size.width = _htmlLinkMessage.frame.size.width - self.imgvAttach.frame.size.width - 10; 
        
        CGRect rectOfAttachImg = _imgvAttach.frame;
        rectOfAttachImg.origin.y = rect.origin.y;
        _imgvAttach.frame = rectOfAttachImg;
    }
    

    _lbComment.frame = rect;
    _lbComment.html = [socialActivityStream.templateParams valueForKey:@"comment"];
    [_lbComment sizeToFit];
    
}



- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;

    [_lbComment release];
    _lbComment = nil;
    
    [super dealloc];
}


@end

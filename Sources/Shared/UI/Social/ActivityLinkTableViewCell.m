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
    //_htmlLinkMessage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _htmlLinkMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlLinkMessage];
    
    
    //Also modify the frame of the _lbComment
    tmpFrame = _lbComment.frame;
    if (fWidth > 320) {
        tmpFrame.size.width = WIDTH_FOR_CONTENT_IPAD - _imgvAttach.frame.size.width;
    } else {
        tmpFrame.size.width = WIDTH_FOR_CONTENT_IPHONE - _imgvAttach.frame.size.width;
    }
    
    _lbComment.frame = tmpFrame;
        
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    
    //Set the UserName of the activity
    _lbName.text = [socialActivityStream.posterUserProfile.fullName copy];
     
    if([[socialActivityStream.templateParams valueForKey:@"image"] isEqualToString:@""]){
        CGRect rect = _lbComment.frame;
        rect.origin.x = _imgvAttach.frame.origin.x;
        rect.size.width += _imgvAttach.frame.size.width;
        _lbComment.frame = rect;
    } else {
        _imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        _imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    }
    
    _htmlLinkMessage.html = socialActivityStream.title;
    [_htmlLinkMessage sizeToFit];
    
    NSLog(@"_htmlLinkMessage Y:%2f  HEIGHT:%2f", _htmlLinkMessage.frame.origin.y, _htmlLinkMessage.frame.size.height);
    
    
    
    _lbComment.text = [socialActivityStream.templateParams valueForKey:@"comment"];
    [_lbComment sizeToFit];
          
    CGRect rect = _lbComment.frame;
    rect.origin.y = _htmlLinkMessage.frame.origin.y + _htmlLinkMessage.frame.size.height +15;
    _lbComment.frame = rect;

    NSLog(@"_lbComment Y:%2f  HEIGHT:%2f", _lbComment.frame.origin.y, _lbComment.frame.size.height);

    
}



- (void)dealloc {
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;
    
    _lbComment = nil;
    
    [super dealloc];
}


@end

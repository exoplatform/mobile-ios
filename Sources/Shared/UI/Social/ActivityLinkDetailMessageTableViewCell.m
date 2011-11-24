//
//  ActivityLinkDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityLinkDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "EGOImageView.h"
#import "ActivityHelper.h"
#import "LanguageHelper.h"

#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409

@implementation ActivityLinkDetailMessageTableViewCell

@synthesize lbComment = _lbComment;

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
    
    _lbComment = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbComment.userInteractionEnabled = NO;
    _lbComment.autoresizesSubviews = YES;
    _lbComment.backgroundColor = [UIColor clearColor];
    _lbComment.font = [UIFont systemFontOfSize:13.0];
    _lbComment.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_lbComment];
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    //Set the UserName of the activity
    //Set the UserName of the activity
    _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
    
    _htmlLinkMessage.html = socialActivityDetail.title;
    [_htmlLinkMessage sizeToFit];
    
    
    CGRect rect = _lbComment.frame;
    rect.origin.y = _htmlLinkMessage.frame.origin.y + _htmlLinkMessage.frame.size.height + 15;
    
    if([[_templateParams valueForKey:@"image"] isEqualToString:@""]){
        
        rect.size.width = _htmlLinkMessage.frame.size.width - 10;
        
    } else {
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
        
        rect.origin.x = _imgvAttach.frame.size.width + _imgvAttach.frame.origin.x + 10;
        rect.size.width = _htmlLinkMessage.frame.size.width - self.imgvAttach.frame.size.width - 10; 
        
        CGRect rectOfAttachImg = _imgvAttach.frame;
        rectOfAttachImg.origin.y = rect.origin.y;
        _imgvAttach.frame = rectOfAttachImg;
    }
    
    
    _lbComment.frame = rect;
    _lbComment.html = [_templateParams valueForKey:@"comment"];
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

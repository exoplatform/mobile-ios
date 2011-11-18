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
    
    
    //Also modify the frame of the _lbComment
    tmpFrame = _lbComment.frame;
    if (fWidth > 320) {
        tmpFrame.size.width = WIDTH_FOR_CONTENT_IPAD - _imgvAttach.frame.size.width;
    } else {
        tmpFrame.size.width = WIDTH_FOR_CONTENT_IPHONE - _imgvAttach.frame.size.width;
    }
    
    _lbComment.frame = tmpFrame;
    
}

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    //Set the UserName of the activity
    _lbName.text = [socialActivityDetail.posterIdentity.fullName copy];
    
    if([[_templateParams valueForKey:@"image"] isEqualToString:@""]){
        CGRect rect = _lbComment.frame;
        rect.origin.x = _imgvAttach.frame.origin.x;
        rect.size.width += _imgvAttach.frame.size.width;
        _lbComment.frame = rect;
    } else {
        _imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        _imgvAttach.imageURL = [NSURL URLWithString:[_templateParams valueForKey:@"image"]];
    }
    
    _htmlLinkMessage.html = socialActivityDetail.title;
    [_htmlLinkMessage sizeToFit];
    
    NSLog(@"_htmlLinkMessage Y:%2f  HEIGHT:%2f", _htmlLinkMessage.frame.origin.y, _htmlLinkMessage.frame.size.height);
    
    
    
    _lbComment.text = [_templateParams valueForKey:@"comment"];
    [_lbComment sizeToFit];
    
    CGRect rect = _lbComment.frame;
    rect.origin.y = _htmlLinkMessage.frame.origin.y + _htmlLinkMessage.frame.size.height +15;
    _lbComment.frame = rect;
}


@end

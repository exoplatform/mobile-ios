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


- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream{
    [super setSocialActivityStream:socialActivityStream];
     
    if([[socialActivityStream.templateParams valueForKey:@"image"] isEqualToString:@""]){
        CGRect rect = htmlLabel.frame;
        rect.origin.x = _imgvAttach.frame.origin.x;
        //rect.origin.y = _lbComment.frame.origin.y + _lbComment.frame.size.width;
        rect.size.width += _imgvAttach.frame.size.width;
        htmlLabel.frame = rect;
        
        rect = _imgvAttach.frame;
        rect.size.width = 0;
        rect.size.height = 0;
    } else {
        _imgvAttach.placeholderImage = [UIImage imageNamed:@"ActivityTypeDocument.png"];
        _imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    }
    htmlLabel.html = socialActivityStream.title;
//    htmlLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _lbComment.text = [socialActivityStream.templateParams valueForKey:@"comment"];
    
    _lbMessage.text = @"";
}


@end

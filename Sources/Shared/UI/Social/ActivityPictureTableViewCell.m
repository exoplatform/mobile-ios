//
//  ActivityPictureTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityPictureTableViewCell.h"
#import "SocialActivityStream.h"
#import "EGOImageView.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"

#define MAX_HEIGHT_FILE_NAME 32

@implementation ActivityPictureTableViewCell

@synthesize imgvAttach = _imgvAttach, urlForAttachment = _urlForAttachment, lbFileName = _lbFileName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [_imgvAttach needToBeResizedForSize:CGSizeMake(45,45)];
        
    }
    return self;
}


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _lbFileName.textColor = [UIColor grayColor];
        _lbFileName.backgroundColor = [UIColor whiteColor];
        
    } else {
        _lbFileName.textColor = [UIColor darkGrayColor];
        _lbFileName.backgroundColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1.];
        
    }
    
    [super configureFonts:highlighted];
}

- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
    CGRect tmpFrame = CGRectZero;
    //width = fWidth;
    if (fWidth > 320) {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPAD, 21);
        width = WIDTH_FOR_CONTENT_IPAD;
    } else {
        tmpFrame = CGRectMake(70, 14, WIDTH_FOR_CONTENT_IPHONE, 21);
        width = WIDTH_FOR_CONTENT_IPHONE;
    }
    
    _lbFileName.textAlignment = UITextAlignmentCenter;
    _lbFileName.userInteractionEnabled = NO;
    _lbFileName.backgroundColor = [UIColor clearColor];
    _lbFileName.font = [UIFont systemFontOfSize:13.0];
    _lbFileName.textColor = [UIColor grayColor];
    _lbFileName.numberOfLines = 2;
    
    _htmlMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _htmlMessage.userInteractionEnabled = NO;
    _htmlMessage.autoresizesSubviews = YES;
    _htmlMessage.font = [UIFont systemFontOfSize:13.0];
    _htmlMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _htmlMessage.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_htmlMessage];
}

- (void)setSocialActivityStreamForSpecificContent:(SocialActivityStream *)socialActivityStream {
    //Set the UserName of the activity
    _lbName.text = socialActivityStream.posterUserProfile.fullName?socialActivityStream.posterUserProfile.fullName:@"";
   
    NSString *html = nil;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_DOC:{
            html = [[[socialActivityStream.templateParams valueForKey:@"MESSAGE"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
        
            _htmlMessage.html = html?html:@"";
            [_htmlMessage sizeToFit];
            
            _lbFileName.text = [socialActivityStream.templateParams valueForKey:@"DOCNAME"];

            self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *strURL = [NSString stringWithFormat:@"%@%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [[socialActivityStream.templateParams valueForKey:@"DOCLINK"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            _urlForAttachment = [[NSURL alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
            
                        
            //Set the position of Title
            CGRect tmpFrame = _htmlMessage.frame;
            tmpFrame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height + 5;
            double heigthForTTLabel = [[[self htmlMessage] text] height];
            if (heigthForTTLabel > EXO_MAX_HEIGHT){
                heigthForTTLabel = EXO_MAX_HEIGHT; 
            }
            tmpFrame.size.height = heigthForTTLabel;
            tmpFrame.size.width = _lbName.frame.size.width;
            _htmlMessage.frame = tmpFrame;
            
            //Set the position of lbMessage
            tmpFrame = self.imgvAttach.frame;
            tmpFrame.origin.y = _htmlMessage.frame.origin.y + _htmlMessage.frame.size.height + 5;
            tmpFrame.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 70);
            self.imgvAttach.frame = tmpFrame;
            
            
            tmpFrame = _lbFileName.frame;
            tmpFrame.origin.y = self.imgvAttach.frame.origin.y + self.imgvAttach.frame.size.height + 5;
            CGSize theSize = [[socialActivityStream.templateParams valueForKey:@"DOCNAME"] sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) 
                                             lineBreakMode:UILineBreakModeWordWrap];
            if(theSize.height > MAX_HEIGHT_FILE_NAME){
                theSize.height = MAX_HEIGHT_FILE_NAME;
            }
            tmpFrame.size.height = theSize.height;
            tmpFrame.size.width = _lbName.frame.size.width;
            _lbFileName.frame = tmpFrame;
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            html = [NSString stringWithFormat:@"<a>%@</a> was created by <a>%@</a> state : %@", [socialActivityStream.templateParams valueForKey:@"contentName"], [socialActivityStream.templateParams valueForKey:@"author"], [socialActivityStream.templateParams valueForKey:@"state"]];

            _htmlMessage.html = [NSString stringWithFormat:@"<p>%@</p>", html?html:@""];
            [_htmlMessage sizeToFit];
            
            _lbFileName.text = @"";
            [_lbFileName sizeToFit];
            
            self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableFile.png"];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *strURL = [NSString stringWithFormat:@"%@/portal/rest/jcr/%@", [userDefaults valueForKey:EXO_PREFERENCE_DOMAIN], [[socialActivityStream.templateParams valueForKey:@"contenLink"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            _urlForAttachment = [[NSURL alloc] initWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; 
            
            
            //Set the position of Title
            CGRect tmpFrame = _htmlMessage.frame;
            tmpFrame.origin.y = _lbName.frame.origin.y + _lbName.frame.size.height + 5;
            double heigthForTTLabel = [[[self htmlMessage] text] height];
            if (heigthForTTLabel > EXO_MAX_HEIGHT){
                heigthForTTLabel = EXO_MAX_HEIGHT; 
            }
            tmpFrame.size.height = heigthForTTLabel;
            tmpFrame.size.width = _lbName.frame.size.width;
            _htmlMessage.frame = tmpFrame;
            
            
            //Set the position of lbMessage
            tmpFrame = self.imgvAttach.frame;
            tmpFrame.origin.y = _htmlMessage.frame.origin.y + _htmlMessage.frame.size.height + 10;
            tmpFrame.origin.x = (width > 320)? (width/3 + 100) : (width/3 + 70);
            self.imgvAttach.frame = tmpFrame;
        }
            break;
    }
}


- (void)startLoadingImageAttached {
    //if(self.imgvAttach.imageURL == nil)
    self.imgvAttach.imageURL = self.urlForAttachment;
}


- (void)resetImageAttached {
    self.imgvAttach.imageURL = nil;
}

- (void)dealloc
{
    [_urlForAttachment release];
    _urlForAttachment = nil;
    
    [super dealloc];
}

@end

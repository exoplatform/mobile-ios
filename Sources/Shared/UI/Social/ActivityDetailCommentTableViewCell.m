//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "ActivityDetailCommentTableViewCell.h"
#import "EGOImageView.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialComment.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "ActivityHelper.h"
#define kImageViewHeight 100
@interface ActivityDetailCommentTableViewCell ()
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightContraint;
@end

@implementation ActivityDetailCommentTableViewCell

@synthesize lbDate=_lbDate, lbName=_lbName, imgvAvatar=_imgvAvatar;
@synthesize imgvMessageBg=_imgvMessageBg;
@synthesize imageView = _imageView;
@synthesize width;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [_imgvAvatar needToBeResizedForSize:CGSizeMake(45,45)];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    self.lbDate = nil;
    self.lbName = nil;
    self.imgvAvatar = nil;
    
    self.imgvMessageBg = nil;
    
    [_imageView release];
    [_lbMessage release];
    [_imageViewHeightContraint release];
    [super dealloc];
}


#pragma mark - Activity Cell methods 

- (void)customizeAvatarDecorations {

}


- (void)configureFonts {
    
}


- (void)configureCell {
    
    [self customizeAvatarDecorations];
    
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    self.backgroundColor = [UIColor clearColor];
    
}



- (void)setSocialComment:(SocialComment*)socialComment
{
    NSString* tmp = socialComment.userProfile.avatarUrl;
    NSString* domainName = [(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN] copy];
    NSRange rang = [tmp rangeOfString:domainName];
    if (rang.length == 0) 
    {
        tmp = [NSString stringWithFormat:@"%@%@",domainName,tmp];
    }
    
    _imgvAvatar.imageURL = [NSURL URLWithString:tmp];  
    _lbName.text = [socialComment.userProfile.fullName copy];
    NSString * message = socialComment.message;
    if (socialComment.linkURLs!=nil && socialComment.linkURLs.count>0) {
        NSRange linkURLRange = [message rangeOfString:socialComment.linkURLs[0]];
        if (linkURLRange.location==NSNotFound){
            message = [NSString stringWithFormat:@"%@\n%@",message, socialComment.linkURLs[0]];
            linkURLRange = [message rangeOfString:socialComment.linkURLs[0]];
        }
        NSMutableAttributedString * attributedMessage = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedMessage addAttributes:kAttributeURL range:linkURLRange];
        self.lbMessage.attributedText = attributedMessage;
    } else {
        self.lbMessage.text = message;
    }
    
    _lbDate.text = socialComment.postedTimeInWords;
    if (socialComment.imageURLs!=nil && socialComment.imageURLs.count>0){
        NSURL * url = [NSURL URLWithString:socialComment.imageURLs[0]];
        if (url){
            self.imageView.imageURL = url;
            self.imageViewHeightContraint.constant = kImageViewHeight;
        } else {
            // Remove part of the string that is not actual data
            NSString * base64StringOfImage = [socialComment.imageURLs[0] stringByReplacingOccurrencesOfString:@"data:<;base64," withString:@""];
            int b64ImageStringLength = [base64StringOfImage length];
            if (b64ImageStringLength % 4 != 0) {
                // Append missing '=' so the string's length is a factor of 4
                // http://stackoverflow.com/a/21407393
                int missingChars = b64ImageStringLength % 4;
                for (int i = 4; i > missingChars; i--) {
                    base64StringOfImage = [base64StringOfImage stringByAppendingString:@"="];
                }
            }
            UIImage * image;
            if (base64StringOfImage){
                NSData* imageData = [[NSData alloc] initWithBase64EncodedString:base64StringOfImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
                image = [UIImage imageWithData:imageData];
            }
            if (image){
                self.imageView.image = image;
                self.imageViewHeightContraint.constant = kImageViewHeight;
            } else {
                self.imageViewHeightContraint.constant = 0;
            }
        }
    } else {
        self.imageView.image = nil;
        self.imageViewHeightContraint.constant = 0;
    }

    
}

@end
 

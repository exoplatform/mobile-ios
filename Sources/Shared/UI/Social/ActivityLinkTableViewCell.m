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

#import "ActivityLinkTableViewCell.h"
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
/*
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
        _htmlLinkDescription.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _htmlLinkTitle.textColor = [UIColor darkGrayColor];
        _htmlLinkTitle.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _htmlLinkMessage.textColor = [UIColor darkGrayColor];
        _htmlLinkMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _htmlActivityMessage.textColor = [UIColor darkGrayColor];
        _htmlActivityMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
    }
    
    [super configureFonts:highlighted];
}
*/

/*

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
*/
-(void) backgroundConfiguration {
    //Add images for Background Message
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    UIImage *strechBgSelected = [[UIImage imageNamed:@"SocialActivityBrowserActivityBgSelected.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
    
    _imgvMessageBg.image = strechBg;
    _imgvMessageBg.highlightedImage = strechBgSelected;
    
    //Add images for Comment button
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButton.png"]
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0]
                           forState:UIControlStateNormal];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"]
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0]
                           forState:UIControlStateSelected];
    [_btnComment setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserCommentButtonSelected.png"]
                                     stretchableImageWithLeftCapWidth:14 topCapHeight:0]
                           forState:UIControlStateHighlighted];
    
    
    //Add images for Like button
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButton.png"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:0]
                        forState:UIControlStateNormal];
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:0]
                        forState:UIControlStateSelected];
    [_btnLike setBackgroundImage:[[UIImage imageNamed:@"SocialActivityBrowserLikeButtonSelected.png"]
                                  stretchableImageWithLeftCapWidth:15 topCapHeight:0]
                        forState:UIControlStateHighlighted];
    
    
}

- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    [self backgroundConfiguration];
    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    

    NSString *title = [NSString stringWithFormat:@"%@%@", [socialActivityStream.posterIdentity.fullName copy], space ? [NSString stringWithFormat:@" in %@ space", space] : @""];
    
    
    _lbName.text = title;
    
    
  /*  NSString * activityMessage = [socialActivityStream.templateParams valueForKey:@"comment"];
    NSData *stringData = [activityMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *options = @{
                              NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              };
    NSMutableAttributedString *decodedString;
    NSDictionary * htmlAttributes;
    decodedString = [[NSMutableAttributedString alloc] initWithData:stringData options:options documentAttributes:&htmlAttributes error:NULL];
    [decodedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, decodedString.length)];
     */
    if (socialActivityStream.attributedMessage){
        _htmlActivityMessage.attributedText =  socialActivityStream.attributedMessage;
    } else {
        _htmlActivityMessage.text =@"";
    }
    
    // Link Title

    _htmlLinkTitle.text =[socialActivityStream.templateParams valueForKey:@"title"];
    
    _htmlLinkDescription.text =[socialActivityStream.templateParams valueForKey:@"description"];
    NSString * linkMessage =[NSString stringWithFormat:@"Source : %@",[socialActivityStream.templateParams valueForKey:@"link"]];
    NSMutableAttributedString * attributedLinkMessage =  [[NSMutableAttributedString alloc] initWithString:linkMessage];
    [attributedLinkMessage setAttributes:kAttributeURL range:[linkMessage rangeOfString:[socialActivityStream.templateParams valueForKey:@"link"]]];
    
    _htmlLinkMessage.attributedText = attributedLinkMessage;

    NSURL *url = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
    if (url && url.host && url.scheme){
        self.imgvAttach.placeholderImage = [UIImage imageNamed:@"IconForUnreadableLink.png"];
        self.imgvAttach.imageURL = [NSURL URLWithString:[socialActivityStream.templateParams valueForKey:@"image"]];
        _imageViewHeightConstraint.constant = 150;

    } else {

        _imageViewHeightConstraint.constant = 0;
    }

    
}


-(NSAttributedString * ) getHTMLAttributedStringFromString:(NSString *) string {
    
    NSMutableAttributedString * htmlAttributedString  = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSString * urlPattern = @"(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        [htmlAttributedString addAttributes:kAttributeURL range:matchRange];
    }
    return htmlAttributedString;
}

- (void)dealloc {
    _lbName = nil;

    [_htmlLinkTitle release];
    _htmlLinkTitle = nil;
    
    [_htmlLinkMessage release];
    _htmlLinkMessage = nil;

    [_htmlActivityMessage release];
    _htmlActivityMessage = nil;
    
    [_imageViewHeightConstraint release];
    [_htmlActivityMessage release];
    [_htmlLinkTitle release];
    [_htmlLinkDescription release];
    [_htmlLinkMessage release];
    [super dealloc];
}


@end

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

#import "ActivityForumTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

@implementation ActivityForumTableViewCell

@synthesize lbMessage = _lbMessage;
@synthesize htmlName = _htmlName;
@synthesize lbTitle = _lbTitle;


- (void)configureFonts:(BOOL)highlighted {
    
    if (!highlighted) {
        _htmlName.textColor = [UIColor grayColor];
        _htmlName.backgroundColor = [UIColor whiteColor];
        
        _lbMessage.textColor = [UIColor grayColor];
        _lbMessage.backgroundColor = [UIColor whiteColor];
        
        
        _lbTitle.textColor = [UIColor grayColor];
        _lbTitle.backgroundColor = [UIColor whiteColor];
    } else {
        _htmlName.textColor = [UIColor darkGrayColor];
        _htmlName.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbMessage.textColor = [UIColor darkGrayColor];
        _lbMessage.backgroundColor = SELECTED_CELL_BG_COLOR;
        
        _lbTitle.textColor = [UIColor darkGrayColor];
        _lbTitle.backgroundColor = SELECTED_CELL_BG_COLOR;
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
    
    //Use an html styled label to display informations about the author of the wiki page
    _lbTitle = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbTitle.userInteractionEnabled = NO;
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbTitle];
    
    _lbMessage = [[TTStyledTextLabel alloc] initWithFrame:tmpFrame];
    _lbMessage.userInteractionEnabled = NO;
    _lbMessage.backgroundColor = [UIColor clearColor];
    _lbMessage.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_lbMessage];
}




- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    NSString *html = nil;
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = nil;
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    switch (socialActivityStream.activityType) {
        case ACTIVITY_FORUM_CREATE_POST:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewPost")];
            html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [[[socialActivityStream.templateParams valueForKey:@"PostName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText]];
            break;
        case ACTIVITY_FORUM_CREATE_TOPIC:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"NewTopic")];
            
            float plfVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
            
            if(plfVersion >= 4.0) { // plf 4 and later: TopicName is not in template params, it is title of socialActivityStream
                html = [NSString stringWithFormat:@"<a>%@</a>",
                        [[socialActivityStream.title stringByEncodeWithHTML] stringByConvertingHTMLToPlainText]];
            } else {
                html = [NSString stringWithFormat:@"<a>%@</a>",
                        [[[socialActivityStream.templateParams valueForKey:@"TopicName" ] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText]];
            }
            
            break;
        case ACTIVITY_FORUM_UPDATE_TOPIC:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"UpdateTopic")];
            html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [[[socialActivityStream.templateParams valueForKey:@"TopicName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText]];
            break; 
        case ACTIVITY_FORUM_UPDATE_POST:
            _htmlName.html = [NSString stringWithFormat:@"<p><a>%@%@</a> %@</p>", socialActivityStream.posterIdentity.fullName, space ? [NSString stringWithFormat:@" in %@ space", space] : @"", Localize(@"UpdatePost")];
            html = [NSString stringWithFormat:@"<a>%@</a>", 
                             [[[socialActivityStream.templateParams valueForKey:@"PostName"] stringByEncodeWithHTML] stringByConvertingHTMLToPlainText]];
            break; 
        default:
            break;
    }
    
    [_htmlName sizeToFit];
    
    _lbTitle.html = html;
    [_lbTitle sizeToFit];
    
    _lbMessage.html = [[socialActivityStream.body stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    [_lbMessage sizeToFit];

    //Set the position of Title
    CGRect tmpFrame = _lbTitle.frame;
    tmpFrame.origin.y = _htmlName.frame.origin.y + _htmlName.frame.size.height + 5;
    //tmpFrame.size.width = _htmlName.frame.size.width;
    _lbTitle.frame = tmpFrame;
    
    //Set the position of lbMessage
    tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _lbTitle.frame.origin.y + _lbTitle.frame.size.height + 5;
    double heigthForTTLabel = [[[self lbMessage] text] height];
    if (heigthForTTLabel > EXO_MAX_HEIGHT){
        heigthForTTLabel = EXO_MAX_HEIGHT; 
    }
    tmpFrame.size.height = heigthForTTLabel;
    //tmpFrame.size.width = _htmlName.frame.size.width;
    _lbMessage.frame = tmpFrame;
}


- (void)dealloc {
    
    _lbMessage = nil;
    
    [_htmlName release];
    _htmlName = nil;
    
    [super dealloc];
}


@end

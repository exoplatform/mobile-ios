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

#import "ActivityWikiTableViewCell.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "NSString+HTML.h"
#import "defines.h"

#define MAX_LENGTH 80

@implementation ActivityWikiTableViewCell

@synthesize lbTitle = _lbTitle;

- (void)configureFonts:(BOOL)highlighted {
    
}



- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth {
    
}


- (void)setSocialActivityStreamForSpecificContent:(SocialActivity *)socialActivityStream {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        self.lbTitle.preferredMaxLayoutWidth = WIDTH_FOR_LABEL_IPAD;
    }

    //Set the UserName of the activity
    NSString *type = [socialActivityStream.activityStream valueForKey:@"type"];
    NSString *space = @"";
    
    if([type isEqualToString:STREAM_TYPE_SPACE]) {
        space = [socialActivityStream.activityStream valueForKey:@"fullName"];
    }
    
    NSString * name = socialActivityStream.posterIdentity.fullName;
    switch (socialActivityStream.activityType) {
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            name =  [NSString stringWithFormat:@"%@%@ %@",
                                         socialActivityStream.posterIdentity.fullName,  space.length ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")]  : @"",
                                         Localize(@"EditWiki")];
            
        }
            break;
        case ACTIVITY_WIKI_ADD_PAGE:
        {
            name =  [NSString stringWithFormat:@"%@%@ %@",
                                socialActivityStream.posterIdentity.fullName,  space.length ? [NSString stringWithFormat:@" %@ %@ %@",Localize(@"in"), space, Localize(@"space")] : @"",
                                Localize(@"CreateWiki")];            
        }
            
            break; 
        default:
            break;
    }
    
    NSMutableAttributedString * attributedName = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedName setAttributes:kAttributeText range:NSMakeRange(socialActivityStream.posterIdentity.fullName.length, name.length-socialActivityStream.posterIdentity.fullName.length)];
    [attributedName setAttributes:kAttributeNameSpace range:[name rangeOfString:[NSString stringWithFormat:@" %@ ",space]]];
    
    _lbName.attributedText = attributedName;
    
    _lbTitle.text =[[[socialActivityStream.templateParams valueForKey:@"page_name"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
    
    self.lbMessage.text =  [[[socialActivityStream.templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText] stringByEncodeWithHTML];
}



- (void)dealloc {
    _lbTitle = nil;
    [_lbTitle release];

    [super dealloc];
}

@end

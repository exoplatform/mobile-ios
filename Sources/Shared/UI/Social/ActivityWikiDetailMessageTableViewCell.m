//
//  ActivityWikiDetailMessageTableViewCell.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityWikiDetailMessageTableViewCell.h"
#import "SocialActivityDetails.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"
#import "defines.h"
#import "NSString+HTML.h"

@implementation ActivityWikiDetailMessageTableViewCell

- (void)setSocialActivityDetail:(SocialActivityDetails*)socialActivityDetail{
    [super setSocialActivityDetail:socialActivityDetail];
    switch (_activityType) {
        case ACTIVITY_WIKI_ADD_PAGE:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"CreateWiki"), [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            break;
        case ACTIVITY_WIKI_MODIFY_PAGE:{
            [_webViewForContent loadHTMLString:
             [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;color:#808080;font-family:\"Helvetica\";font-size:13;word-wrap: break-word;} a:link{color: #0888D6; text-decoration: none; font-weight: bold;}</style> </head><a  href=\"%@\">%@</a> %@<a href=\"%@\"> %@</a></body></html>", socialActivityDetail.posterIdentity.fullName, socialActivityDetail.posterIdentity.fullName, Localize(@"EditWiki"), [_templateParams valueForKey:@"page_url"],[_templateParams valueForKey:@"page_name"]] 
                                       baseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]
             ];
        }
            break;
    }
    //Set the position of lbMessage
    CGRect tmpFrame = _lbMessage.frame;
    tmpFrame.origin.y = _webViewForContent.frame.origin.y + _webViewForContent.frame.size.height + 5;
    _lbMessage.frame = tmpFrame;
    
    NSLog(@"%@", [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText]);
    _lbMessage.text = [[_templateParams valueForKey:@"page_exceprt"] stringByConvertingHTMLToPlainText];
    //[_lbMessage sizeToFit];
    //_lbMessage.text = [_templateParams valueForKey:@"page_exceprt"];
}

@end

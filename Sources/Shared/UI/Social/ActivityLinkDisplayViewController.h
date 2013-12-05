//
//  ActivityLinkDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoDisplayViewController.h"

@interface ActivityLinkDisplayViewController : eXoDisplayViewController{
    
    NSString *titleForActivityLink;
}
@property (nonatomic, copy) NSString *titleForActivityLink;
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;
-(NSString *) shortString : (NSString *) myString withMaxCharacter: (int) range;

@end

//
//  ActivityLinkDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "eXoDisplayViewController.h"

@interface ActivityLinkDisplayViewController : eXoDisplayViewController{
    
    NSString *titleForActivityLink;
}
@property (retain) NSString *titleForActivityLink;
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL;

@end

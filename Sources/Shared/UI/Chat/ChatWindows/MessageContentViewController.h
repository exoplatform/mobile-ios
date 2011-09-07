//
//  MessageContentViewController.h
//  eXo Platform
//
//  Created by Mai Gia on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageContentViewController : UIViewController {
    
    IBOutlet UIImageView* imgAvatar;
    IBOutlet UILabel* lbMessageContent;
    IBOutlet UIImageView* imgBackground;
    
}

- (void)setContentView:(int)width avatar:(UIImage *)img message:(NSString *)msg left:(BOOL)left;

@end

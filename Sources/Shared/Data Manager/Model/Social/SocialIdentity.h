//
//  SocialIdentity.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface SocialIdentity : RKObject {
    NSString* _identity;
}

@property (retain, nonatomic) NSString* identity;

@end

//
//  ChatUser.h
//  eXo Platform
//
//  Created by Mai Gia on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPUser.h"

@interface ChatUser : NSObject {
    
    XMPPUser* _user;
}

@property(nonatomic, retain) XMPPUser* user;

@end

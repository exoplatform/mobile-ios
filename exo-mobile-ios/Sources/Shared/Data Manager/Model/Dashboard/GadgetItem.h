//
//  GadgetItem.h
//  eXo Platform
//
//  Created by Stévan on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GadgetItem : NSObject {

    NSString *_gadgetUrl;
    NSString *_gadgetIcon;
    NSString *_gadgetName;
    NSString *_gadgetDescription;

}

@property (retain, nonatomic) NSString *gadgetUrl;
@property (retain, nonatomic) NSString *gadgetIcon;
@property (retain, nonatomic) NSString *gadgetName;
@property (retain, nonatomic) NSString *gadgetDescription;


@end

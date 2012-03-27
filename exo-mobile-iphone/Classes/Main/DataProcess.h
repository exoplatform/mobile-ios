//
//  DataProcess.h
//  eXoApp
//
//  Created by Tran Hoai Son on 6/1/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataProcess : NSObject {

}

+ (id)instance;
+ (id)newInstance;
+ (NSMutableArray*)parseData:(NSData*)data;

- (NSString*)escapeString:(NSString*)str withEncoding:(NSStringEncoding)encoding;
- (NSData*)formatDictData:(NSDictionary*)dictData WithEncoding:(NSStringEncoding)encoding;
@end

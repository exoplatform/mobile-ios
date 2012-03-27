//
//  eXoCache.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/20/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface eXoCache : NSObject {

}

+ (NSString*)createIconCacheDirectory;
+ (NSString*)createXMLCacheDirectory;
+ (NSString*)createTextCacheDirectory;
+ (void)saveWithFilename:(NSString*)filename data:(NSData*)data;
+ (NSData*)loadWithFilename:(NSString*)filename;
+ (void)removeAllCachedData;

@end

//
//  DataProcess.h
//  eXoApp
//
//  Created by Tran Hoai Son on 6/1/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import <Foundation/Foundation.h>

//Process data
@interface DataProcess : NSObject {

}

//Singleton constructor
+ (id)instance;
+ (id)newInstance;

+ (NSMutableArray*)parseData:(NSData*)data;	//Parsing data
+ (NSString *)decodeUrl:(NSString *)urlString;	//Decode URL

- (NSString*)escapeString:(NSString*)str withEncoding:(NSStringEncoding)encoding;	//Replace some spacial charactors
- (NSData*)formatDictData:(NSDictionary*)dictData WithEncoding:(NSStringEncoding)encoding;	//Get data from dictionary

@end

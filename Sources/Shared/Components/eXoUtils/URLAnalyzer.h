//
//  URLAnalyzer.h
//  eXo Platform
//
//  Created by Mai Gia on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLAnalyzer : NSObject {
    
}

+ (NSString *)parserURL:(NSString *)urlStr;
+ (NSString *)enCodeURL:(NSString *)url;
+ (NSString *)decodeURL:(NSString *)url;

@end

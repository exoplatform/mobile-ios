//
//  SocialProxy.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialProxy.h"
#import "SocialRestConfiguration.h"


/**
 * private helper function to convert any object to its string representation
 * @private
 */
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

/**
 * private helper function to convert string to UTF-8 and URL encode it
 * @private
 */
static NSString *urlEncode(id object) {
	NSString *string = toString(object);
	NSString *encodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
																				 (CFStringRef)string,
																				 NULL,
																				 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				 kCFStringEncodingUTF8);
	return [encodedString autorelease];
}


@implementation SocialProxy

@synthesize delegate;

- (void)dealloc {
    delegate = nil;

    [[RKRequestQueue sharedQueue] abortRequestsWithDelegate:self];
    [super dealloc];
}

- (NSString *)createPath {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    return [NSString stringWithFormat:@"api/social/%@/%@", socialConfig.restVersion, socialConfig.portalContainerName];
}

- (NSString*)URLEncodedString:(NSDictionary *)dictForParam {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in dictForParam) {
		id value = [dictForParam objectForKey:key];
		if ([value isKindOfClass:[NSArray class]]) {
			for (id item in value) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    // Handle nested object one level deep
                    for( NSString *nKey in [item allKeys] ) {
                        id nValue = [item objectForKey:nKey];
                        NSString *part = [NSString stringWithFormat: @"%@[][%@]=%@",
                                          urlEncode(key), urlEncode(nKey), urlEncode(nValue)];
                        [parts addObject:part];
                    }
                } else {
                    // Stringify
                    NSString *part = [NSString stringWithFormat: @"%@[]=%@",
                                      urlEncode(key), urlEncode(item)];
                    [parts addObject:part];
                }
			}
		} else {
			NSString *part = [NSString stringWithFormat: @"%@=%@",
							  urlEncode(key), urlEncode(value)];
			[parts addObject:part];
		}
	}
    
	return [parts componentsJoinedByString: @"&"];
}

- (NSData*)HTTPBody {
    NSDictionary *dict = [[NSDictionary alloc] init];
	return [[dict URLEncodedString] dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - RKObjectLoaderDelegate implementation
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {

}

@end

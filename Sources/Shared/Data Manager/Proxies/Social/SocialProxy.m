//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
    return [NSString stringWithFormat:@"private/api/social/%@/%@", socialConfig.restVersion, socialConfig.portalContainerName];
}

- (NSString*)URLEncodedString:(NSDictionary *)dictForParam {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in dictForParam) {
		id value = dictForParam[key];
		if ([value isKindOfClass:[NSArray class]]) {
			for (id item in value) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    // Handle nested object one level deep
                    for( NSString *nKey in [item allKeys] ) {
                        id nValue = item[nKey];
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

- (RKObjectLoader*)RKObjectLoader {
    return rkLoader;
}

#pragma mark - RKObjectLoaderDelegate implementation
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    LogTrace(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {    
    if (delegate && [delegate respondsToSelector:@selector(proxy: didFailWithError:)]) {
        [delegate proxy:self didFailWithError:error];
    }
}

@end

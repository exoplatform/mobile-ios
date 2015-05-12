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

#import "DataProcess.h"
#import "CXMLNode.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"

static DataProcess *_instance;

@implementation DataProcess

+ (id)instance
{
    if (!_instance) 
	{
        return [DataProcess newInstance];
    }
    return _instance;
}

+ (id)newInstance
{
    if(_instance)
	{
        [_instance release];
        _instance = nil;
    }
    
    _instance = [[DataProcess alloc] init];
    return _instance;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSString*)escapeString:(NSString*)str withEncoding:(NSStringEncoding)encoding
{
	// Convert to NSData then back to NSString
	// It must be done to allow lossy conversion, because stringByAddingPercentEscapesUsingEncoding may return nil otherwise
	NSData* data = [str dataUsingEncoding:encoding allowLossyConversion:YES];
	NSString* lossyString = [[NSString alloc] initWithData:data encoding:encoding];
	NSString* tempString = [lossyString stringByAddingPercentEscapesUsingEncoding:encoding];
	[lossyString release];
	
	NSMutableString *mutableString = [NSMutableString stringWithString:tempString];
	
	[mutableString replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[tempString length])];
	[mutableString replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[tempString length])];
	[mutableString replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[tempString length])];
	[mutableString replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[tempString length])];
	
	return mutableString;
}

- (NSData*)formatDictData:(NSDictionary*)dictData WithEncoding:(NSStringEncoding)encoding 
{
	NSArray* allKeys = [dictData allKeys];
	NSMutableArray* keyAndValues = [NSMutableArray arrayWithCapacity:[allKeys count]];
	
	NSEnumerator* e = [allKeys objectEnumerator];
	
	NSString* dictKey;
	while((dictKey = [e nextObject]))
	{	
		NSString* encodedKey = [self escapeString: dictKey withEncoding:encoding];
		//NSString* encodedValue = [self escapeString:dictKey withEncoding:encoding];   
		NSString* encodedValue = [self escapeString:(NSString*)dictData[dictKey] withEncoding:encoding];   
		NSString* keyAndValue = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
		[keyAndValues addObject:keyAndValue];
	}
	
	NSString* s = [keyAndValues componentsJoinedByString:@"&"];
	return [s dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSMutableArray*)parseData:(NSData*)data
{
	NSError* error;
	NSString* strData = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];

	
	CXMLDocument* xmldoc = [[CXMLDocument alloc] initWithXMLString:strData options:1 << 9 error:&error];
	CXMLElement *rootNode = [xmldoc rootElement];
	
	NSArray* arrNodes = [rootNode nodesForXPath:@"//a" error:&error];	
	NSEnumerator* e = [arrNodes objectEnumerator];
	CXMLNode* tmpNode;
	NSString* tmpNodeDescription;
	NSString* tmpNodeValue;
	
	NSMutableArray* arrDicts = [[NSMutableArray alloc] init];
	[arrDicts removeAllObjects];
	
	while ((tmpNode = [e nextObject])) 
	{
		tmpNodeDescription = [tmpNode description];
		tmpNodeValue = [tmpNode stringValue];
		
		if([tmpNodeValue compare:@" .."] != NSOrderedSame)
		{
			NSRange range1 = [tmpNodeDescription rangeOfString:@"href="];
			int mark = 0;
			
			if(range1.length > 0)
			{
				
				for(int i = range1.location + range1.length + 1; i < [tmpNodeDescription length]; i ++)
				{
					if([tmpNodeDescription characterAtIndex:i] == '"')
					{
						mark = i;
						break;
					}
				}
			}
			
			NSRange range2 = NSMakeRange(range1.location + range1.length + 1, mark - range1.location - range1.length - 1);
			NSString* strDictValue = [tmpNodeDescription substringWithRange:range2];
			
			NSDictionary* tmpNodeDict = [[NSMutableDictionary alloc] initWithCapacity:2];
			[tmpNodeDict setValue:strDictValue forKey:tmpNodeValue];
			[arrDicts addObject:tmpNodeDict];
		}	
	}
	
	return arrDicts;
}


+ (NSString *)decodeUrl:(NSString *)urlString
{
    NSMutableString *temp = [urlString mutableCopy];
	
    [temp replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0
                               range:NSMakeRange(0, [temp length])];
	
    [temp replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0
                               range:NSMakeRange(0, [temp length])];
	
    [temp replaceOccurrencesOfString:@"&gt;" withString:@">" options:0
                               range:NSMakeRange(0, [temp length])];
	
    [temp replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:0
                               range:NSMakeRange(0, [temp length])];
	
    [temp replaceOccurrencesOfString:@"&apos;" withString:@"'" options:0
                               range:NSMakeRange(0, [temp length])];
	
	[temp replaceOccurrencesOfString:@"%2F" withString:@"/" options:0
                               range:NSMakeRange(0, [temp length])];
	
	[temp replaceOccurrencesOfString:@"%2B" withString:@"+" options:0
                               range:NSMakeRange(0, [temp length])];
	
	[temp replaceOccurrencesOfString:@"%20" withString:@" " options:0
                               range:NSMakeRange(0, [temp length])];
	
	[temp replaceOccurrencesOfString:@"%3A" withString:@":" options:0
                               range:NSMakeRange(0, [temp length])];
	
	
	
    return [temp autorelease];
}

@end

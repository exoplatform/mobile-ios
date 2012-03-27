//
//  DataProcess.m
//  eXoApp
//
//  Created by Tran Hoai Son on 6/1/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
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
	NSString* escapedString = [lossyString stringByAddingPercentEscapesUsingEncoding:encoding];
	[lossyString release];
	
	NSMutableString *mutableString = [NSMutableString stringWithString:escapedString];
	
	[mutableString replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[escapedString length])];
	[mutableString replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[escapedString length])];
	[mutableString replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[escapedString length])];
	[mutableString replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[escapedString length])];
	
	return mutableString;
}

- (NSData*)formatDictData:(NSDictionary*)dictData WithEncoding:(NSStringEncoding)encoding 
{
	NSArray* allKeys = [dictData allKeys];
	NSMutableArray* keyAndValues = [NSMutableArray arrayWithCapacity:[allKeys count]];
	
	NSEnumerator* e = [allKeys objectEnumerator];
	
	NSString* dictKey;
	while(dictKey = [e nextObject])
	{	
		NSString* encodedKey = [self escapeString: dictKey withEncoding:encoding];
		//NSString* encodedValue = [self escapeString:dictKey withEncoding:encoding];   
		NSString* encodedValue = [self escapeString:(NSString*)[dictData objectForKey:dictKey] withEncoding:encoding];   
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
	
	while (tmpNode = [e nextObject]) 
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
@end

//
//  eXoUserClient.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoUserClient.h"
#import "defines.h"
#import "eXoUser.h"
#import "CXMLNode.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"
#import "eXoEachGadgetViewController.h"
#import "eXoIconRepository.h"
#import "eXoMessage.h"
#import "DataProcess.h"

static eXoUserClient *_instance;

@implementation eXoUserClient
@synthesize _user;
@synthesize _imgGadgetIcon;

+ (id)instance
{
    if (!_instance) 
	{
        return [eXoUserClient newInstance];
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
    
    _instance = [[eXoUserClient alloc] init];
    return _instance;
}

- (id)init 
{
	return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(NSObject<eXoUserClientDelegate>*)delegate 
{
	self = [super init];
	if(self)
	{
		_delegate = delegate;
		[_delegate retain];
	}
	return self;
}

- (void)getUserInfo:(NSString*)q 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString*	url = [NSString stringWithFormat:@"%@/portal/public/classic", [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN], q];
	[super requestGET:url];
}

- (void)getUserInfoForScreenName:(NSString*)screen_name 
{
	[self getUserInfo:screen_name];
}

- (void)getUserInfoForUserId:(NSString*)user_id {
	[self getUserInfo:user_id];
}

- (void)requestSucceeded 
{
	if (_statusCode == 200) 
	{
		if (_isXmlTypeContent) 
		{
			NSError* error;
			
			CXMLDocument *document = [[CXMLDocument alloc] initWithData:_receivedData options:1 << 9 error:&error];
			CXMLElement *rootNode = [document rootElement];
			
			//============================================================================
			NSArray* modulePref = [rootNode nodesForXPath:@"//ModulePrefs" error:&error];			
			NSString* contentPref = [modulePref description];
			NSString* tmpStr = contentPref;
			NSString* thumbnailStr = @"";
			
			for (int i = 0; i < [tmpStr length]; i++)
			{
				NSRange r = [tmpStr rangeOfString:@"thumbnail="];
				
				if(r.length > 0)
				{
					tmpStr = [tmpStr substringFromIndex:r.location + 11];
				}
				else
				{
					break;
				}
				
				for (int j = 0; j < [tmpStr length]; j++)
				{
					NSRange thumbnailRange;
					thumbnailRange.location = 0;
					if ([tmpStr characterAtIndex:j] == '"')
					{
						thumbnailRange.length = j;
						thumbnailStr = [tmpStr substringWithRange:thumbnailRange];
						//[arrOutput addObject:thumbnailStr];
						tmpStr = [tmpStr substringFromIndex:j + 1];
						i = 0;
						break;
					}
				}
				
				break;
			}
			
			NSURL *url = [NSURL URLWithString:thumbnailStr];
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];			
			NSData *urlData;
			NSURLResponse *response;		
			NSMutableData *responseData;
			
			urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
			if (urlData)
			{
				responseData = [[NSMutableData data] retain];
				[responseData setLength:0];
				[responseData appendData:urlData];
			}
			
			//eXoMessage* exoMessage = [[[eXoMessage alloc] init] autorelease]; 
			//_imgGadgetIcon = [[eXoIconRepository instance] imageForURL:thumbnailStr delegate:exoMessage];
			
			//============================================================================
			
			//NSArray *nodes = [rootNode nodesForXPath:@"./Content/@type" error:&error];
			//NSString *value = [[nodes objectAtIndex:0] description];
			
//			NSString* docContent = [document description];
//			NSRange r1 = [docContent rangeOfString:@"![CDATA["];
//			NSRange r2 = [docContent rangeOfString:@"]]"];
//			NSRange r3 = NSMakeRange(r1.location + 8, r2.location - r1.location - 8);
//			NSString* subStr = [docContent substringWithRange:r3];
//			CXMLDocument* xmldoc = [[CXMLDocument alloc] initWithXMLString:subStr options:1 << 9 error:&error];
		}
	}
	
	[super requestSucceeded];
	[_delegate eXoUserClientSucceeded:self];
	//[self autorelease];
}

- (void)requestFailed:(NSError*)error 
{
	[_delegate eXoUserClientFailed:self];
	//[self autorelease];
}

- (void)getGadgets:(NSString*)url
{
	[super requestGET:url];
}

//- (BOOL)signInWithUserName:(NSString*)userName password:(NSString*)password
- (NSString*)signInDomain:(NSString*)domain withUserName:(NSString*)userName password:(NSString*)password
{
	return [super sendAuthenticateRequest:domain username:userName password:password];
}

- (void)getExoOpenSocialActivitiesStream
{
	//NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	//NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	//NSString* actStreamUrl = [domain stringByAppendingString:@"/portal/private/classic/mydashboard"];
}
@end

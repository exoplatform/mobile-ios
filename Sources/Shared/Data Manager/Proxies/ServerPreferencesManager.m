//
//  Configuration.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerPreferencesManager.h"
#import "CXMLDocument.h"
#import "CXMLNode.h"
#import "CXMLElement.h"

@implementation ServerObj
@synthesize _strServerName;
@synthesize _strServerUrl;
@synthesize _bSystemServer;
@end


//======================================================================
@implementation ServerPreferencesManager

+ (ServerPreferencesManager*)sharedInstance
{
	static ServerPreferencesManager *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[ServerPreferencesManager alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}

- (id) init
{
	self = [super init];
    if (self) 
    {
        _arrServerList = [[NSMutableArray alloc] init];
    }	
	return self;
}

- (void) dealloc
{
	[_arrServerList release];
	[super dealloc];
}

- (NSMutableArray*)getServerList
{
    NSError* error;
    NSMutableArray* arrSystemServerList;
    NSMutableArray* arrUserServerList;
    NSMutableArray* arrDeletedSystemServerList;
    NSString* strDefaultConfigPath;
    NSString* strSystemConfigPath;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* strAppOldVersion = [userDefault objectForKey:@"prefVersion"];
    NSString* strAppCurrentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    //Load the system Configuration
    if ((!strAppOldVersion) || (strAppOldVersion && ([strAppCurrentVersion compare:strAppOldVersion] == NSOrderedAscending)))
    {
        //copy the defautl Configuration to the system Configuration in the /app/documents
        strDefaultConfigPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"xml"];
        strSystemConfigPath = [[paths objectAtIndex:0] stringByAppendingString:@"/SystemConfiguration"];
        [fileManager copyItemAtPath:strDefaultConfigPath toPath:strSystemConfigPath error:&error];
    }
    
    //Load the system Configuration
    arrSystemServerList = [self loadSystemConfiguration];
    
    //Load the deleted system Configuration
    arrDeletedSystemServerList = [self loadDeletedSystemConfiguration];
    
    if ([arrDeletedSystemServerList count] > 0) 
    {
        for (int i = 0; i < [arrSystemServerList count]; i++) 
        {
            ServerObj* tmpServerObj1 = [arrSystemServerList objectAtIndex:i];
            for (int j = 0; j < [arrDeletedSystemServerList count]; j++) 
            {
                ServerObj* tmpServerObj2 = [arrDeletedSystemServerList objectAtIndex:j];
                if ([tmpServerObj2._strServerName isEqualToString:tmpServerObj1._strServerName] &&
                    [tmpServerObj2._strServerUrl isEqualToString:tmpServerObj1._strServerUrl]) 
                {
                    [arrSystemServerList removeObjectAtIndex:i];
                    i --;
                    break;
                }
            }
            if ((i == 0) && ([arrSystemServerList count] == 1))
            {
                i--;
            }
        }
    }
    
    //Load the user Configuration    
    arrUserServerList = [self loadUserConfiguration];
    [_arrServerList removeAllObjects];
    if ([arrSystemServerList count] > 0) 
    {
        [_arrServerList addObjectsFromArray:arrSystemServerList];
    }
    if ([arrUserServerList count] > 0) 
    {
        [_arrServerList addObjectsFromArray:arrUserServerList];
    }
    
    NSData* tmpData = [self createXmlDataWithServerList:_arrServerList];
    [self writeData:tmpData toFile:@"Test"];
    return _arrServerList;
}

//Load the system Configuration
- (NSMutableArray*)loadSystemConfiguration
{
    NSData* data = [self readFileWithName:@"SystemConfiguration"];
    NSMutableArray* arr = [self parseConfiguration: data withBSystemSever:YES];
    return arr;
}

//Load the deleted system Configuration
- (NSMutableArray*)loadDeletedSystemConfiguration
{
    NSData* data = [self readFileWithName:@"DeletedSystemConfiguration"];
    NSMutableArray* arr = [self parseConfiguration: data withBSystemSever:YES];
    return arr;
}

//Load the user Configuration
- (NSMutableArray*)loadUserConfiguration
{
    NSData* data = [self readFileWithName:@"UserConfiguration"];
    NSMutableArray* arr = [self parseConfiguration: data withBSystemSever:NO];
    return arr;
}

- (NSMutableArray*)parseConfiguration:(NSData*)data withBSystemSever:(BOOL)bSystemServer
{
    NSError* error;
    NSMutableArray* arrServerList = [[NSMutableArray alloc] init];
    CXMLDocument* doc = [[CXMLDocument alloc] initWithData:data options:0 error:&error];
    if(doc != nil) 
    {
        CXMLElement* root = [doc rootElement];
        NSArray* arrXml = [root elementsForName:@"xml"];
        if (arrXml) 
        {
            CXMLElement* elementXml = [arrXml objectAtIndex:0];
            NSArray* arrServers = [elementXml elementsForName:@"Servers"];
            if (arrServers) 
            {
                CXMLElement* elementSevers = [arrServers objectAtIndex:0];
                NSArray* arrsever = [elementSevers elementsForName:@"server"];
                if (arrsever) 
                {
                    CXMLNode* tmpNode;                   
                    for (int i = 0; i < [arrsever count]; i++) 
                    {
                        tmpNode = [arrsever objectAtIndex:i];
                        ServerObj* serverObj = [[ServerObj alloc] init];
                        serverObj._strServerName = [self getNodeValue:tmpNode withName:@"name"];
                        serverObj._strServerUrl = [self getNodeValue:tmpNode withName:@"serverURL"];
                        serverObj._bSystemServer = bSystemServer;
                        [arrServerList addObject:serverObj];
                        [serverObj release];
                    }
                }
            }
        }
    }
    return arrServerList;
}

//Read the file with name
- (NSData*)readFileWithName:(NSString*)strFileName
{    
    NSData* data = [[NSData alloc] init];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL bExist = NO;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* strFilePath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@",strFileName]];
    bExist = [fileManager fileExistsAtPath:strFilePath];
    if (bExist) 
    {
        data = [fileManager contentsAtPath:strFilePath];
    }
    return data;
}

//Saved the system Configuration to the /app/documents
- (void)writeSystemConfiguration:(NSMutableArray*)arrSystemServerList
{
    NSData* dataWrite  = [self createXmlDataWithServerList:arrSystemServerList];
    [self writeData:dataWrite toFile:@"SystemConfiguration"];
}

//Saved the deleted system Configuration to the /app/documents
- (void)writeDeletedSystemConfiguration:(NSMutableArray*)arrDeletedSystemServerList
{
    NSData* data = [self readFileWithName:@"DeletedSystemConfiguration"];
    NSMutableArray* tmpArr = [self parseConfiguration: data withBSystemSever:YES];
    [tmpArr addObjectsFromArray:arrDeletedSystemServerList];
    NSData* dataWrite  = [self createXmlDataWithServerList:tmpArr];
    [self writeData:dataWrite toFile:@"DeletedSystemConfiguration"];
}

//Saved the user Configuration to the /app/documents
- (BOOL)writeUserConfiguration:(NSMutableArray*)arrUserSystemServerList
{
    NSData* dataWrite = [self createXmlDataWithServerList:arrUserSystemServerList];
    return [self writeData:dataWrite toFile:@"UserConfiguration"];
}

- (BOOL)writeData:(NSData*)data toFile:(NSString*)strFileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* strFilePath = [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@",strFileName]];
    return [fileManager createFileAtPath:strFilePath contents:data attributes:nil];
}


//Created the xml string before saving
- (NSData*)createXmlDataWithServerList:(NSMutableArray*)arrServerList
{
    NSString* strContent = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n\t<xml>\n\t\t<Servers>\n";
    for (int i = 0; i < [arrServerList count]; i++) 
    {
        ServerObj* tmpServerObj = [arrServerList objectAtIndex:i];
        NSString* tmpStr = [NSString stringWithFormat:@"\t\t\t<server name=\"%@\" serverURL=\"%@\"/>\n",tmpServerObj._strServerName, tmpServerObj._strServerUrl];
        strContent = [strContent stringByAppendingString:tmpStr];
    }
    
    NSString* strEnd = @"\t\t</Servers>\n\t</xml>\n</plist>";
    strContent = [strContent stringByAppendingString:strEnd];
    NSData* data = [strContent dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


- (CXMLNode*) getNode: (CXMLNode*) element withName: (NSString*) name 
{
	for(CXMLNode* child in [element children]) 
    {
		if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) 
        {
			return (CXMLNode*)child;
		}
	}
	
    for(CXMLNode* child in [element children]) 
    {
		CXMLNode* el = [self getNode: (CXMLElement*)child withName: name];
		if(el != nil) 
        { 
            return el; 
        }
	}
	return nil;
}

- (NSString*) getNodeValue: (CXMLNode*) node withName: (NSString*) name 
{
	// Set up the variables
	if(node == nil || name == nil) 
    { 
        return nil; 
    }
	
    CXMLNode* child = nil;
	
	// If it's an attribute get it
	if([node isKindOfClass: [CXMLElement class]])
	{
		child = [(CXMLElement*)node attributeForName: name];
		if(child != nil) 
        {
			return [child stringValue];
		}
	}
    
	// Otherwise get the first element
	child = [self getNode: node withName: name];
	if(child != nil) 
    {
		return [child stringValue];
	}
	return nil;
}

@end

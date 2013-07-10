//
//  Configuration.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"
#import "CXMLDocument.h"
#import "CXMLNode.h"
#import "CXMLElement.h"
#import "defines.h"
#import "LanguageHelper.h"
#import "URLAnalyzer.h"
#define CURRENT_USER_NAME       [UserPreferencesManager sharedInstance].username
#define USERNAME_EQUALS @"username="
#define SERVER_LINK_EQUALS @"serverUrl="
#pragma mark - Server Object


@implementation ServerObj
@synthesize _strServerName;
@synthesize _strServerUrl;
@synthesize _bSystemServer;
@synthesize username = _username;
@synthesize password = _password;
@end

#pragma mark - Application Prefs

@implementation ApplicationPreferencesManager

#pragma mark - Properties

#pragma mark * Server management
@synthesize selectedServerIndex = _selectedServerIndex;
@synthesize selectedDomain = _selectedDomain;

#pragma mark * JCR storage
@synthesize currentRepository = _currentRepository;
@synthesize defaultWorkspace = _defaultWorkspace;
@synthesize userHomeJcrPath = _userHomeJcrPath;


#pragma mark - Methods

#pragma mark * Lifecyle
+ (ApplicationPreferencesManager*)sharedInstance
{
	static ApplicationPreferencesManager *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[ApplicationPreferencesManager alloc] init];
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
        self.selectedServerIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
    }	
	return self;
}

- (void) dealloc
{
    [_selectedDomain release];
	[_arrServerList release];
    [_currentRepository release];
    [_defaultWorkspace release];
    [_userHomeJcrPath release];
	[super dealloc];
}

#pragma mark * Server management
- (void)loadServerList
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
    if (!_arrServerList) _arrServerList = [[NSMutableArray alloc] init];
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
}

- (void)setSelectedServerIndex:(int)selectedServerIndex {
    // customize setter of selectedServerIndex
    int tmpIndex = -1; // default value for selected server index 
    NSString *tmpDomain = nil; // default value for selected domain
    if (selectedServerIndex >= 0 && self.serverList.count > 0) {
        if (selectedServerIndex < [self.serverList count]) {
            tmpIndex = selectedServerIndex;
            ServerObj *selectedObj = [self.serverList objectAtIndex:selectedServerIndex];
            tmpDomain = selectedObj._strServerUrl;
        }
    }
    [_selectedDomain release];
    _selectedDomain = [tmpDomain retain];
    _selectedServerIndex = tmpIndex;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", _selectedServerIndex] forKey:EXO_PREFERENCE_SELECTED_SEVER];
    [userDefaults setObject:_selectedDomain forKey:EXO_PREFERENCE_DOMAIN];
}

- (NSString *)selectedDomain {
    if (!_selectedDomain) {
        _selectedDomain = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_DOMAIN];
    }
    return [[_selectedDomain copy] autorelease];
}

#pragma mark * Read/Write data
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
    NSMutableArray* arrServerList = [[[NSMutableArray alloc] init] autorelease];
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
                        serverObj.username = [self getNodeValue:tmpNode withName:@"username"];
                        serverObj.password = [self getNodeValue:tmpNode withName:@"password"];
                        serverObj._bSystemServer = bSystemServer;
                        [arrServerList addObject:serverObj];
                        [serverObj release];
                    }
                }
            }
        }
    }
    [doc release];
    return arrServerList;
}

//Read the file with name
- (NSData*)readFileWithName:(NSString*)strFileName
{    
    NSData* data = nil;
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
    // update selected server info to userdefault
    self.selectedServerIndex = self.selectedServerIndex;
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
    // update selected server info
    self.selectedServerIndex = self.selectedServerIndex;
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
        NSString* tmpStr = [NSString stringWithFormat:@"\t\t\t<server name=\"%@\" serverURL=\"%@\" username=\"%@\" password=\"%@\" />\n" ,tmpServerObj._strServerName, tmpServerObj._strServerUrl, tmpServerObj.username, tmpServerObj.password];
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

- (NSMutableArray *)serverList {
    if (!_arrServerList) {
        [self loadServerList];
    }
    return _arrServerList;
}

#pragma mark * JCR storage

- (void)setJcrRepositoryName:(NSString *)repositoryName defaultWorkspace:(NSString *)defaultWorkspace userHomePath:(NSString *)userHomePath {
    [repositoryName retain];
    [_currentRepository release];
    _currentRepository = repositoryName ? repositoryName : [@"repository" retain];
    [defaultWorkspace retain];
    [_defaultWorkspace release];
    _defaultWorkspace = defaultWorkspace ? defaultWorkspace : [@"collaboration" retain];
    [userHomePath retain];
    [_userHomeJcrPath release];
    _userHomeJcrPath = userHomePath ? userHomePath : [[self makeUserHomePath:CURRENT_USER_NAME] retain];
}

- (NSString *)makeUserHomePath:(NSString *)username; 
{
    NSMutableString *path = [NSMutableString stringWithString:@"/Users"];
    
    int length = [username length];
    
    int numberOfUserLevel = length < 4 ?  2 : 3;
    
    for(int i = 1; i <= numberOfUserLevel; i++)
    {
        NSMutableString *userNameLevel = [NSMutableString stringWithString:[username substringToIndex:i]];
        
        for(int j = 1; j <= 3; j++)
        {
            [userNameLevel appendString:@"_"];
        }
        
        [path appendFormat:@"/%@", userNameLevel];        
    }
    
    [path appendFormat:@"/%@", username];
    return path;
}


#pragma mark - Server Manager
// Check if the server already exists (both name and URL, ignoring the case)
// Ignore the index of the server you are currently editing
// Ignore -1 to compare with all the existing servers
- (int)checkServerAlreadyExistsWithName:(NSString*)strServerName andURL:(NSString*)strServerUrl ignoringIndex:(NSInteger) index {
    
    for (int i = 0; i < [self.serverList count]; i++)
    {
        if (index==i)continue; // ignore the server specified by index
        ServerObj* tmpServerObj = [self.serverList objectAtIndex:i];
        NSString* tmpServName = [tmpServerObj._strServerName lowercaseString];
        NSString* tmpServURL = [tmpServerObj._strServerUrl lowercaseString];
        if ([tmpServName isEqualToString:[strServerName lowercaseString]] ||
            [tmpServURL isEqualToString:[strServerUrl lowercaseString]])
        {
            return i;
        }
    }
    return -1;
}

// Unique private method to add/edit a server, avoids duplicating common code
- (BOOL) addEditServerWithServerName:(NSString*) strServerName andServerUrl:(NSString*) strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password atIndex:(int)index {
    
    // We don't specify an existing server so it's a new one
    if (index == -1)
    {
        //Create the new server
        ServerObj* serverObj = [[ServerObj alloc] init];
        serverObj._strServerName = strServerName;
        serverObj._strServerUrl = strServerUrl;
        serverObj._bSystemServer = NO;
        serverObj.username = username ? username : @"";
        serverObj.password = password ? password : @"";
        
        //Add the server in configuration
        NSMutableArray* arrAddedServer = [self loadUserConfiguration];
        [arrAddedServer addObject:serverObj];
        [self writeUserConfiguration:arrAddedServer];
        [serverObj release];
        [self loadServerList]; // reload list of servers
    }
    // Edit the server specified by index
    else
    {
        ServerObj* serverObjEdited = [self.serverList objectAtIndex:index];
        ServerObj* tmpServerObj;
        
        serverObjEdited._strServerName = strServerName;
        serverObjEdited._strServerUrl = strServerUrl;
        serverObjEdited.username = username;
        serverObjEdited.password = password;
        
        [self.serverList replaceObjectAtIndex:index withObject:serverObjEdited];
        
        NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.serverList count]; i++)
        {
            tmpServerObj = [self.serverList objectAtIndex:i];
            if (tmpServerObj._bSystemServer == serverObjEdited._bSystemServer)
            {
                [arrTmp addObject:tmpServerObj];
            }
        }
        
        if (serverObjEdited._bSystemServer)
        {
            [self writeSystemConfiguration:arrTmp];
        }
        else
        {
            [self writeUserConfiguration:arrTmp];
        }
        
        [self loadServerList];
    }
    
    // If this is the only server: select it automatically
    if ([self.serverList count] == 1)
        [self setSelectedServerIndex:0];
    
    return YES;
}

- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    return [self addEditServerWithServerName:strServerName andServerUrl:strServerUrl  withUsername:nil andPassword:nil atIndex:-1];
}

- (BOOL)deleteServerObjAtIndex:(int)index
{
    ServerObj* deletedServerObj = [[self.serverList objectAtIndex:index] retain];
    
    [self.serverList removeObjectAtIndex:index];
    int currentIndex = self.selectedServerIndex;
    if ([self.serverList count] > 0) {
        if(currentIndex > index) {
            self.selectedServerIndex = currentIndex - 1;
        } else if (currentIndex == index) {
            self.selectedServerIndex = currentIndex < self.serverList.count ? currentIndex : self.serverList.count - 1;
        }
    } else {
        self.selectedServerIndex = -1;
    }
    NSMutableArray* arrTmp = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.serverList count]; i++)
    {
        ServerObj* tmpServerObj = [self.serverList objectAtIndex:i];
        if (tmpServerObj._bSystemServer == deletedServerObj._bSystemServer)
        {
            [arrTmp addObject:tmpServerObj];
        }
    }
    
    if (deletedServerObj._bSystemServer)
    {
        [self writeSystemConfiguration:arrTmp];
    }
    else
    {
        [self writeUserConfiguration:arrTmp];
    }
    [deletedServerObj release];
    [arrTmp release];
    
    [self loadServerList]; // reload list of servers
    
    if([self.serverList count] == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([self.serverList count] == 1) {
        // If there is the only 1 remaining server: select it automatically
        [self setSelectedServerIndex:0];

    }
    return YES;
}

#pragma mark Utils

//get information given in an url request from the browser, and load to application preference
//the url is in form: exomobile://username=xxx?serverUrl=yyy
//get the username to fill to Authenticate view
//get the server url to save to the server list and set it to be selected
- (void)loadReceivedUrlToPreference:(NSURL *)url
{
    NSString *host = [url host];
    NSString *query = [url query];
    NSString *username = nil, *serverLink = nil;
    
    if([host length] > 0) {
        if([host rangeOfString:USERNAME_EQUALS].location != NSNotFound) {
            username = [host substringFromIndex:[USERNAME_EQUALS length]];
        } else {
            if([host rangeOfString:SERVER_LINK_EQUALS].location != NSNotFound) {
                serverLink = [host substringFromIndex:[SERVER_LINK_EQUALS length]];
            }
        }
    }
    
    if([query length] > 0) {
        if([query rangeOfString:SERVER_LINK_EQUALS].location != NSNotFound) {
            serverLink = [query substringFromIndex:[SERVER_LINK_EQUALS length]];
        } else {
            if([query rangeOfString:USERNAME_EQUALS].location != NSNotFound) {
                username = [query substringFromIndex:[USERNAME_EQUALS length]];
            }
        }
    }
    
    
    //keep the username for later use
    if(username) {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:EXO_CLOUD_USER_NAME_FROM_URL];
    }
        
    if(serverLink) {
        // add server to list and set it to be selected
        [self addAndSetSelectedServer:serverLink withName:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EXO_CLOUD_ACCOUNT_CONFIGURED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)addAndSetSelectedServer:(NSString *)serverLink withName:(NSString *)serverName
{
    NSURL *serverURL = [NSURL URLWithString:serverLink];
    
    if(serverName == nil) {
        serverName = [serverURL host];
    }
    
    int serverIndex = [self checkServerAlreadyExistsWithName:serverName andURL:serverLink ignoringIndex:-1];
    
    if(serverIndex > -1) { //if the server is already exist, just set it to be selected
        [self setSelectedServerIndex:serverIndex];
    } else { //otherwise, add a new server to server list, and set it to be selected
        [self addEditServerWithServerName:serverName andServerUrl:serverLink withUsername:nil andPassword:nil atIndex:-1];
        [self setSelectedServerIndex:[self.serverList count] - 1];
    }
}
@end

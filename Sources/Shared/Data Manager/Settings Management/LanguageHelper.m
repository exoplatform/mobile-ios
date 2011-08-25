//
//  LanguageHelper.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "LanguageHelper.h"
#import "defines.h"


@implementation LanguageHelper (PrivateMethods)

@end



@implementation LanguageHelper


#pragma mark - Object Management
//Singleton Accessor/Creator
+ (LanguageHelper*)sharedInstance
{
	static LanguageHelper *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
			sharedInstance = [[LanguageHelper alloc] init];
		}
		return sharedInstance;
	}
	return sharedInstance;
}


//Initialisation Method
- (id) init
{
    if ((self = [super init])) 
    {
        //Intialisation, load the current dictionnary for localizable strings
        [self loadLocalizableStringsForCurrentLanguage];
    }	
	return self;
}

//Dealloc method
- (void) dealloc
{
	[_dictLocalize release];
	[super dealloc];
}



#pragma mark - Private Methods






#pragma mark - LanguageHelper Methods

- (void)loadLocalizableStringsForCurrentLanguage {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	int selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(selectedLanguage == 0)
	{
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"];
	}	
	else
	{	
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"];
	}
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
}



- (NSString *)getLocalizableStringForKey:(NSString *)key {
    
    NSString* returnString = [_dictLocalize objectForKey:key];
    
    //If the key is not found 
    //Log an error and return the key
    if (returnString == nil) {
        NSLog(@"LANGUAGE ERROR ---> key \"%@\" not found",key);
        returnString = key;
    }
    
    return returnString;
}


- (void)changeToLanguage:(int)languageWanted {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", languageWanted] forKey:EXO_PREFERENCE_LANGUAGE];
	//Need to reload new dictionnary
    [self loadLocalizableStringsForCurrentLanguage];
}


- (int)getSelectedLanguage {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	return [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
}

@end

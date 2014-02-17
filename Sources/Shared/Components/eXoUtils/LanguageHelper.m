//
//  LanguageHelper.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "LanguageHelper.h"
#import "defines.h"


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
        _international = [[[NSArray alloc] initWithObjects:@"en", @"fr", @"de", @"es-ES", nil] retain];
        //Intialisation, load the current dictionnary for localizable strings
        [self loadLocalizableStringsForCurrentLanguage];
    }	
	return self;
}

//Dealloc method
- (void) dealloc
{
    [_international release];
	[super dealloc];
}

#pragma mark - LanguageHelper Methods

- (void)loadLocalizableStringsForCurrentLanguage {
    [self changeToLanguage:[self getSelectedLanguage]];
}

- (void)changeToLanguage:(int)languageWanted {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", languageWanted] forKey:EXO_PREFERENCE_LANGUAGE];
	LocalizationSetLanguage([_international objectAtIndex:languageWanted]);
    
}


- (int)getSelectedLanguage {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedLang = [userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE];
	return selectedLang ? [selectedLang intValue] : 0;
}

@end

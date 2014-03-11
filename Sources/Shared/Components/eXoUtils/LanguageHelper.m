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
    // returns the 2-letter language code of the device
    NSString * language = [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
    // we defined es-ES in our bundle so we must check this lang-region exactly
    if ([@"es" isEqualToString:language]) language = @"es-ES";
    // returns the index of the language or NSNotFound
    int langIndex = [_international indexOfObject:language];
    // if the preferred language is not supported by the app, fallback to English
    if (langIndex == NSNotFound) langIndex = 0;
    // set the language
    [self changeToLanguage:langIndex];
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

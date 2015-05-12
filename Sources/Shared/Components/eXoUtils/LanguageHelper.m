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

#import "LanguageHelper.h"
#import "defines.h"


@implementation LanguageHelper

@synthesize international;

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
- (instancetype) init
{
    if ((self = [super init])) 
    {
        self.international = [[[NSArray alloc] initWithObjects:@"en", @"fr", @"de", @"es-ES", @"pt-BR", nil] autorelease];
        //Intialisation, load the current dictionnary for localizable strings
        [self loadLocalizableStringsForCurrentLanguage];
    }	
	return self;
}

//Dealloc method
- (void) dealloc
{
    self.international = nil;
	[super dealloc];
}

#pragma mark - LanguageHelper Methods

- (void)loadLocalizableStringsForCurrentLanguage {

    // returns the lang in preferences, or nil
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedLang = [userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE];
    int langIndex = (selectedLang) ? [selectedLang intValue] : 0;
    
    if (!selectedLang) {
        // returns the 2-letter language code of the device
        NSString * language = [[NSLocale preferredLanguages][0] substringToIndex:2];
        // we defined some Country+Region codes in our array so we must check these explicitely
        if ([@"es" isEqualToString:language]) language = @"es-ES";
        else if ([@"pt" isEqualToString:language]) language = @"pt-BR";
        // returns the index of the language or NSNotFound
        langIndex = [self.international indexOfObject:language];
        // if the preferred language is not supported by the app, fallback to English
        if (langIndex == NSNotFound) langIndex = 0;
    }
    // set the language
    [self changeToLanguage:langIndex];
}

- (void)changeToLanguage:(int)languageWanted {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", languageWanted] forKey:EXO_PREFERENCE_LANGUAGE];
	LocalizationSetLanguage(self.international[languageWanted]);
    
}


- (int)getSelectedLanguage {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *selectedLang = [userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE];
	return selectedLang ? [selectedLang intValue] : 0;
}

@end

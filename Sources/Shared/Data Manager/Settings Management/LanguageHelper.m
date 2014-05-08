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

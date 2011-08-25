//
//  LanguageHelper.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//Define a macro for faster coding Localizable
#define Localize(_str) [[LanguageHelper sharedInstance]getLocalizableStringForKey:_str]



@interface LanguageHelper : NSObject {
    
    NSDictionary* _dictLocalize;	//Language dictionary
    
}


+ (LanguageHelper *)sharedInstance;
- (void)loadLocalizableStringsForCurrentLanguage;
- (NSString *)getLocalizableStringForKey:(NSString *)key;
- (void)changeToLanguage:(int)languageWanted;
- (int)getSelectedLanguage;

@end

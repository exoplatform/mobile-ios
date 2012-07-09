//
//  LanguageHelper.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalizationSystem.h"

//Define a macro for faster coding Localizable
#define Localize(key) AMLocalizedString(key, @"")

@interface LanguageHelper : NSObject {
    // The international map which contains "English", "French" consequently
    NSArray* _international;
}


+ (LanguageHelper *)sharedInstance;
- (void)loadLocalizableStringsForCurrentLanguage;
- (void)changeToLanguage:(int)languageWanted;
- (int)getSelectedLanguage;

@end

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


#import <XCTest/XCTest.h>
#import "ExoTestCase.h"
#import "LanguageHelper.h"
#import "defines.h"

@interface LanguageHelperTestCase : ExoTestCase {

    LanguageHelper *langHelper;
    NSUserDefaults *userSettings;
}
@end

@implementation LanguageHelperTestCase

- (void)setUp
{
    [super setUp];
    langHelper = [LanguageHelper sharedInstance];
    [self deletePreferences];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)deletePreferences
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EXO_PREFERENCE_LANGUAGE];
}

- (void)setDeviceLanguage:(NSString*)lang
{
    NSArray *langOrder = [NSArray arrayWithObjects:lang, nil];
    [[NSUserDefaults standardUserDefaults] setObject:langOrder forKey:@"AppleLanguages"];
}

- (NSString*)languageCodeAtPosition:(int) pos
{
    // based on the array of supported languages in LanguageHelper.m
    NSArray *langs = [NSArray arrayWithObjects:@"en", @"fr", @"de", @"es-ES", nil];
    if (pos >= 0 && pos < [langs count])
        return [langs objectAtIndex:pos];
    else
        return @"en";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self deletePreferences];
    [self setDeviceLanguage:@"en"];
    [super tearDown];
}

- (void)testFrenchLanguageIsUsed
{
    NSString *expectedLang = @"fr";
    [self setDeviceLanguage:expectedLang];
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    
    NSString *selectedLang = [self languageCodeAtPosition:[langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Selected language should be French");
    XCTAssertEqualObjects(Localize(@"UsernamePlaceholder"), @"Utilisateur", @"Username in French should be Utilisateur");
}

- (void)testGermanLanguageIsUsed
{
    NSString *expectedLang = @"de";
    [self setDeviceLanguage:expectedLang];
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    NSString *selectedLang = [self languageCodeAtPosition:[langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Selected language should be German");
    XCTAssertEqualObjects(Localize(@"UsernamePlaceholder"), @"Benutzername", @"Username in German should be Benutzername");
}

- (void)testSpanishLanguageIsUsed
{
    NSString *expectedLang = @"es-ES";
    [self setDeviceLanguage:expectedLang];
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    NSString *selectedLang = [self languageCodeAtPosition:[langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Selected language should be Spanish");
    XCTAssertEqualObjects(Localize(@"UsernamePlaceholder"), @"Nombre de usuario", @"Username in Spanish should be Nombre de usuario");
}

- (void)testEnglishLanguageIsUsed
{
    NSString *expectedLang = @"en";
    [self setDeviceLanguage:expectedLang];
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    NSString *selectedLang = [self languageCodeAtPosition:[langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Selected language should be English");
    XCTAssertEqualObjects(Localize(@"UsernamePlaceholder"), @"Username", @"Username in English should be Username");
}

- (void)testEnglishLanguageIsUsedByDefault
{
    NSString *expectedLang = @"en"; // Should default to English
    [self setDeviceLanguage:@"ja"]; // because Japanese is not supported
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    NSString *selectedLang = [self languageCodeAtPosition:[langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Default language should be English");
}

- (void)testSelectedLanguageIsUsed
{
    NSString *expectedLang = @"1"; // Save French as the selected language
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:expectedLang forKey:EXO_PREFERENCE_LANGUAGE];
    
    [self setDeviceLanguage:@"en"]; // Set the device in English
    
    [langHelper loadLocalizableStringsForCurrentLanguage];
    NSString *selectedLang = [NSString stringWithFormat:@"%d", [langHelper getSelectedLanguage]];
    
    XCTAssertEqualObjects(selectedLang, expectedLang, @"Selected language should be French although device is in English");
}

@end

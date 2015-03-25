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


#import "AccountInfoUtils.h"
#import "CloudUtils.h"
#import "LanguageHelper.h"
#import "URLAnalyzer.h"

@implementation AccountInfoUtils

/*!
 * Checks the presence of certain characters in a string
 * @returns true if the given string contains one or more of the given characters
 */
+ (BOOL)stringContainsSpecialCharacter:(NSString*)str inSet:(NSString *)chars
{
    
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    NSRange range = [str rangeOfCharacterFromSet:invalidCharSet];
    return (range.length > 0);
    
}

/*!
 * Checks if the account name is valid.
 * A name should only contain alphanumeric characters and spaces.
 * @returns true if the given name is valid
 */
+ (BOOL)accountNameIsValid:(NSString*)name
{
    // periods, dashes, parentheses, and so on
    NSRange rangePunct = [name rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
    // for example, the dollar sign ($) and the plus (+) sign.
    NSRange rangeSymb = [name rangeOfCharacterFromSet:[NSCharacterSet symbolCharacterSet]];
    
    return (rangePunct.length == 0 && rangeSymb.length == 0);
}

/*!
 * Checks if the username is valid.
 * Only alphanumeric characters and - _ . are allowed.
 * @returns true if the given username is valid
 */
+ (BOOL)usernameIsValid:(NSString *)username
{
    NSString* forbiddenChars = @"`~!@#$%^&*()={}[]|\\:;\"'<>,?/ ";
    return (![self stringContainsSpecialCharacter:username inSet:forbiddenChars]);
}

/*!
 Extracts an account name from a URL.
 If the URL is an eXo Cloud URL, the name will be the tenant name extracted by
 CloudUtils.tenantFromServerUrl.
 If the URL is a normal URL, the name will be the first part of the FQDN.
 Examples:

 - http://mycompany.com => Mycompany
 
 - http://int.mycompany.com => Int
 
 - http://int.my.cool.company => Int
 
 @returns a name for the account based on the given URL
 @returns the localization of "My intranet" if no name could be extracted
 @returns the IP address if the given URL is an IP address
 */
+ (NSString*)extractAccountNameFromURL:(NSString *)strUrl
{
    NSString* name = nil;
    // Check if the URL is an eXo Cloud URL
    NSRange cloudHostRange = [strUrl rangeOfString:EXO_CLOUD_HOST];
    if(cloudHostRange.location != NSNotFound) {
        // if yes, get the tenant name from the CloudUtils method
        name = [CloudUtils tenantFromServerUrl:strUrl];
    } else {
        // if not, extract the domain part of the url's host
        NSURL* urlURL = [NSURL URLWithString:strUrl];
        if (urlURL != nil) {
            if ([URLAnalyzer isIPAddress:urlURL.absoluteString]) {
                name = urlURL.host;
            } else {
                NSArray* elements = [urlURL.host componentsSeparatedByString:@"."];
                name = elements[0];
            }
        }
    }
    if (name == nil) name = Localize(@"My intranet");
    return [name capitalizedString];
}


@end

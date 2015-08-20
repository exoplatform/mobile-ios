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

#import "CloudUtils.h"
#import "defines.h"
@implementation CloudUtils

// check if a given mail is in correct format

+ (BOOL)checkEmailFormat:(NSString *)mail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]{2,}\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:mail];
}


+ (NSString *)usernameByEmail:(NSString *)email
{
    return [email substringToIndex:[email rangeOfString:@"@"].location];
}

+ (NSString *)serverUrlByTenant:(NSString *)tenantName
{
    return  [NSString stringWithFormat:@"https://%@.%@",tenantName, EXO_CLOUD_HOST];
}

//gets the tenant name from server url, returns nil if not exist
//the cloud tenant is in form: https://abc.uxpacc02.exoplatform.org
//so if the url contains cloud host (exoplatform.net), returns 'abc' as tenant name
+ (NSString *)tenantFromServerUrl:(NSString *)serverUrl
{
    NSRange cloudHostRange = [serverUrl rangeOfString:EXO_CLOUD_HOST];
        
    if(cloudHostRange.location == NSNotFound) {
        return nil;
    }
    
    NSString *prefix = @"http://";
    
    if([serverUrl hasPrefix:@"https"]) {
        prefix = @"https://";
    }
    
    if(cloudHostRange.location - [prefix length] > 0) {
        NSRange range = NSMakeRange([prefix length], cloudHostRange.location - [prefix length] - 1);
        return [serverUrl substringWithRange:range];
    }
    return nil;
}
@end

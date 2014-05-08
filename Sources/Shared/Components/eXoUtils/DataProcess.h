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

#import <Foundation/Foundation.h>

//Process data
@interface DataProcess : NSObject {

}

//Singleton constructor
+ (id)instance;
+ (id)newInstance;

+ (NSMutableArray*)parseData:(NSData*)data;	//Parsing data
+ (NSString *)decodeUrl:(NSString *)urlString;	//Decode URL

- (NSString*)escapeString:(NSString*)str withEncoding:(NSStringEncoding)encoding;	//Replace some spacial charactors
- (NSData*)formatDictData:(NSDictionary*)dictData WithEncoding:(NSStringEncoding)encoding;	//Get data from dictionary

@end

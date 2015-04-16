//
// Copyright (C) 2003-2015 eXo Platform SAS.
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


#import "SocialProxy.h"
#import "SocialSpace.h"
@interface SocialSpaceProxy : SocialProxy {
    NSArray*                    _mySpaces;
}
@property (nonatomic,retain) NSArray * mySpaces;


/*!
 
 @return The list of all user's spaces.
 
 @discussion The REST reponse with a list of spaces in JSON. Each space have: Remote Id (or Name), Display Name, URL, Avatar URL,..  But the Identity. To get the Identity of a space, use the method:@method getIdentifyOfSpace:space
 */
-(void) getMySocialSpaces;

/*!
 @return A space with the attribute Identity is filled.
 @param space: The space with no information about it's identity.
 @discussion the @method getMySocialSpaces return a list of spaces but each space doen't have the identity attribut. Use this method to get that information.
 */
-(void) getIdentifyOfSpace:(SocialSpace *) space;

@end

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


#import "SocialSpace.h"

@implementation SocialSpace


-(void) dealloc {
    [_avatarUrl release];
    [_groupId release];
    [_spaceId release];
    [_name release];
    [_displayName release];
    [_url release];
    [_spaceId release];
    [super dealloc];
}
-(NSString *) description {
    return [NSString stringWithFormat:@"[name : %@] [url : %@] [id : %@]", _name, _url, _spaceId];
}

@end

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

#import "SocialPictureAttach.h"


@implementation SocialPictureAttach

@synthesize docPath = _docPath;
@synthesize message = _message;
@synthesize docLink = _docLink;
@synthesize workspace = _workspace;
@synthesize repository = _repository;
@synthesize docName = _docName;

- (NSString *)description
{
    return [NSString stringWithFormat:@"-%@, %@, %@, %@, %@, %@",
            _docPath?_docPath:@"",
            _message?_message:@"",
            _docLink?_docLink:@"",
            _workspace?_workspace:@"",
            _repository?_repository:@"",
            _docName?_docName:@""];
}

@end

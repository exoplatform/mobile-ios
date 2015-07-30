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


#import "PostActivity.h"

@implementation PostActivity


-(id) init {
    self = [super init];
    if (self){
        self.items = [[NSMutableArray alloc] init];
        self.successfulUploads = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Doc activity

-(NSString *) getMessageError {
    BOOL fileTooLarge = NO;
    BOOL networkError = NO;
    for (PostItem * item in self.items){
        if (item.uploadStatus == eXoItemStatusUploadFileTooLarge){
            fileTooLarge = YES;
        } else if  (item.uploadStatus == eXoItemStatusUploadFailed){
            networkError = YES;
        }
    }
    if (fileTooLarge && networkError){
        return [NSString stringWithFormat:@"%@ \n %@ \n %@", NSLocalizedString(@"File too large", nil),NSLocalizedString(@"Network error", nil),NSLocalizedString(@"Do you want to post the message anyway?", nil)];
    } else if (fileTooLarge) {
        return [NSString stringWithFormat:@"%@. %@", NSLocalizedString(@"File too large", nil),NSLocalizedString(@"Do you want to post the message anyway", nil)];
    } else {
        return [NSString stringWithFormat:@"%@. %@", NSLocalizedString(@"Network error", nil),NSLocalizedString(@"Do you want to post the message anyway", nil)];
    }
}



@end

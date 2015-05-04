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

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityLinkTableViewCell : ActivityBasicTableViewCell {
 
    EGOImageView*          _imgvAttach;
    CGFloat width;
}
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@property (retain) IBOutlet EGOImageView* imgvAttach;

@property (retain, nonatomic) IBOutlet UILabel *htmlActivityMessage;
@property (retain, nonatomic) IBOutlet UILabel *htmlLinkTitle;
@property (retain, nonatomic) IBOutlet UILabel *htmlLinkDescription;
@property (retain, nonatomic) IBOutlet UILabel *htmlLinkMessage;

@property (retain, nonatomic) TTStyledTextLabel* htmlName;


@end

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

#import "EmptyView.h"


@implementation EmptyView

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName andContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        // Initialization code
        //add empty image to the view
        imagename = imageName;
        UIImage *image = [UIImage imageNamed:imageName];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:imageView];
        
        
        distance = 0;
        if([imageName isEqualToString:@"IconForEmptyFolder.png"]){
            distance = 80;
        } else if([imageName isEqualToString:@"IconForNoActivities.png"]){
            distance = 110;
        } else if([imageName isEqualToString:@"IconForNoContact.png"]){
            distance = 120;
        } else if([imageName isEqualToString:@"IconForNoGadgets.png"]){
            distance = 110;
        } else if([imageName isEqualToString:@"IconForUnreadableFile.png"]){
            distance = 110;
        }
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + distance, frame.size.width, 40)];
        label.backgroundColor = [UIColor clearColor];//
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:112./255 green:112./255 blue:112./255 alpha:1.];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        label.text = content;
        label.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    imageView.frame = CGRectMake(frame.size.width/2 - imageView.image.size.width/2, frame.size.height/2 - imageView.image.size.height/2 - 20, imageView.image.size.width, imageView.image.size.height);
    label.frame = CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height + distance, frame.size.width, 40);
}

- (void)changeOrientation{
    UIImage *image = [UIImage imageNamed:imagename];
    imageView.frame = CGRectMake(self.frame.size.width/2 - image.size.width/2, self.frame.size.height/2 - image.size.height/2 - 20, image.size.width, image.size.height);
    label.frame = CGRectMake(0, self.frame.size.height/2 - image.size.height/2 + distance, self.frame.size.width, 40);
}

- (void)setLabelContent:(NSString*)content {
    label.text = content;
}

- (void)dealloc
{
    [label release];
    [imageView release];
    [imagename release];
    [super dealloc];
}

@end

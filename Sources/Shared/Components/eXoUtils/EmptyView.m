//
//  EmptyView.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmptyView.h"


@implementation EmptyView

- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName andContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //add empty image to the view
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(frame.size.width/2 - image.size.width/2, frame.size.height/2 - image.size.height/2 - 20, image.size.width, image.size.height);
        [self addSubview:imageView];
        [imageView release];
        
        NSInteger distance = 0;
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - image.size.height/2 + distance, frame.size.width, 40)];
        label.backgroundColor = [UIColor clearColor];//
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        label.text = content;
        [self addSubview:label];
        [label release];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end

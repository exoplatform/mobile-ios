//
//  MenuHeaderView.h
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHeaderView : UIView
{
	UIImageView *imageView;
	UILabel *textLabel;
}
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *textLabel;
@end

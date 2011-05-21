//
//  MenuWatermarkFooter.h
//  StackScrollView
//
//  Created by Aaron Brethorst on 5/15/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuWatermarkFooter : UIView
{
    
    //The button to show settings of the eXo Applications.
    UIButton *_buttonForSettings; 
    
}

@property (nonatomic, retain) UIButton *buttonForSettings;

@end

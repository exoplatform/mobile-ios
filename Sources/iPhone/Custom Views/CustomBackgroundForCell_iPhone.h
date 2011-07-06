//
//  CustomBackgroundForCell_iPhone.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	CustomCellBackgroundViewPositionTop, 
	CustomCellBackgroundViewPositionMiddle, 
	CustomCellBackgroundViewPositionBottom,
	CustomCellBackgroundViewPositionSingle
} CustomCellBackgroundViewPosition;


@interface CustomBackgroundForCell_iPhone : UITableViewCell {
	CustomCellBackgroundViewPosition position_;
}

-(void)setBackgroundForRow:(int)rowIndex inSectionSize:(int)numberOfRowInSection;

-(void)setBackgroundForPosition:(CustomCellBackgroundViewPosition)position;

@property(nonatomic) CustomCellBackgroundViewPosition position;
@end

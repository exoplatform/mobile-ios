//
//  DisplayCell.h
//  TalkingBook
//
//  Created by Tran Hoai Son on 12/13/08.
//  Copyright 2008 Novellus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight	25.0
// table view cell content offsets
#define kCellLeftOffset			8.0
#define kCellTopOffset			12.0
#define kPageControlHeight		20.0
#define kPageControlWidth		160.0
#define kSwitchButtonWidth		94.0
#define kSwitchButtonHeight		27.0

// cell identifier for this custom cell
extern NSString *kDisplayCell_ID;

@interface DisplayCell : UITableViewCell
{
	UILabel	*nameLabel;
	UIView	*view;
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) UILabel *nameLabel;

- (void)setView:(UIView *)inView;

@end

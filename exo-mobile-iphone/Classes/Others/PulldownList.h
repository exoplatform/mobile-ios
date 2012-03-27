//
//  PulldownList.h
//  CustomControl
//
//  Created by Le van Thang on 10/2/08.
//  Copyright 2008 AVASYS Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PulldownList : UIButton <UITableViewDataSource, UITableViewDelegate>
{
	UITableView*	myTableView;
	NSArray*		_list;
	UIImageView* scrollIndicator;
}

@property(nonatomic, retain) UITableView*	myTableView;
@property(nonatomic, retain) UIImageView*	scrollIndicator;

- (NSString*)nameOfselectedRow;
- (void) selectRow: (NSInteger) row;
- (NSInteger) selectedRow;

@end

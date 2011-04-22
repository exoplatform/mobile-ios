//
//  ContainerCell.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/31/11.
//  Copyright 2011 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContainerCell : UITableViewCell
{
	UIView*	_vContainer;
}
- (void)attachContainer:(UIView*)view;
@end
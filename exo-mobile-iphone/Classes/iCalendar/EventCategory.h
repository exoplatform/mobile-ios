//
//  EventCategory.h
//  eXoApp
//
//  Created by exo on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventCategory : UITableViewController {
	int type;
	int selectedItem;
	NSArray *categoryArr;
}

@property int type;
@property int selectedItem;

@end

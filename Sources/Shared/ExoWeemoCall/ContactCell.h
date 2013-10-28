//
//  ContactCell.h
//  eXo Platform
//
//  Created by vietnq on 10/28/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *avatar;
@property (nonatomic, retain) IBOutlet UILabel *lb_full_name;
@property (nonatomic, retain) IBOutlet UILabel *lb_username;
@end

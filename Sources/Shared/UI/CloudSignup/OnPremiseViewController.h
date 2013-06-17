//
//  OnPremiseViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/17/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnPremiseViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITextField *serverUrlTf;
@property (nonatomic, retain) IBOutlet UITextField *usernameTf;
@property (nonatomic, retain) IBOutlet UITextField *passwordTf;

- (IBAction)login:(id)sender;
@end

//
//  AlreadyAccountViewController.h
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlreadyAccountViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITextField *emailTf;
@property (nonatomic, retain) IBOutlet UITextField *passwordTf;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;

- (IBAction)cancel:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)connectToOnPremise:(id)sender;
@end

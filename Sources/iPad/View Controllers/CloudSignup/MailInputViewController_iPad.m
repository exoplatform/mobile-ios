//
//  MailInputViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 7/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "MailInputViewController_iPad.h"

@interface MailInputViewController_iPad ()

@end

@implementation MailInputViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboards
{
    [super dismissKeyboards];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end

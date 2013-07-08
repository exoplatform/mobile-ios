//
//  eXoNavigationController.m
//  eXo Platform
//
//  Created by vietnq on 7/8/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "eXoNavigationController.h"

@interface eXoNavigationController ()

@end

@implementation eXoNavigationController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override this method to fix the bug of cannot hide keyboard
//see more in the header file
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}
@end

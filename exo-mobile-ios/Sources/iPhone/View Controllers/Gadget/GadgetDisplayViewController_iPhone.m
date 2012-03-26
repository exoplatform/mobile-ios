//
//  GadgetDisplayViewController_iPhone.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/13/09.
//  Copyright 2009 home. All rights reserved.
//

#import "GadgetDisplayViewController_iPhone.h"
#import "JTNavigationView.h"


@implementation GadgetDisplayViewController_iPhone

// custom init method
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad	
{
	if (self = [super initWithNibAndUrl:nibName bundle:nibBundle gadget:gadgetToLoad]) {
        
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
}

@end
//
//  DocumentDisplayViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentDisplayViewController_iPhone.h"
#import "JTNavigationView.h"
#import "AppDelegate_iPhone.h"



@implementation DocumentDisplayViewController_iPhone


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.title = [self shortString:self.title withMaxCharacter:15];
}



@end

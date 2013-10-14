//
//  PeopleViewController_iPad.m
//  eXo Platform
//
//  Created by vietnq on 10/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "PeopleViewController_iPad.h"
#import "RoundRectView.h"

@interface PeopleViewController_iPad ()

@end

@implementation PeopleViewController_iPad

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
    ((RoundRectView *) [[self.view subviews] objectAtIndex:0]).squareCorners = NO;
    
    //TODO : Localize
    _navigation.topItem.title = @"People";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  eXoTableViewController.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoTableViewController.h"


@implementation eXoTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType rangeOfString:@"iPhone"].length > 0){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 40)];
    }
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor grayColor];
    
    _navigation.topItem.titleView = label;
    self.navigationItem.titleView = label;
}

-(void)setTitle:(NSString *)_titleView {
    [super setTitle:_titleView];
    label.text = _titleView;
}

-(void)dealloc {
    [super dealloc];
    [label release];
}

@end

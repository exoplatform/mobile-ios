//
//  eXoViewController.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoViewController.h"

@implementation eXoViewController

#define TAG_TITLE 100

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType rangeOfString:@"iPhone"].length > 0){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 40)];
    }
    label.tag = TAG_TITLE;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end

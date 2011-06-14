//
//  ActivityBasicCellViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityBasicCellViewController.h"
#import "MockSocial_Activity.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityBasicCellViewController



- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imgvMessageBg setImage:[[UIImage imageNamed:@"bgMessageActivityStreamCell.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:45]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setActivity:(Activity*)activity
{
    _imgvAvatar.imageURL = [NSURL URLWithString:activity.avatarUrl];
    [[_imgvAvatar layer] setCornerRadius:10.0];
    [[_imgvAvatar layer] setMasksToBounds:YES];
    [[_imgvAvatar layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_imgvAvatar layer] setBorderWidth:2.0];
    
    _lbMessage.text = [activity.title copy];
}
@end

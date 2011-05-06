//
//  FilesViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "FilesViewController_iPad.h"

#import "Three20UI/UINSStringAdditions.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

// UI
#import "Three20UI/TTNavigator.h"

// UINavigator
#import "Three20UINavigator/TTURLAction.h"
#import "Three20UINavigator/TTURLMap.h"
#import "Three20UINavigator/TTURLObject.h"


@implementation FilesViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Documents";
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)loadView 
{
    [super loadView];
//    [super loadView];
//    _filesViewController = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
//    [_filesViewController setDelegate:self];
//    [_filesViewController initWithRootDirectory];
//	[_filesViewController getPersonalDriveContent:_filesViewController._currenteXoFile];
//    [self.view addSubview:_filesViewController.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [self.view setFrame:CGRectMake(0, 0, 768, 960)];
	}
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{
        [self.view setFrame:CGRectMake(0, 0, 1024, 704)];
	}
    
    [self didRotateFromInterfaceOrientation:interfaceOrientation];
    return YES;
}

@end

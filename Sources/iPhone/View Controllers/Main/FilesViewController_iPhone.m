//
//  FilesViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "FilesViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "eXoApplicationsViewController.h"


@implementation FilesViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Documents";
        
        //HACK
        self.view = [AppDelegate_iPhone instance].applicationsViewController._filesView;
        
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
}

@end

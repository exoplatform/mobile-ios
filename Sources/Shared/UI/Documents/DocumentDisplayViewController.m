//
//  DocumentDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentDisplayViewController.h"


@implementation DocumentDisplayViewController

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName
{
	if(self = [super initWithNibName:nibName bundle:nibBundle]){
        _url = [defaultURL retain];
        _fileName = [fileName retain];
    }
    
	return self;
}

#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _fileName;
}

- (void)showLoader {
    [self setHudPosition];
    [_hudView setCaption:[NSString stringWithFormat:@"%@: %@", Localize(@"LoadingDocument"), _fileName]];
    [_hudView setActivity:YES];
    [_hudView show];
}


@end

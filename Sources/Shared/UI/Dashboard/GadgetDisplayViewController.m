//
//  GadgetDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "GadgetDisplayViewController.h"
#import "GadgetItem.h"
#import "AuthenticateProxy.h"
#import "EmptyView.h"
#import "LanguageHelper.h"

@interface GadgetDisplayViewController (PrivateMethods)
@end



@implementation GadgetDisplayViewController

@synthesize gadget = _gadget;

- (void)dealloc {
    [_gadget release];
    [super dealloc];
}

// custom init method
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad	
{
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        [self setGadget:gadgetToLoad];
        _url = [[NSURL URLWithString:_gadget.gadgetUrl] retain];
	}
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //Set the title of the controller
    self.title = _gadget.gadgetName;
}


@end
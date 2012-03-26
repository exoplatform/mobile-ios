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
- (void)showLoader;
- (void)hideLoader;
@end



@implementation GadgetDisplayViewController

@synthesize gadget = _gadget;
//@synthesize _webView;

// custom init method
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad	
{
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        [self setGadget:gadgetToLoad];
        _url = [NSURL URLWithString:[_gadget.gadgetUrl retain]];
	}
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //Set the title of the controller
    self.title = _gadget.gadgetName;
}


- (void)setGadget:(GadgetItem *)gadgetToLoad
{
	_gadget = [gadgetToLoad retain];    
}


#pragma mark - Loader Management
- (void)setHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)showLoader {
    [self setHudPosition];
    [_hudView setCaption:[NSString stringWithFormat:@"%@ %@", Localize(@"LoadingGadget"), _gadget.gadgetName]];
    [_hudView setActivity:YES];
    [_hudView show];
}



@end
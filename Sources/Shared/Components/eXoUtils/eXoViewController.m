//
//  eXoViewController.m
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "eXoViewController.h"
#import "LanguageHelper.h"

@implementation eXoViewController

@synthesize hudLoadWaiting = _hudLoadWaiting;

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
}
/*
-(void)setTitle:(NSString *)_titleView {
    [super setTitle:_titleView];
    label.text = _titleView;
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


-(void)dealloc {
    [_hudLoadWaiting release];
    [super dealloc];
    //[label release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [_hudLoadWaiting release];
    _hudLoadWaiting = nil;
    [super didReceiveMemoryWarning];
}

#pragma mark - hudLoadWaiting
- (ATMHud *)hudLoadWaiting {
    // lazy loading
    if (!_hudLoadWaiting) {
        _hudLoadWaiting = [[ATMHud alloc] initWithDelegate:nil];
        // disable user interaction during the loading.
        [_hudLoadWaiting setAllowSuperviewInteraction:NO];
    }
    return _hudLoadWaiting;
}

- (void)updateHudPosition {
    // default implementation
}

- (ATMHud *)hudLoadWaitingWithPositionUpdated {
    ATMHud *hudLoad = [self hudLoadWaiting];
    [self updateHudPosition];
    return hudLoad;
}

- (void)displayHudLoader {
    [self displayHUDLoaderWithMessage:Localize(@"Loading")];
}

- (void)displayHUDLoaderWithMessage:(NSString *)message {
    [self.hudLoadWaitingWithPositionUpdated setCaption:message];
    [self.hudLoadWaiting setActivity:YES];
    [self.hudLoadWaiting show];
}

- (void)hideLoader:(BOOL)successful {
    [self.hudLoadWaitingWithPositionUpdated setActivity:NO];
    if (successful) {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"19-check"]];
        [self.hudLoadWaiting setCaption:Localize(@"Success")];
        [self.hudLoadWaiting hideAfter:0.5];
    } else {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"11-x"]];
        [self.hudLoadWaiting setCaption:Localize(@"Error")];
        [self.hudLoadWaiting hideAfter:1.0];
    }
    [self.hudLoadWaiting update];
}

- (void)hideLoaderImmediately:(BOOL)successful {
    [self.hudLoadWaitingWithPositionUpdated setActivity:NO];
    if (successful) {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"19-check"]];
        [self.hudLoadWaiting setCaption:Localize(@"Success")];
    } else {
        [self.hudLoadWaiting setImage:[UIImage imageNamed:@"11-x"]];
        [self.hudLoadWaiting setCaption:Localize(@"Error")];
    }
    [self.hudLoadWaiting hide];
}

#pragma mark - change language management
- (void) updateLabelsWithNewLanguage {
    // Nothing here.
    // This method is overriden in subclasses where labels have
    // to be updated when the language changes.
    // E.g. ActivityStreamBrowseViewController.m
}

@end

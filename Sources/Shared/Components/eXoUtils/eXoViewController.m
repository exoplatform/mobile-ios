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
    
    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    iv.frame = self.view.frame;
    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [self.view insertSubview:iv atIndex:0];
    [iv release];
        
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 40)];
    } else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    }
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    
    label.shadowOffset = CGSizeMake(0,1);
    label.shadowColor = [UIColor grayColor];
    
    _navigation.topItem.titleView = label;
    self.navigationItem.titleView = label;*/
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
        _hudLoadWaiting = [[ATMHud alloc] initWithDelegate:self];
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

@end

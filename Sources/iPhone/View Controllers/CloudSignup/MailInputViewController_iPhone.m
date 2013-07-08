//
//  MailInputViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/14/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "MailInputViewController_iPhone.h"

@interface MailInputViewController_iPhone ()

@end

@implementation MailInputViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Notifies when the keyboard is shown/hidden
    // Selector must be implemented in _iPhone and _iPad subclasses
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidHideNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)manageKeyboard:(NSNotification *) notif {
    if (notif.name == UIKeyboardDidShowNotification) {
        [self setViewMovedUp:YES];
    } else if (notif.name == UIKeyboardDidHideNotification) {
        [self setViewMovedUp:NO];
    }
}

#pragma mark Keyboard management
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect viewRect = self.view.frame;
    if (movedUp)
    {
        viewRect.origin.y -= 50;
    }
    else
    {
        viewRect.origin.y = 0;
    }
    self.view.frame = viewRect;
    [UIView commitAnimations];
}

- (void)dismissKeyboards
{
    [super dismissKeyboards];
}
@end

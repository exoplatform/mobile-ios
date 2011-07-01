//
//  MessageComposerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageComposerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Message Composer";
    
    [_txtvMessageComposer becomeFirstResponder];
    
    [_txtvMessageComposer setBackgroundColor:[UIColor whiteColor]];
	[_txtvMessageComposer setFont:[UIFont boldSystemFontOfSize:13.0]];
	[_txtvMessageComposer setTextAlignment:UITextAlignmentLeft];
	[_txtvMessageComposer setEditable:YES];
	
	[[_txtvMessageComposer layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[_txtvMessageComposer layer] setBorderWidth:1];
	[[_txtvMessageComposer layer] setCornerRadius:8];
	[_txtvMessageComposer setClipsToBounds: YES];
	[_txtvMessageComposer setText:@""];
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

- (IBAction)onBtnSend:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onBtnCancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];    
}

#pragma mark - TextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
@end

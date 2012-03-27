//
//  OptionsViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/30/10.
//  Copyright 2010 home. All rights reserved.
//

#import "OptionsViewController.h"
#import "FilesViewController.h"

@implementation OptionsViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

- (void)setFocusOnTextFieldName
{
	[_txtfNameInput becomeFirstResponder];
}

- (void)setIsNewFolder:(BOOL)isNewFolder {
	_isNewFolder = isNewFolder;
	
}

- (void)setNameInputStr:(NSString *)nameStr {
	_nameInputStr = [nameStr retain];
	[self localize];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	_txtfNameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
	[self localize];
	
	[_indicator stopAnimating];
	_btnOK.hidden = NO;
	_btnCancel.hidden = NO;
	
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_intSelectedLanguage = [_delegate getSelectedLanguage];
	
	if(_isNewFolder) {
		[_lbInstruction setText:[_dictLocalize objectForKey:@"NewFolderTitle"]];
	}
	else {
		[_lbInstruction setText:[_dictLocalize objectForKey:@"RenameTitle"]];
		
	}
		
	[_txtfNameInput setText:_nameInputStr];
	[_btnCancel setTitle:[_dictLocalize objectForKey:@"CancelCopyButton"] forState:UIControlStateNormal];
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (IBAction)onOKBtn:(id)sender
{
	NSString* strName = [_txtfNameInput text];
	
	NSThread* startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];

	[_delegate onOKBtnOptionsView:strName];
	
	[startThread release];
	[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
	
}

-(void)startInProgress
{
	[_indicator startAnimating];
	_btnOK.hidden = YES;
	_btnCancel.hidden = YES;
}

-(void)endProgress
{
	[_txtfNameInput setText:@""];
	[_indicator stopAnimating];
	_btnOK.hidden = NO;
	_btnCancel.hidden = NO;
}


- (IBAction)onCancelBtn:(id)sender
{
	[_delegate onCancelBtnOptionView];
}

@end

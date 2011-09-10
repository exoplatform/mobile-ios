//
//  FileFolderActionsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 01/09/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "FileFolderActionsViewController.h"
#import "LanguageHelper.h"

@implementation FileFolderActionsViewController

@synthesize delegate=_delegate;
@synthesize fileToApplyAction=_fileToApplyAction;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
	}
	return self;
}


- (void)setFocusOnTextFieldName
{
	[_txtfNameInput becomeFirstResponder];
}

- (void)setIsNewFolder:(BOOL)isNewFolder {
	_isNewFolder = isNewFolder;
	
}

- (void)setNameInputStr:(NSString *)nameStr {
    [_txtfNameInput setText:[nameStr copy]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	_txtfNameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	_btnOK.hidden = NO;
	_btnCancel.hidden = NO;
	
    if(_isNewFolder) {
		[_lbInstruction setText:Localize(@"NewFolderTitle")];
	}
	else {
		[_lbInstruction setText:Localize(@"RenameTitle")];
		
	}
    
	[_btnCancel setTitle:Localize(@"CancelCopyButton") forState:UIControlStateNormal];
    
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
    [_lbInstruction release]; _lbInstruction = nil; 
	[_txtfNameInput release]; _txtfNameInput = nil; 
	[_btnOK release]; _btnOK = nil; 
	[_btnCancel release]; _btnCancel = nil; 
    _delegate = nil;
    
    [super dealloc];
}


- (IBAction)onOKBtn:(id)sender
{
	NSString* strName = [_txtfNameInput text];
	strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_isNewFolder) {
        [_delegate createNewFolder:strName];
    } else {
        [_delegate renameFolder:strName forFolder:_fileToApplyAction];
    }    
}


- (IBAction)onCancelBtn:(id)sender
{
	[_delegate cancelFolderActions];
}

@end

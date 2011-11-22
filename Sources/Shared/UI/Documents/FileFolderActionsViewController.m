//
//  FileFolderActionsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 01/09/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "FileFolderActionsViewController.h"
#import "defines.h"

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
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
	_txtfNameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [self updateUI];
    
    [_txtfNameInput becomeFirstResponder];
    
}

#pragma mark TextField methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Only characters in the NSCharacterSet you choose will insertable.
    NSCharacterSet *invalidCharSet = nil;
    
  
    invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR_NAME_SET] invertedSet];
  
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if(string && [string length] > 0)
        return ![string isEqualToString:filtered];
    
    return YES;
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
	[_txtfNameInput release]; _txtfNameInput = nil; 

    _delegate = nil;
    
    [super dealloc];
}

- (void)updateUI {
    
}

@end

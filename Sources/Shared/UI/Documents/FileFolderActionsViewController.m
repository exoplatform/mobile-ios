//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "FileFolderActionsViewController.h"
#import "defines.h"

@implementation FileFolderActionsViewController

@synthesize delegate=_delegate;
@synthesize fileToApplyAction=_fileToApplyAction;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
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
    
    _navigation.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    _navigation.tintColor = [UIColor whiteColor];
    
    //Set the background Color of the view
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    
	_txtfNameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [self updateUI];
    
    [_txtfNameInput becomeFirstResponder];
    
    
}
/*
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
*/
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

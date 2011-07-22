//
//  MessageComposerViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SocialPostActivity.h"
#import "SocialPostCommentProxy.h"
#import "ActivityStreamBrowseViewController.h"

@implementation MessageComposerViewController

@synthesize _isPostMessage, _strActivityID, _delegate, _tblvActivityDetail;

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
    UIImage *strechBg = [[UIImage imageNamed:@"SocialActivityDetailCommentBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [_imgvBackground setImage:strechBg];
    
    UIImage *strechTextViewBg = [[UIImage imageNamed:@"MessageComposerTextfieldBackground.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:50];
    [_imgvTextViewBg setImage:strechTextViewBg];
    
    UIImage *strechSendBg = [[UIImage imageNamed:@"MessageComposerButtonSendBackground.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
    
    UIImage *strechSendBgSelected = [[UIImage imageNamed:@"MessageComposerButtonSendBackgroundSelected.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
    
    [_btnSend setBackgroundImage:strechSendBg forState:UIControlStateNormal];
    [_btnSend setBackgroundImage:strechSendBgSelected forState:UIControlStateHighlighted];
    
    
    UIImage *strechCancelBg = [[UIImage imageNamed:@"MessageComposerButtonCancelBackground.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
    
    UIImage *strechCancelBgSelected = [[UIImage imageNamed:@"MessageComposerButtonCancelBackgroundSelected.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:13];
    
    [_btnCancel setBackgroundImage:strechCancelBg forState:UIControlStateNormal];
    [_btnCancel setBackgroundImage:strechCancelBgSelected forState:UIControlStateHighlighted];
    
    
    
    [_txtvMessageComposer becomeFirstResponder];
    [_txtvMessageComposer setBackgroundColor:[UIColor clearColor]];
    [_txtvMessageComposer setText:@""];
    
    
    /*
    [_txtvMessageComposer setBackgroundColor:[UIColor whiteColor]];
	[_txtvMessageComposer setFont:[UIFont boldSystemFontOfSize:13.0]];
	[_txtvMessageComposer setTextAlignment:UITextAlignmentLeft];
	[_txtvMessageComposer setEditable:YES];
	
	[[_txtvMessageComposer layer] setBorderColor:[[UIColor blackColor] CGColor]];
	[[_txtvMessageComposer layer] setBorderWidth:1];
	[[_txtvMessageComposer layer] setCornerRadius:8];
	[_txtvMessageComposer setClipsToBounds: YES];
	[_txtvMessageComposer setText:@""];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)onBtnSend:(id)sender
{
    if([_txtvMessageComposer.text length] > 0)
    {
        if(_isPostMessage)
        {
            SocialPostActivity* actPost = [[SocialPostActivity alloc] init];
            
            [actPost postActivity:_txtvMessageComposer.text];
            
//            [actPost release];
        }
        else
        {
            SocialPostCommentProxy *actComment = [[SocialPostCommentProxy alloc] init];
            [actComment postComment:_txtvMessageComposer.text forActivity:_strActivityID];
            
//            [actComment release];
        }
        
        [_delegate clearActivityData];        
        [_delegate loadActivityStream];

        
        [self dismissModalViewControllerAnimated:YES];    
        

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Composer" message:@"There is no message for comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        if(_isPostMessage)
            alert.message = @"There is no message for possing";
        
        [alert release];
    }
    
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

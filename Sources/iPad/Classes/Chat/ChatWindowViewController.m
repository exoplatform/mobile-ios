//
//  ChatWindowViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 7/1/10.
//  Copyright 2010 home. All rights reserved.
//

#import "ChatWindowViewController.h"
#import "defines.h"
#import "MessengerViewController.h"
#import "MainViewController.h"
#import "DDXML.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPElement.h"

@implementation ChatWindowViewController

@synthesize _wvChatContentDisplay;
@synthesize _intBShowKeyboard;
@synthesize _bLandscape;
@synthesize _imgvNewMsgArea;
@synthesize _vTextInputArea;
@synthesize _tvTextInput;
@synthesize _btnSend;
@synthesize _messengerUser;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_bbtnClear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearChatContent)];
		_bbtnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeChatContent)];
		
		_wvChatContentDisplay = [[UIWebView alloc] init];
		[[self view] addSubview:_wvChatContentDisplay];
		
		_wvChatContentDisplayUp = [[UIWebView alloc] init];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self.navigationItem setLeftBarButtonItem:_bbtnClose];
	[self.navigationItem setRightBarButtonItem:_bbtnClear];
	[self localize];
	[self addNotification];
	[_imgvNewMsgArea setImage:[UIImage imageNamed:@"newmessage.png"]];
	[super viewDidLoad];
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
	
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation != _interfaceOrientation)
	{
		_interfaceOrientation = interfaceOrientation;
	}	
	
	if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		_strHtml = _messengerUser._mstrHtmlPortrait;
	}
	
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{
		_strHtml = _messengerUser._mstrHtmlLanscape;
	}
	
	[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];	
	[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
}


- (void)initChatWindowWithUser:(MessengerUser*)messengerUser andXMPPClient:(XMPPClient*)xmppClient
{
	_messengerUser = messengerUser;
	_xmppClient = xmppClient;
	_imgvNewMsgArea.hidden = YES;
	_intBShowKeyboard = 0;
	[_tvTextInput resignFirstResponder];
	[self changeOrientation:_interfaceOrientation];
	[_tvTextInput setEditable:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	_intBShowKeyboard = 1;
	return YES;
}

-(void)createChatContent:(NSString *)content
{
	NSString* tmpStr;
	NSRange insertIndex;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	
	tmpStr = [[_delegate getMessengerViewController] createChatContentFor:userName content:
			   [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] isMe:YES portrait:YES];
	insertIndex = [_messengerUser._mstrHtmlPortrait rangeOfString:@"</table></body>"];
	[_messengerUser._mstrHtmlPortrait insertString:tmpStr atIndex:insertIndex.location];
	
	tmpStr = [[_delegate getMessengerViewController] createChatContentFor:userName content:
			   [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] isMe:YES portrait:NO];
	insertIndex = [_messengerUser._mstrHtmlLanscape rangeOfString:@"</table></body>"];
	[_messengerUser._mstrHtmlLanscape insertString:tmpStr atIndex:insertIndex.location];
	
}

-(void)closeChatContent
{
	[_delegate removeChatButton:[_delegate getCurrentChatUserIndex]];
	[_delegate setCurrentChatUserIndex:-1];
	[_delegate setCurrentViewIndex:2];
	
	[self.navigationController popViewControllerAnimated:YES];
	[_delegate showChatToolBar:YES];
}

-(void)clearChatContent
{
	[_messengerUser creatHTMLstring];
	if(self.view.frame.size.width > 750)
	{
		_strHtml = _messengerUser._mstrHtmlPortrait;
	}
	else
	{
		_strHtml = _messengerUser._mstrHtmlLanscape;
	}
	[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
	[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
}


- (void)setHiddenForNewMessageImage:(BOOL)isHidden
{
	_imgvNewMsgArea.hidden = isHidden;
}


- (void)setBLandscape:(BOOL)bLandscape
{
	_bLandscape = bLandscape;
}

- (void)addNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)sendMessage:(id)sender
{
	if([_tvTextInput.text isEqualToString:@""])
	{
		return;
	}
	
	NSString* msgContent = [_tvTextInput text];
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	[body setStringValue:msgContent];
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"chat"]];
	[message addAttribute:[NSXMLNode attributeWithName:@"to" stringValue:[[_messengerUser._xmppUser jid] full]]];
	[message addChild:body];
	[_xmppClient sendElement:message];
	[self createChatContent:[msgContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]];
	[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
	[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
	[_tvTextInput setText:@""];
}


- (void)receivedChatMsg
{
	NSString* strFrom = [_messengerUser._xmppUser address];
	NSRange range = [strFrom rangeOfString:@"/"];
	if(range.length > 0)
	{
		strFrom = [strFrom substringToIndex:range.location];
	}	
	if(![strFrom isEqualToString:[[_messengerUser._xmppUser jid] full]])
	{
		return;
	}
	
	[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
	[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
}

- (void)moveFrameUp:(BOOL)bUp
{
	[UIView beginAnimations:nil context:self];
	[UIView setAnimationDuration:0.2];
	
	CGRect rect = self.view.frame;
	CGRect rect2 = [_wvChatContentDisplay frame];
    if (bUp)
	{
		_intBShowKeyboard = 0;
		if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		{	
			rect.origin.y -= kOFFSET_FOR_PORTRAIT_KEYBOARD;
		}	
		if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
		{	
			rect.origin.y -= kOFFSET_FOR_LANSCAPE_KEYBOARD;
		}	
		[_wvChatContentDisplay removeFromSuperview];
		_wvChatContentDisplayUp = [[UIWebView alloc] initWithFrame:rect2];
		[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];
		[[self view] addSubview:_wvChatContentDisplayUp];
	}		
	else
	{
		_intBShowKeyboard = 1;
		if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		{	
			rect.origin.y += kOFFSET_FOR_PORTRAIT_KEYBOARD;
		}	
		if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
		{	
			rect.origin.y += kOFFSET_FOR_LANSCAPE_KEYBOARD;
		}
		[_wvChatContentDisplayUp removeFromSuperview];
		[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
		[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
		[[self view] addSubview:_wvChatContentDisplay];
    }
	
	self.view.frame = rect;
	
	[UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	if(_intBShowKeyboard == 1)
	{
		[self moveFrameUp:YES];
	}	
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
	if(_intBShowKeyboard == 0)
	{
		[self moveFrameUp:NO];
	}	
}
@end

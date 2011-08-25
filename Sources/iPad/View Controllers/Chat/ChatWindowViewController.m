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
		_bbtnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeChatContent)];
        
		_wvChatContentDisplay = [[UIWebView alloc] init];
		[[self view] addSubview:_wvChatContentDisplay];
		
		_wvChatContentDisplayUp = [[UIWebView alloc] init];
        [[self view] addSubview:_wvChatContentDisplayUp];
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
    _delegate = nil;	//The delegate, point to MainViewController
	
    [_xmppClient release];
    _xmppClient = nil;
    
    [_messengerUser release];
    _messengerUser = nil;
	
    [_wvChatContentDisplay release];
    _wvChatContentDisplay= nil;
	
    [_wvChatContentDisplayUp release];
    _wvChatContentDisplayUp = nil;
	
    [_vTextInputArea release];
    _vTextInputArea = nil;
	
    [_imgvNewMsgArea release];
    _imgvNewMsgArea = nil;
    
    [_tvTextInput release];
    _tvTextInput = nil;
    
    [_btnSend release];
    _btnSend = nil;
	
    [_bbtnClear release];
    _bbtnClear = nil;
	
    [_bbtnClose release];
    _bbtnClose = nil;
    
    [_strHtml release];
    _strHtml = nil;
	
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)localize
{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
    return YES;
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
    [self moveFrameUp:NO];
    [_tvTextInput resignFirstResponder];
	
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
    _interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	[_tvTextInput setEditable:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	_intBShowKeyboard = 1;
    [_tvTextInput becomeFirstResponder];
	return YES;
}

-(void)createChatContent:(NSString *)content
{
	NSString* tmpStr;
	NSRange insertIndex;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* userName = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
	
	tmpStr = [_delegate createChatContentFor:userName content:
              [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] isMe:YES portrait:YES];
	insertIndex = [_messengerUser._mstrHtmlPortrait rangeOfString:@"</table></body>"];
	[_messengerUser._mstrHtmlPortrait insertString:tmpStr atIndex:insertIndex.location];
	
	tmpStr = [_delegate createChatContentFor:userName content:
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

- (IBAction)clearChatContent:(id)sender
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
	_interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGRect rect1, rect2;
    
    if (bUp) 
    {
        _intBShowKeyboard = 0;
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            rect1 = CGRectMake(0, 44, 500, 607);
            rect2 = CGRectMake(0,651,500,90);
        }
        else
        {
            rect1 = CGRectMake(0, 44, 500, 263);
            rect2 = CGRectMake(0,307,500,90);
        }
        
        [_wvChatContentDisplayUp setFrame:rect1];
        [_wvChatContentDisplay setHidden:YES];
        [_wvChatContentDisplayUp setHidden:NO];
		[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];
        [_vTextInputArea setFrame:rect2];
    }
    else
    {
        _intBShowKeyboard = 1;
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		{
            rect1 = CGRectMake(0, 44, 500, 870);
            rect2 = CGRectMake(0,914,500,90);
        }
        else
        {
            rect1 = CGRectMake(0, 44, 500, 614);
            rect2 = CGRectMake(0,658,500,90);
        }
        [_wvChatContentDisplay setFrame:rect1];
        [_wvChatContentDisplay setHidden:NO];
        [_wvChatContentDisplayUp setHidden:YES];
		[_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
		[_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];	
        [_vTextInputArea setFrame:rect2];
    }
    [_wvChatContentDisplay loadHTMLString:_strHtml baseURL:nil];
    [_wvChatContentDisplayUp loadHTMLString:_strHtml baseURL:nil];

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

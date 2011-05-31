//
//  ChatWindowViewController_iPhone.m
//  eXoApp
//
//  Created by exo on 9/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChatWindowViewController_iPhone.h"
#import "eXoApplicationsViewController.h"
#import "DDXML.h"
#import "XMPPUser.h"
#import "XMPPJID.h"
#import "XMPPClient.h"
#import "XMPPElement.h"
#import "defines.h"
#import "MessengerViewController_iPhone.h"

#define BACKGROUNDCOLOR @"#E9E9E9"
#define CHATBOX @"#F7F7F7"


// UTILS Methods

NSString* processMsg_iPhone(NSString* message)
{
	NSMutableString *returnStr = [[NSMutableString alloc] initWithString:@""];
	NSArray *brArr = [message componentsSeparatedByString:@"<br/>"];
	
	for(int i = 0; i < [brArr count]; i++)
	{
		NSMutableString *tmp = [[NSMutableString alloc] initWithString:[brArr objectAtIndex:i]];
		int count = [tmp length];
		for(int j = 0; j < count; j++)
		{
			[tmp insertString:@"<wbr/>" atIndex:j*7 + 1];
		}
		
		if(![returnStr isEqualToString:@""])
			[returnStr appendString:@"<br/>"];
		
		[returnStr appendString: tmp];
        [tmp release];
	}
	
	return returnStr;
}

NSString* base64Encoding_iPhone(NSData *data)
{
	if ([data length] == 0)
		return @"";
	
	const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    char *characters = malloc((([data length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [data length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [data length])
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

NSString* imageStr_iPhone(NSString *fileName, NSString *type)
{
	NSString *iconChat = [[NSBundle mainBundle] pathForResource:fileName ofType:type];;
	NSData *iconChatData = [NSData dataWithContentsOfFile:iconChat];

	return [base64Encoding_iPhone(iconChatData) retain];;	
}

NSString* createChatContent(NSString *chatIcon, NSString *chatName, NSString *content, NSString *tl, NSString *tr, NSString *bl, 
							NSString *br, NSString *th, NSString *bh, NSString *color) 
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss"];
	NSString *msgTime = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
	
	NSString *tempStr = [NSString stringWithFormat:@"<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=310>"
						 "<tr>"
						 "<td width=\"20\"><img src=\"data:image/png;base64,%@\" width=\"20\" height=\"20\"></td>"
						 "<td width=\"250\">%@</td>"
						 "<td align=\"center\" valign=\"bottom\"><font size=\"1\">%@</font></td>"
						 "</tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=310>"
						 "<tr>"
						 "<td width=\"10\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "<td width=\"300\"><img src=\"data:image/png;base64,%@\" width=\"290\" height=\"10\"></td>"
						 "<td align=\"right\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "</tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=310>"
						 "<tr bgcolor=\"%@\">"
						 "<td width=\"2\" background=\"http://platform.demo.exoplatform.org/chatbar/skin/DefaultSkin/background/LeftMiddleGuestChat3x1.gif\"></td>"
						 "<td width=\"5\"></td>"
						 "<td width=\"299\">%@</td>"
						 "<td width=\"2\" background=\"http://platform.demo.exoplatform.org/chatbar/skin/DefaultSkin/background/RightMiddleGuestChat4x1.gif\"></td>"
						 "</tr>"
						 "</table>"
						 "<table boder=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=310>"
						 "<tr>"
						 "<td width=\"10\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "<td width=\"300\"><img src=\"data:image/png;base64,%@\" width=\"290\" height=\"10\"></td>"
						 "<td align=\"right\"><img src=\"data:image/png;base64,%@\" width=\"10\" height=\"10\"></td>"
						 "</tr><tr width=\"310\" height=\"10\" COLSPAN=3></tr>", 
						 chatIcon, chatName, msgTime, tl, th, tr, color,
						 content, bl, bh, br];
	
	return tempStr;
}


// Implementation


@implementation ChatWindowViewController_iPhone


@synthesize _xmppUser, _arrChatUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
        
	}
	return self;
}


//- (void)initChatWindowWithDelegate:(eXoApplicationsViewController *)delegate andXMPPClient:(XMPPClient*)xmppClient andExoChatUser:(eXoChatUser*)exoChatUser listMsg:(NSMutableDictionary *)listMsg
- (void)initChatWindowWithDelegate:(MessengerViewController_iPhone *)delegate andXMPPClient:(XMPPClient*)xmppClient 
					andExoChatUser:(eXoChatUser*)exoChatUser listMsg:(NSMutableDictionary *)listMsg
{

    _delegate = delegate;
    
	if(iconChatMe == nil)
	{
		iconChatMe = imageStr_iPhone(@"me", @"png");
		iconChatFriend = imageStr_iPhone(@"you", @"png");
		topLeftStr = imageStr_iPhone(@"tl", @"png");
		topRightStr = imageStr_iPhone(@"tr", @"png");
		topHorizontalStr = imageStr_iPhone(@"TopHorizontal", @"png");
		bottomLeftStr = imageStr_iPhone(@"bl", @"png");
		bottomRightStr = imageStr_iPhone(@"br", @"png");
		bottomHorizontalStr = imageStr_iPhone(@"BottomHorizontal", @"png");	
	}
	
    /*
	_delegate = delegate;
	[self addSubview:_delegate._btnChatSend];
	[self bringSubviewToFront:_delegate._btnChatSend];
	*/
    
	if(!_arrMessages)
    {
		_arrMessages = [[NSMutableArray alloc] init];
	}
	_xmppClient = xmppClient;
	_xmppUser = [exoChatUser getXmppUser];
	_strMessage = @"";
	
	//_arrMessages = [[NSMutableArray alloc] init];
	//_arrMessages = [exoChatUser getArrMessages];
	
    /*
	if(_delegate._isNewMsg)
		_newMsgImg.hidden = FALSE;
	else
		_newMsgImg.hidden = TRUE;
	*/
	_bShowInputMsgKeyboard = NO;

    /*
	[[[self delegate] navigationItem] setRightBarButtonItem:_delegate._btnClearMsg];
	*/
	
	UIFont *font = [UIFont systemFontOfSize:14];
	_txtViewMsg.font = font;
	
	[_chatHtmlStr release];
	_chatHtmlStr = [[NSMutableString alloc] init];
	[_chatHtmlStr appendString:[exoChatUser getHtmlStr]];
	
	if([_chatHtmlStr length] == 0)
	[_chatHtmlStr appendString:@"<html><head><script type=\"text/javascript\">"
									"function pageScroll() {"
										"dh=document.body.scrollHeight;"
										"ch=document.body.clientHeight;"
										"moveme=dh-ch;"
										"window.scrollTo(0,moveme);"
										"};"
								"</script></head><body BGCOLOR=\"#E9E9E9\" onLoad=\"pageScroll()\"><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><table boder=\"0\" width=\"310\"></table></body></html>"];
	
	NSArray *keys = [listMsg allKeys];
	NSString *offlineMsg = @"";
	NSString *from = @"";
	
	for(int i = 0; i < [keys count]; i++)
	{
		from = [keys objectAtIndex:i];
		if([from isEqualToString:[[_xmppUser jid] full]])
		{
			offlineMsg = [listMsg objectForKey:from];
			break;
		}
			
	}
	if(![offlineMsg isEqualToString:@""])
	{
		NSRange range = [from rangeOfString:@"@"];
		NSString* tmpStr = [from substringToIndex:range.location];
		
		NSString *tempStr = createChatContent(iconChatFriend, tmpStr, offlineMsg, topLeftStr, topRightStr, 
											  bottomLeftStr, bottomRightStr, topHorizontalStr, bottomHorizontalStr, @"#F7F7F7");
				
		NSRange insertIndex = [_chatHtmlStr rangeOfString:@"</table></body>"];
		[_chatHtmlStr insertString:tempStr atIndex:insertIndex.location];
	}
	
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];
	
	[_delegate updateForEachExoChatUser:_xmppUser withArrMsg:_arrMessages withHtmlStr:_chatHtmlStr];
	
	[listMsg setObject:@"" forKey:from];
}


- (void)dealloc {
    _delegate = nil;
    
    [_xmppClient release];
	_xmppClient = nil;
    
	[_xmppUser release];
    _xmppUser = nil;
    
	[_xmppMessage release];
    _xmppMessage = nil;
	
	[_arrMessages release];
    _arrMessages = nil;
	
    [_strMessage release];
	_strMessage = nil;
    
	[_chatWebView release];
    _chatWebView = nil;
    
	[_txtViewMsg release];
    _txtViewMsg = nil;
    
	[_newMsgImg release];
    _newMsgImg = nil;
    
	[_txtInputMsg release];
    _txtInputMsg = nil;
    
	[_chatHtmlStr release];
    _chatHtmlStr = nil;
	
	[_arrChatUsers release];
    _arrChatUsers = nil;
    
    [super dealloc];
}


- (eXoApplicationsViewController *)delegate
{
	return _delegate;
}

- (IBAction)onClearBtn
{
	[_arrMessages removeAllObjects];
	
	[_chatHtmlStr release];
	_chatHtmlStr = [[NSMutableString alloc] init];
	[_chatHtmlStr appendString:@"<html><head><script type=\"text/javascript\">"
	 "function pageScroll() {"
	 "dh=document.body.scrollHeight;"
	 "ch=document.body.clientHeight;"
	 "moveme=dh-ch;"
	 "window.scrollTo(0,moveme);"
	 "};"
	 "</script></head><body BGCOLOR=\"#E9E9E9\" onLoad=\"pageScroll()\"><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><table boder=\"0\" width=\"310\"></table></body></html>"];
	
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];
	[_delegate updateForEachExoChatUser:_xmppUser withArrMsg:_arrMessages withHtmlStr:_chatHtmlStr];
	
}

//- (void)onBtnSendMsg
- (IBAction)onBtnSendMsg:(id)sender
{

	if([_txtViewMsg.text isEqualToString:@""])
		return;
	
	NSString* msgContent = [_txtViewMsg text];
	NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
	[body setStringValue:msgContent];
	NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
	[message addAttribute:[NSXMLNode attributeWithName:@"type" stringValue:@"chat"]];
	[message addAttribute:[NSXMLNode attributeWithName:@"to" stringValue:[[_xmppUser jid] full]]];
	[message addChild:body];
	[_xmppClient sendElement:message];
	
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_PREFERENCE_USERNAME];
	NSString* msgDisplayContent = [userName stringByAppendingString:@": "];
	msgDisplayContent = [msgDisplayContent stringByAppendingString:msgContent];
	
	[_arrMessages addObject:msgDisplayContent];
	
	NSString *tempStr = createChatContent(iconChatMe, userName, 
										  [msgContent stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"], 
										  topLeftStr, topRightStr, 
										  bottomLeftStr, bottomRightStr, topHorizontalStr, bottomHorizontalStr, @"#F7F7F7");
	
	
	NSRange insertIndex = [_chatHtmlStr rangeOfString:@"</table></body>"];
	[_chatHtmlStr insertString:tempStr atIndex:insertIndex.location];
	
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];

	[_txtViewMsg setText:@""];
	
	[_delegate updateForEachExoChatUser:_xmppUser withArrMsg:_arrMessages withHtmlStr:_chatHtmlStr];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)receivedChatMsg:(XMPPMessage*)message listMsg:(NSMutableDictionary *)listMsg
{
	NSString *from = [NSString stringWithString:[message fromStr]];
	NSRange range = [from rangeOfString:@"/"];
	if(range.length > 0)
		from = [from substringToIndex:range.location];
	
    /*
    if(![from isEqualToString:[[_xmppUser jid] full]])
	{
		if(_delegate._isNewMsg)
			_newMsgImg.hidden = FALSE;
		else
			_newMsgImg.hidden = TRUE;
		
		return;
	}
	*/	
	
	NSString *msg = [listMsg objectForKey: from];
	[listMsg setObject:@"" forKey:from];
	
		
	range = [[message fromStr] rangeOfString:@"@"];
	NSString* tmpStr = [[message fromStr] substringToIndex:range.location];
	
	NSString *tempStr = createChatContent(iconChatFriend, tmpStr, msg, topLeftStr, topRightStr, 
										  bottomLeftStr, bottomRightStr, topHorizontalStr, bottomHorizontalStr, @"#F7F7F7");
	
	
	NSRange insertIndex = [_chatHtmlStr rangeOfString:@"</table></body>"];
	[_chatHtmlStr insertString:tempStr atIndex:insertIndex.location];
	
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];
	
	[_delegate updateForEachExoChatUser:_xmppUser withArrMsg:_arrMessages withHtmlStr:_chatHtmlStr];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 
{
	UIView* hitView = [super hitTest: point withEvent: event];
	[self hitAtView:hitView point:point];
	return hitView;
}

- (void)hitAtView:(UIView*)view point:(CGPoint)point
{
	CGRect textFieldRect = [_txtViewMsg frame];
	if(point.x >= textFieldRect.origin.x && point.x <= textFieldRect.origin.x + textFieldRect.size.width && 
		point.y >= textFieldRect.origin.y && point.y <= textFieldRect.origin.y + textFieldRect.size.height)
	{
		if(!_bShowInputMsgKeyboard) {
			[self moveFrameUp:YES];
			[_txtViewMsg becomeFirstResponder];
		}
		
	}
	if(point.y < textFieldRect.origin.y)
		if(_bShowInputMsgKeyboard)
		{
			[self moveFrameUp:NO];
			[_txtViewMsg resignFirstResponder];
		}
		
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self moveFrameUp:YES];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[self moveFrameUp:NO];
	return YES;
}

-(void)backToChatList
{
    /*
	_delegate._currentChatUser = @"";
	_delegate.navigationItem.title = @"Chat";
    */ 
	[_txtViewMsg resignFirstResponder];
	//self.frame = CGRectMake(0, 0, 320, 460);
    self.view.frame = CGRectMake(0, 0, 320, 460);
}

- (void)moveFrameUp:(BOOL)bUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
	
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    //CGRect rect = self.frame;
    CGRect rect = self.view.frame;
	
    if (bUp)
	{
		if(!_bShowInputMsgKeyboard) {
			_bShowInputMsgKeyboard = YES;
		}
		
		rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;	
		
	}		
	else
	{
		
		if(_bShowInputMsgKeyboard) {
			_bShowInputMsgKeyboard = NO;
		}
		
		rect.origin.y += kOFFSET_FOR_KEYBOARD;
		rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
	
    //self.frame = rect;
    self.view.frame = rect;
	[_chatWebView loadHTMLString:_chatHtmlStr baseURL:nil];
	[UIView commitAnimations];	
}
 
 
@end

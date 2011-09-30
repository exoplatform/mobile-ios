//
//  MessengerViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "MessengerViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "ChatWindowViewController_iPhone.h"

@implementation MessengerViewController_iPad



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        
		// Custom initialization	
    }
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self setTitle:@"Chat Application"];
	[super viewDidLoad];
}

- (void)setHudPosition {
    NSLog(@"%@", NSStringFromCGPoint(CGPointMake(self.view.center.x, self.view.center.y-70)));
    _hudChat.center = CGPointMake(self.view.center.x, self.view.center.y-70);
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
    _delegate = nil;
    [_chatWindowViewController release];
    
    
    [super dealloc];
}


- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (_chatWindowViewController) 
    {
        //        [_chatWindowViewController changeOrientation:interfaceOrientation];
    }
}

- (void)receivedChatMessage:(XMPPMessage *)xmppMsg
{
    if([_chatWindowViewController respondsToSelector:@selector(receivedChatMessage:)])
    {
        [_chatWindowViewController receivedChatMessage:xmppMsg];
    }
}


#pragma mark Table view methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    
    _chatWindowViewController = [[ChatWindowViewController_iPad alloc] initWithNibName:@"ChatWindowViewController_iPad" bundle:nil];
    _chatWindowViewController.delegate = self;
    //[_chatWindowViewController ]
    _chatWindowViewController.user = [_arrUsers objectAtIndex:indexPath.row];
    
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:_chatWindowViewController invokeByController:self isStackStartView:FALSE];
    
}

@end

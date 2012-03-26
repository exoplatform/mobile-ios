//
//  MessageContentViewController.m
//  eXo Platform
//
//  Created by Mai Gia on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageContentViewController.h"

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@implementation MessageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGSize)getSizeForMessageContentView:(int)parentsViewWidth andText:(NSString*)text
{
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(parentsViewWidth, 500) 
                          lineBreakMode:UILineBreakModeWordWrap];
    
    
    return theSize;
}

- (void)setContentView:(int)width message:(NSString *)msg left:(BOOL)left
{
   
    lbMessageContent.text = msg;
    
    UIImage *strechBg = nil;
    
    if(left)
    {
        
        //Add images for Background Message
        strechBg = [[UIImage imageNamed:@"ChatDiscussionBuddyMessageBg"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
        
    }
    else
    {
        //Add images for Background Message
        strechBg = [[UIImage imageNamed:@"ChatDiscussionUserMessageBg"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
        
    }

    lbMessageContent.backgroundColor = [UIColor colorWithPatternImage:strechBg];
    CGRect frame = lbMessageContent.frame;
    frame.size.height = 0;
    lbMessageContent.frame = frame;
    lbMessageContent.lineBreakMode = UILineBreakModeWordWrap;
    lbMessageContent.numberOfLines = 0;
    [lbMessageContent sizeToFit];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end

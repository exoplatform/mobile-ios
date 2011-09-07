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
    
    float fWidth = parentsViewWidth - 50;
    
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, 500) 
                          lineBreakMode:UILineBreakModeWordWrap];
    
    theSize.width = fWidth;
    
    return theSize;
}

- (void)setContentView:(int)width avatar:(UIImage *)img message:(NSString *)msg left:(BOOL)left
{
    imgAvatar.image = img;
    lbMessageContent.text = msg;
    lbMessageContent.numberOfLines = 0;

    width -= 10;
    CGSize msgContentSize = [self getSizeForMessageContentView:width andText:msg];
    
    if(msgContentSize.height < 50)
        msgContentSize.height = 50;
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, msgContentSize.height + 5);
    
    lbMessageContent.backgroundColor = [UIColor clearColor];
    
    UIImage *strechBg = nil;
    if(left)
    {
        imgAvatar.frame = CGRectMake(5, 5, 40, 40);
        lbMessageContent.frame = CGRectMake(imgAvatar.frame.origin.x + imgAvatar.frame.size.width + 5, 5, msgContentSize.width, msgContentSize.height);
        
        
        //Add images for Background Message
        strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
        
    }
    else
    {
        lbMessageContent.frame = CGRectMake(5, 5, msgContentSize.width, msgContentSize.height);
        imgAvatar.frame = CGRectMake(lbMessageContent.frame.origin.x + lbMessageContent.frame.size.width + 5, 5, 40, 40);
        
        //Add images for Background Message
        strechBg = [[UIImage imageNamed:@"SocialActivityBrowserActivityBg2.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
        
    }
    
    imgBackground.frame = lbMessageContent.frame;
    imgBackground.image = strechBg;
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

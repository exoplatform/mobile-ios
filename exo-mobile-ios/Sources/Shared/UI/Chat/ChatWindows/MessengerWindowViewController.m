//
//  eXoFilesView.m
//  eXoApp
//
//  Created by Tran Hoai Son on 7/3/09.
//  Copyright 2009 home. All rights reserved.
//

#import "MessengerWindowViewController.h"
#import "MessageContentViewController.h"
#import "MessengerViewController.h"
#import "Message.h"

#define kSentDateFontSize 13.0f
#define kMessageFontSize 16.0f
#define kMessageTextWidth self.view.frame.size.width - 40//180.0f
#define kContentHeightMax 84.0f  // 80.0f, 76.0f
#define kChatBarHeight1 40.0f
#define kChatBarHeight4 94.0f

#define SENT_DATE_TAG 101
#define TEXT_TAG 102
#define BACKGROUND_TAG 103

#define CHAT_BACKGROUND_COLOR [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f]

// 15 mins between messages before we show the date
#define SECONDS_BETWEEN_MESSAGES 900

static NSString *kMessageCell = @"MessageCell";

@implementation MessengerWindowViewController

@synthesize delegate = _delegate, user = _user, heightOfKeyboard = _heightOfKeyboard, 
discussionUserMessageBg = _discussionUserMessageBg, discussionBuddyMessageBg = _discussionBuddyMessageBg;

-(void)dealloc {
    [super dealloc];
    [_user release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = [_user nickname];
    _txtViewMsg.backgroundColor = [UIColor clearColor];
    _btnSendMessage.backgroundColor = [UIColor clearColor];
    

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    
    // optimization FTW
    self.discussionUserMessageBg = [[UIImage imageNamed:@"ChatDiscussionUserMessageBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:22];
    self.discussionBuddyMessageBg = [[UIImage imageNamed:@"ChatDiscussionBuddyMessageBg"] stretchableImageWithLeftCapWidth:20 topCapHeight:22];
    
    _tblMessageContent.clearsContextBeforeDrawing = NO;
    _tblMessageContent.contentInset = UIEdgeInsetsMake(7.0f, 0.0f, 0.0f, 0.0f);
    
    
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tblMessageContent.backgroundView = background;
    [background release];
    
    _tblMessageContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tblMessageContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _cellArray = [[NSMutableArray alloc] init];

}


-(void)viewDidDisappear:(BOOL)animated
{
    if (![self.navigationController.viewControllers containsObject:self])
    {
        //         [_xmppClient disconnect];
	}	
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger bottomRow = [_cellArray count] - 1;
    
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [_tblMessageContent scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)moveViewAnimation:(int)offset
{
    
    // resize the scrollview
    CGRect scrViewFrame = _tblMessageContent.frame;
    scrViewFrame.size.height += offset;
    
    
    //Move typing message area
    CGRect imgViewBackgroundFrame = _imgViewMessengerBackground.frame;
    imgViewBackgroundFrame.origin.y += offset;
    
    CGRect imgViewNewMsgFrame = _imgViewNewMessage.frame;
    imgViewNewMsgFrame.origin.y += offset;
    
    CGRect txtViewMsgFrame = _txtViewMsg.frame;
    txtViewMsgFrame.origin.y += offset;
    
    CGRect btnSendMsgFrame = _btnSendMessage.frame;
    btnSendMsgFrame.origin.y += offset;
    
    //    Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    [_tblMessageContent setFrame:scrViewFrame];
    [_imgViewMessengerBackground setFrame:imgViewBackgroundFrame];
    [_imgViewNewMessage setFrame:imgViewNewMsgFrame];
    [_txtViewMsg setFrame:txtViewMsgFrame];
    [_btnSendMessage setFrame:btnSendMsgFrame];
    
    [UIView commitAnimations];
    
    [self scrollToBottomAnimated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //    Move view down
    [self moveViewAnimation:_heightOfKeyboard];
    
    //    Set ketboard flag
    _keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    if (_keyboardIsShown) {
        return;
    }
    
    //    Move view up
    [self moveViewAnimation:-_heightOfKeyboard];
    
    //    Set ketboard flag
    _keyboardIsShown = YES;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
}

- (NSInteger)addMessage:(Message *)message 
{
    // Show sentDates at most every 15 minutes.
    NSDate *currentSentDate = [message sentDate];
    NSUInteger numberOfObjectsAdded = 1;
    NSUInteger prevIndex = [_cellArray count] - 1;
    
    // Show sentDates at most every 15 minutes.
    
    if([_cellArray count])
    {
        BOOL prevIsMessage = [[_cellArray objectAtIndex:prevIndex] isKindOfClass:[Message class]];
        if(prevIsMessage)
        {
            Message * temp = [_cellArray objectAtIndex:prevIndex];
            NSDate * previousSentDate = temp.sentDate;
            // if there has been more than a 15 min gap between this and the previous message!
            if([currentSentDate timeIntervalSinceDate:previousSentDate] > SECONDS_BETWEEN_MESSAGES) 
            { 
                [_cellArray addObject:currentSentDate];
                numberOfObjectsAdded = 2;
            }
        }
    }
    else
    {
        // there are NO messages, definitely add a timestamp!
        [_cellArray addObject:currentSentDate];
        numberOfObjectsAdded = 2;
    }
    
    [_cellArray addObject:message];
    
    return numberOfObjectsAdded;
}

-(void)insertNewMessage:(Message *)newMessage {
    
    NSArray *indexPaths;
    
    NSUInteger cellCount = [_cellArray count];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:cellCount inSection:0];
    
    if ([self addMessage:newMessage] == 1)
        indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath, nil];
    else
        indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                      [NSIndexPath indexPathForRow:cellCount+1 inSection:0], nil];
    
    
    [_tblMessageContent insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationNone];
    
    
    [self scrollToBottomAnimated:YES];
    
    [indexPaths release];
}

- (IBAction)onBtnSendMessage
{
    
//    [self createChatMessageContentView:YES message:msgContentStr];
    
    NSString *rightTrimmedMessage = _txtViewMsg.text;
    
    // Don't send blank messages.
    if (rightTrimmedMessage.length == 0) {
        return;
    }
    
    // Create new message and save to Core Data.
    Message *newMessage = [[Message alloc] initWithText:rightTrimmedMessage date:[NSDate date] isMe:YES];
    
    [self insertNewMessage:newMessage];
    
    if([_delegate respondsToSelector:@selector(sendChatMessage: to:)])
    {
        [_delegate sendChatMessage:_txtViewMsg.text to:[[_user jid] full]];
    }
    
      [_txtViewMsg setText:@""];

}

- (void)receivedChatMessage:(XMPPMessage *)xmppMsg
{
    Message *newMessage = [[Message alloc] initWithText:[xmppMsg stringValue] date:[NSDate date] isMe:NO];
    
    [self insertNewMessage:newMessage];
    
}

- (void)onBtnClearMessage
{
    
}


//TextViewDelegate Method
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_cellArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"height for row: %d", [indexPath row]);
    
    NSObject *object = [_cellArray objectAtIndex:[indexPath row]];
    
    // Set SentDateCell height.
    if ([object isKindOfClass:[NSDate class]]) {
        return kSentDateFontSize + 7.0f;
    }
    
    // Set MessageCell height.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 17.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *msgSentDate;
    UIImageView *msgBackground;
    UILabel *msgText;
    
    
    NSObject *object = [_cellArray objectAtIndex:[indexPath row]];
    UITableViewCell *cell;
    
    // Handle sentDate (NSDate).
    if ([object isKindOfClass:[NSDate class]]) {
        static NSString *kSentDateCellId = @"SentDateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:kSentDateCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kSentDateCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Create message sentDate lable
            msgSentDate = [[UILabel alloc] initWithFrame:
                           CGRectMake(-2.0f, 0.0f,
                                      _tblMessageContent.frame.size.width, kSentDateFontSize+5.0f)];
            msgSentDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            msgSentDate.clearsContextBeforeDrawing = NO;
            msgSentDate.tag = SENT_DATE_TAG;
            msgSentDate.font = [UIFont boldSystemFontOfSize:kSentDateFontSize];
            msgSentDate.lineBreakMode = UILineBreakModeTailTruncation;
            msgSentDate.textAlignment = UITextAlignmentCenter;
            msgSentDate.backgroundColor = [UIColor clearColor]; // clearColor slows performance
            msgSentDate.textColor = [UIColor blackColor];
            [cell addSubview:msgSentDate];
            [msgSentDate release];
            //            // Uncomment for view layout debugging.
            //            cell.contentView.backgroundColor = [UIColor orangeColor];
            //            msgSentDate.backgroundColor = [UIColor orangeColor];
        } else {
            msgSentDate = (UILabel *)[cell viewWithTag:SENT_DATE_TAG];
        }
        
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; // Jan 1, 2010
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  // 1:43 PM
            
            // TODO: Get locale from iPhone system prefs. Then, move this to viewDidAppear.
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:usLocale];
            [usLocale release];
        }
        
        msgSentDate.text = [dateFormatter stringFromDate:(NSDate *)object];
        
        return cell;
    }
    
    // Handle Message object.
    cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kMessageCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Create message background image view
        msgBackground = [[UIImageView alloc] init];
        msgBackground.clearsContextBeforeDrawing = NO;
        msgBackground.tag = BACKGROUND_TAG;
//        msgBackground.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
        [cell.contentView addSubview:msgBackground];
        [msgBackground release];
        
        // Create message text label
        msgText = [[UILabel alloc] init];
        msgText.clearsContextBeforeDrawing = NO;
        msgText.tag = TEXT_TAG;
        msgText.backgroundColor = [UIColor clearColor];
        msgText.numberOfLines = 0;
        msgText.lineBreakMode = UILineBreakModeWordWrap;
        msgText.font = [UIFont systemFontOfSize:kMessageFontSize];
        [cell.contentView addSubview:msgText];
        [msgText release];
    } else {
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:BACKGROUND_TAG];
        msgText = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    }
    
    // Configure the cell to show the message in a bubble. Layout message cell & its subviews.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];

    if (!([(Message *)object isMe])) { // right bubble
        msgBackground.frame = CGRectMake(self.view.frame.size.width-size.width-34.0f,
                                         kMessageFontSize-13.0f, size.width+34.0f,
                                         size.height+12.0f);
        msgBackground.image = self.discussionBuddyMessageBg;
        msgText.frame = CGRectMake(self.view.frame.size.width-size.width-22.0f,
                                   kMessageFontSize-9.0f, size.width+5.0f, size.height);
//        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        msgText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    } else { // left bubble
        msgBackground.frame = CGRectMake(0.0f, kMessageFontSize-13.0f,
                                         size.width+34.0f, size.height+12.0f);
        msgBackground.image = self.discussionUserMessageBg;
        msgText.frame = CGRectMake(22.0f, kMessageFontSize-9.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }

    msgText.text = [(Message *)object text];
    
    return cell;
}


@end

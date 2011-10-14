
#import "Message.h"

@implementation Message

@synthesize isMe, sentDate, text;


-(id)initWithText:(NSString*)message date:(NSDate*)date isMe:(BOOL)me {
   
    self.isMe = me;
    self.text = message;
    self.sentDate = date;
    
    return self;
}

@end

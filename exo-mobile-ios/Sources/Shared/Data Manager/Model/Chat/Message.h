#import <Foundation/Foundation.h>

@interface Message : NSObject {

    BOOL _isMe;
    NSDate * _sentDate;
    NSString * _text;
}

@property BOOL isMe;
@property (nonatomic, retain) NSDate * sentDate;
@property (nonatomic, retain) NSString * text;

-(id)initWithText:(NSString*)message date:(NSDate*)date isMe:(BOOL)me;

@end

//
//  CallHistoryManager.m
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CallHistoryManager.h"
#import "UserPreferencesManager.h"
#import "CallHistory.h"

@implementation CallHistoryManager
- (id)init
{
    if((self = [super init])) {
    }
    return self;
}

+ (CallHistoryManager*)sharedInstance
{
	static CallHistoryManager *sharedInstance;
	@synchronized(self)
	{
		if(!sharedInstance)
		{
            sharedInstance = [[CallHistoryManager alloc] init];
        }
		return sharedInstance;
	}
	return sharedInstance;
}

- (void)saveHistory
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.history forKey:[NSString stringWithFormat:@"CallHistory_%@", self.userId]];
    [archiver finishEncoding];
    [data writeToFile:[self filePath] atomically:YES];
}

- (void)loadHistory
{
    NSString *filePath = [self filePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSMutableArray *array = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"CallHistory_%@", self.userId]];
        [unarchiver finishDecoding];
        
        //sort the history by time of call
        self.history = [NSMutableArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CallHistory *history1 = (CallHistory *)obj1;
            CallHistory *history2 = (CallHistory *)obj2;
            
            return [history2.date compare:history1.date];
        }]];
        
    } else {
        self.history = [[NSMutableArray alloc]initWithCapacity:20];
    }
}
- (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString *)filePath
{
    NSString *pathComponent = [NSString stringWithFormat:@"CallHistory_%@.plist", self.userId];
    return [[self documentDirectory] stringByAppendingPathComponent:pathComponent];
}

@end

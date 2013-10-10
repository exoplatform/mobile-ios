//
//  CallHistoryManager.m
//  eXo Platform
//
//  Created by vietnq on 10/9/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "CallHistoryManager.h"
#import "UserPreferencesManager.h"

@implementation CallHistoryManager

- (id)init
{
    if((self = [super init])) {
        self.userId = [UserPreferencesManager sharedInstance].username;
        [self loadHistory];
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
        self.history = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"CallHistory_%@", self.userId]];
        [unarchiver finishDecoding];
        
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
    return [[self documentDirectory] stringByAppendingPathComponent:@"CallHistory.plist"];
}

@end

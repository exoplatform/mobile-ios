/*
 *  ATMTextLayer.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMTextLayer.h"

@implementation ATMTextLayer
@synthesize caption;

- (id)initWithLayer:(id)layer {
	if ((self = [super init])) {
		caption = @"";
	}
	return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
	if ([key isEqualToString:@"caption"]) {
		return YES;
	} else {
		return [super needsDisplayForKey:key];
	}
}

- (void)drawInContext:(CGContextRef)ctx {
	UIGraphicsPushContext(ctx);
	
	CGRect f = self.bounds;
	CGRect s = f;
	s.origin.y -= 1;
    NSMutableParagraphStyle *wordWrapStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    wordWrapStyle.lineBreakMode = NSLineBreakByWordWrapping;
    wordWrapStyle.alignment = NSTextAlignmentCenter;
    [caption drawInRect:f withAttributes:@{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                           NSParagraphStyleAttributeName: wordWrapStyle,
                                           NSForegroundColorAttributeName: [UIColor blackColor]
                                           }];

    [caption drawInRect:s withAttributes:@{
                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                           NSParagraphStyleAttributeName: wordWrapStyle,
                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                           }];
	UIGraphicsPopContext();
}

- (void)dealloc {
	[caption release];
	[super dealloc];
}

@end

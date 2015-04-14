//
//  WETouchDownGestureRecognizer.m
//  WEPopover
//
//  Created by Werner Altewischer on 18/09/14.
//  Copyright (c) 2014 Werner IT Consultancy. All rights reserved.
//

#import "WEBlockingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation WEBlockingGestureRecognizer

- (id)init {
    return [self initWithTarget:self action:@selector(__dummyAction)];
}

- (id)initWithTarget:(id)target action:(SEL)action {
    if ((self = [super initWithTarget:target action:action])) {
        self.cancelsTouchesInView = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateRecognized;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return [self isGestureRecognizerAllowed:preventingGestureRecognizer];
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return ![self isGestureRecognizerAllowed:preventedGestureRecognizer];
}

- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![self isGestureRecognizerAllowed:otherGestureRecognizer];
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)isGestureRecognizerAllowed:(UIGestureRecognizer *)gr {
    return [gr.view isDescendantOfView:self.view];
}

- (void)__dummyAction {
    
}

@end

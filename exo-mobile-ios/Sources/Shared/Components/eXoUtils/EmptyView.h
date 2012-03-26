//
//  EmptyView.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageHelper.h"

@interface EmptyView : UIView {
    UIImageView *imageView;
    UILabel *label;
    NSString *imagename;
    NSInteger distance;
}
- (id)initWithFrame:(CGRect)frame withImageName:(NSString*)imageName andContent:(NSString *)content;
- (void)changeOrientation;
@end

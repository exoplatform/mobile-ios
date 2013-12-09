//
//  DocumentDisplayViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 10/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocumentDisplayViewController.h"


@implementation DocumentDisplayViewController

// custom init method to allow URL to be passed
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle url:(NSURL *)defaultURL fileName:(NSString *)fileName
{
	if(self = [super initWithNibName:nibName bundle:nibBundle]){
        _url = [defaultURL retain];
        _fileName = [fileName retain];
    }
    
	return self;
}

#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _fileName;
}

-(NSString *) shortString : (NSString *) myString withMaxCharacter: (int) range {
    // define the range you're interested in
    if (range > [myString length]) {
        return myString;
    }
    NSRange stringRange = {0, MIN([myString length], range)};
    
    // adjust the range to include dependent chars
    stringRange = [myString rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [myString substringWithRange:stringRange];
    NSString *result = [NSString stringWithFormat:@"%@%@",shortString,@"..."];
    return result;
}


@end

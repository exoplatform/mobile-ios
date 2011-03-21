//
//  eXoSplash.h
//  eXoApp
//
//  Created by exo on 9/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Display splash view
@interface eXoSplashViewController : UIViewController {
	UIActivityIndicatorView *activity;	//Loading indicator
	UILabel *label;	//Auto signin title
	UILabel *lDomain;	//Host title
	UILabel *lUserName;	//Username title
	UILabel *lDomainStr;	//Host value
	UILabel *lUserNameStr;	//Username value
	UIImageView *autoLoginImg;	//Auto signin image view
	
	NSDictionary* _dictLocalize;	//Language dictionary
}

@property(nonatomic, retain) UIActivityIndicatorView *activity;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UILabel *lDomain;
@property(nonatomic, retain) UILabel *lUserName;
@property(nonatomic, retain) UILabel *lDomainStr;
@property(nonatomic, retain) UILabel *lUserNameStr;
@property(nonatomic, retain) UIImageView *autoLoginImg;

@property(nonatomic, retain) NSDictionary* _dictLocalize;

@end

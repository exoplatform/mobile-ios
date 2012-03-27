//
//  eXoSplash.h
//  eXoApp
//
//  Created by exo on 9/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface eXoSplash : UIViewController {
	UIActivityIndicatorView *activity;
	UILabel *label;
	UILabel *lDomain;
	UILabel *lUserName;
	UILabel *lDomainStr;
	UILabel *lUserNameStr;
	UIImageView *autoLoginImg;
	
	NSDictionary* _dictLocalize;
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

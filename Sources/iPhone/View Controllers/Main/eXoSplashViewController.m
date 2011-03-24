//
//  eXoSplash.m
//  eXoApp
//
//  Created by exo on 9/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoSplashViewController.h"
#import "defines.h"

@implementation eXoSplashViewController

@synthesize activity, label, lDomain, lUserName, lDomainStr, lUserNameStr, autoLoginImg, _dictLocalize;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
		
		activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activity.center = CGPointMake(160, 150);
		[activity startAnimating];
		
		lDomain = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 95, 20)];
		lDomain.textColor = [UIColor whiteColor];
		lDomain.backgroundColor = [UIColor clearColor];
		lDomain.textAlignment = UITextAlignmentRight;
		
		lUserName = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, 95, 20)];
		lUserName.textColor = [UIColor whiteColor];
		lUserName.backgroundColor = [UIColor clearColor];
		lUserName.textAlignment = UITextAlignmentRight;
		
		lDomainStr = [[UILabel alloc] initWithFrame:CGRectMake(135, 45, 155, 20)];
		lDomainStr.text = [userDefault objectForKey:EXO_PREFERENCE_DOMAIN];
		lDomainStr.textColor = [UIColor whiteColor];
		lDomainStr.backgroundColor = [UIColor clearColor];
		lDomainStr.textAlignment = UITextAlignmentLeft;
		
		lUserNameStr = [[UILabel alloc] initWithFrame:CGRectMake(135, 75, 155, 20)];
		lUserNameStr.text = [userDefault objectForKey:EXO_PREFERENCE_USERNAME];
		lUserNameStr.textColor = [UIColor whiteColor];
		lUserNameStr.backgroundColor = [UIColor clearColor];
		lUserNameStr.textAlignment = UITextAlignmentLeft;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 20)];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
	
		autoLoginImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, 320, 200)];
		autoLoginImg.image = [UIImage imageNamed:@"autoLogin.png"];
		//autoLoginImg.center = CGPointMake(160, 100);
		autoLoginImg.alpha = 0.4;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	lDomain.text = [_dictLocalize objectForKey:@"DomainCellTitle"];
	lUserName.text = [_dictLocalize objectForKey:@"UserNameCellTitle"];
	label.text = [_dictLocalize objectForKey:@"AutoLogin"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [activity release];	//Loading indicator
	[label release];	//Auto signin title
	[lDomain release];	//Host title
	[lUserName release];	//Username title
	[lDomainStr release];	//Host value
	[lUserNameStr release];	//Username value
	[autoLoginImg release];	//Auto signin image view
	    
    [super dealloc];
}


@end

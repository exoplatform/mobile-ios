//
//  WelcomeViewController_iPhone.m
//  eXo Platform
//
//  Created by vietnq on 6/13/13.
//  Copyright (c) 2013 eXoPlatform. All rights reserved.
//

#import "WelcomeViewController_iPhone.h"
#import "AuthenticateViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
@interface WelcomeViewController_iPhone ()

@end

@implementation WelcomeViewController_iPhone {
    NSArray *images;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect frame;
    
    images = [NSArray arrayWithObjects:@"activity-stream",@"documents",@"gadgets", nil];
    
    for(int i = 0; i < [images count]; i++) {
        
        UIImage *image = [UIImage imageNamed:[images objectAtIndex:i]];
        frame = CGRectMake(self.scrollView.frame.size.width * i, 0 , self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = image;
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [images count], self.scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)skipCloudSignup:(id)sender
{
    
    AppDelegate_iPhone *appDelegate = [AppDelegate_iPhone instance];
    [UIView transitionFromView:appDelegate.window.rootViewController.view
                        toView:appDelegate.navigationController.view
                      duration:0.8f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        appDelegate.window.rootViewController = appDelegate.navigationController;
                    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

}
@end

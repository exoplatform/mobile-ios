//
//  ShareViewController.h
//  share-extension
//
//  Created by Nguyen Manh Toan on 6/3/15.
//  Copyright (c) 2015 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "SpaceViewController.h"
#import "AccountViewController.h"
#import "UploadViewController.h"
@interface ShareViewController : SLComposeServiceViewController<SpaceDelegate,AccountDelegate, NSURLConnectionDataDelegate , NSURLConnectionDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, UploadViewControllerDelegate>

@end

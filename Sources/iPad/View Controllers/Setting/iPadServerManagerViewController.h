//
//  iPadServerManagerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPadServerAddingViewController;
@class iPadServerEditingViewController;

@interface iPadServerManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    id                                  _delegate;
    IBOutlet UITableView*               _tbvlServerList;
    NSMutableArray*                     _arrServerList;
    iPadServerAddingViewController*     _iPadServerAddingViewController;
    iPadServerEditingViewController*    _iPadServerEditingViewController;

    UIButton*                           _btnAdd;
    NSDictionary*                       _dictLocalize;
    int                                 _intCurrentIndex;
    int                                 _interfaceOrientation;
}

@property (nonatomic, retain) UITableView* _tbvlServerList;

- (void)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (void)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (void)deleteServerObjAtIndex:(int)index;
- (void)setDelegate:(id)delegate;
- (IBAction)onBtnBack:(id)sender;
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

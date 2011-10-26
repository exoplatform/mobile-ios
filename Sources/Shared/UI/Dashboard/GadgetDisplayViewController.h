//
//  GadgetDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "eXoViewController.h"
#import "GadgetItem.h"


//Display gadget content
@interface GadgetDisplayViewController : eXoViewController <UIWebViewDelegate> {
	UIWebView*	_webView;	//Display gadget on webview
	GadgetItem* _gadget;	//Gadget 
    
    //Loader
    ATMHud*                 _hudGadget;//Heads up display
}

@property (nonatomic, retain) GadgetItem *gadget;
@property (nonatomic, retain) IBOutlet UIWebView* _webView;

- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad;	//Constructor
- (void)setGadget:(GadgetItem *)gadgetToLoad;	//Set gadget

- (void)setHudPosition;

@end


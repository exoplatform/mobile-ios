//
//  GadgetDisplayViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 25/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GadgetItem.h"
#import "eXoDisplayViewController.h"

//Display gadget content
@interface GadgetDisplayViewController : eXoDisplayViewController {
	GadgetItem* _gadget;	//Gadget 
}

@property (nonatomic, retain) GadgetItem *gadget;
- (id)initWithNibAndUrl:(NSString *)nibName bundle:(NSBundle *)nibBundle gadget:(GadgetItem *)gadgetToLoad;

@end


//
//  DashboardItem.h
//  eXo Platform
//
//  Created by Stévan on 25/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardItem : NSObject{

    NSString *_idDashboard; //Dashboard ID
    NSString *_link; //Dashboard link for WS
    NSString *_html; //Dashboard in HTML
    NSString *_label; //Dashboard title label
   
    NSArray *_arrayOfGadgets; //Container for gadgets

}

@property (retain, nonatomic) NSString *idDashboard;
@property (retain, nonatomic) NSString *link;
@property (retain, nonatomic) NSString *html;
@property (retain, nonatomic) NSString *label;
@property (retain, nonatomic) NSArray *arrayOfGadgets;

@end

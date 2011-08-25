//
//  Gadget.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//Dashboard tab
@interface GateInDbItem : NSObject 
{
	NSString*			_strDbItemName;	//Dashboard tab name
	NSURL*				_urlDbItem;	//Dashboard tab URL
	NSArray*			_arrGadgetsInItem;	//Gadgets in dashboard tab
}

@property (nonatomic, retain) NSString* _strDbItemName;
@property (nonatomic, retain) NSURL* _urlDbItem;
@property (nonatomic, retain) NSArray* _arrGadgetsInItem;

//Constructor
- (void)setObjectWithName:(NSString*)name andURL:(NSURL*)url andGadgets:(NSArray*)arrGadgets;
@end

//============================================================================================================



//Gadget info
@interface Gadget : NSObject 
{
	NSString*			_strName;	//Gadget name
	NSString*			_strDescription;	//Gadget description
	NSURL*				_urlContent;	//Gadget URL
	NSURL*				_urlIcon;	//Gadget icon URL
	UIImage*			_imgIcon;	//Gadget icon image
    NSString*			_strID;	//Gadget ID
} 

@property (nonatomic, retain) NSString* _strName;
@property (nonatomic, retain) NSString* _strDescription;
@property (nonatomic, retain) NSURL* _urlContent;
@property (nonatomic, retain) NSURL* _urlIcon;
@property (nonatomic, retain) UIImage* _imgIcon;
@property (nonatomic, retain) NSString* _strID;

//Constructor
- (void)setObjectWithName:(NSString*)name 
			  description:(NSString*)description 
			   urlContent:(NSURL*)urlContent 
				  urlIcon:(NSURL*)urlIcon 
				imageIcon:(UIImage*)imageIcon;
//Gettors
- (NSString*)name;
- (NSString*)description;
- (NSURL*)urlContent;
- (NSURL*)urlIcon;
- (UIImage*)imageIcon;
@end


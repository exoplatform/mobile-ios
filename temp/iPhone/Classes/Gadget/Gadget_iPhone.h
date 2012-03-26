//
//  Gadget.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GateInDbItem_iPhone : NSObject 
{
	NSString*			_strDbItemName;
	NSURL*				_urlDbItem;
	NSArray*			_arrGadgetsInItem;
}

@property (nonatomic, retain) NSString* _strDbItemName;
@property (nonatomic, retain) NSURL* _urlDbItem;
@property (nonatomic, retain) NSArray* _arrGadgetsInItem;

- (void)setObjectWithName:(NSString*)name andURL:(NSURL*)url andGadgets:(NSArray*)arrGadgets;
@end

//============================================================================================================




@interface Gadget_iPhone : NSObject 
{
	NSString*			_strName;
	NSString*			_strDescription;
	NSURL*				_urlContent;
	NSURL*				_urlIcon;
	UIImage*			_imgIcon;
} 

@property (nonatomic, retain) NSString* _strName;
@property (nonatomic, retain) NSString* _strDescription;
@property (nonatomic, retain) NSURL* _urlContent;
@property (nonatomic, retain) NSURL* _urlIcon;
@property (nonatomic, retain) UIImage* _imgIcon;

- (void)setObjectWithName:(NSString*)name 
			  description:(NSString*)description 
			   urlContent:(NSURL*)urlContent 
				  urlIcon:(NSURL*)urlIcon 
				imageIcon:(UIImage*)imageIcon;
- (NSString*)name;
- (NSString*)description;
- (NSURL*)urlContent;
- (NSURL*)urlIcon;
- (UIImage*)imageIcon;
@end

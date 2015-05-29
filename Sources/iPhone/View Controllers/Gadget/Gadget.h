//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *description;
@property (nonatomic, readonly, copy) NSURL *urlContent;
@property (nonatomic, readonly, copy) NSURL *urlIcon;
@property (nonatomic, readonly, strong) UIImage *imageIcon;
@end


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

#import "Gadget.h"


@implementation GateInDbItem

@synthesize _strDbItemName, _urlDbItem, _arrGadgetsInItem;

- (instancetype)init
{
	self = [super init];
	if(self)
	{
		_strDbItemName = [[NSString alloc] init];
		_urlDbItem = [[NSURL alloc] init];
		_arrGadgetsInItem = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)setObjectWithName:(NSString*)name andURL:(NSURL*)url andGadgets:(NSArray*)arrGadgets
{
	_strDbItemName = name;
	[_strDbItemName retain];
	_urlDbItem = url;
	[_urlDbItem retain];
	_arrGadgetsInItem = arrGadgets;
	[_arrGadgetsInItem retain];
}


- (void)dealloc {
    [_strDbItemName release];
    _strDbItemName = nil;
    
    [_urlDbItem release];
    _urlDbItem = nil;
    
    [_arrGadgetsInItem release];
    _arrGadgetsInItem = nil;
    
    [super dealloc];
}


@end
//============================================================================================================



@implementation Gadget

@synthesize _strName;
@synthesize _strDescription;
@synthesize _urlContent;
@synthesize _urlIcon;
@synthesize _imgIcon;
@synthesize _strID;


- (instancetype)init
{
	self = [super init];
	if(self)
	{
		_strName = [[NSString alloc] init];
		_strDescription = [[NSString alloc] init];
		_urlContent = [[NSURL alloc] init];
		_urlIcon = [[NSURL alloc] init];
		_imgIcon = [[UIImage alloc] init];
        _strID = [[NSString alloc] init];
	}
	return self;
}

- (void)dealloc {
    [_strName release];
    _strName = nil;
    
    [_strDescription release];
    _strDescription = nil;
    
    [_urlContent release];
    _urlContent = nil;
    
    [_urlIcon release];
    _urlIcon = nil;
    
    [_imgIcon release];
    _imgIcon = nil;
    
    [_strID release];
    _strID = nil;
    
    [super dealloc];
}

- (void)setObjectWithName:(NSString*)name 
			  description:(NSString*)description 
			   urlContent:(NSURL*)urlContent 
				  urlIcon:(NSURL*)urlIcon 
				imageIcon:(UIImage*)imageIcon
{
	if(name)
	{
		_strName = [name retain];
	}
	
	if(description != nil && ![description isEqualToString:@""])
	{	
		_strDescription = [description retain];
	}
	
	if(urlContent)
	{	
		_urlContent = [urlContent retain];
	}
	
	if(urlIcon)
	{	
		_urlIcon = [urlIcon retain];
	}
	
	if(imageIcon)
	{
		_imgIcon = [imageIcon retain];
	}	
	else
	{
		_imgIcon = [[UIImage imageNamed:@"GadgetsIcon.png"] retain];
	}
}

- (NSString*)name
{
	return _strName;
}

- (NSString*)description
{
	return _strDescription;
}

- (NSURL*)urlContent
{
	return _urlContent;
}

- (NSURL*)urlIcon
{
	return _urlIcon;
}

- (UIImage*)imageIcon
{
	return _imgIcon;
}

@end

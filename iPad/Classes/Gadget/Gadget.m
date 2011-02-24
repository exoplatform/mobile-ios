//
//  Gadget.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/10/10.
//  Copyright 2010 home. All rights reserved.
//

#import "Gadget.h"


@implementation GateInDbItem 
@synthesize _strDbItemName;
@synthesize _urlDbItem;
@synthesize _arrGadgetsInItem;

- (id)init
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

@end
//============================================================================================================



@implementation Gadget

@synthesize _strName;
@synthesize _strDescription;
@synthesize _urlContent;
@synthesize _urlIcon;
@synthesize _imgIcon;
@synthesize _strID;


- (id)init
{
	self = [super init];
	if(self)
	{
		_strName = [[NSString alloc] init];
		_strDescription = [[NSString alloc] init];
		_urlContent = [[NSURL alloc] init];
		_urlIcon = [[NSURL alloc] init];
		_imgIcon = [[UIImage alloc] init];
	}
	return self;
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



@implementation StandaloneGadget
@synthesize _strName;
@synthesize _urlContent;
@end


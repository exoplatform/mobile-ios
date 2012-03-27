//
//  eXoGadgetsViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/13/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#import "eXoGadgetsViewController.h"
#import "eXoUserClient.h"
#import "CXMLNode.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"
#import "eXoAppAppDelegate.h"

static NSString *kCellIdentifier = @"MyIdentifier";

@implementation eXoGadgetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		_exoUserClient = [[eXoUserClient alloc] init];
		_listOfGadgets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
	_listOfGadgets = [self getGadgetsList]; 
	
	eXoUserClient* exoUserClient = [eXoUserClient instance];

	[exoUserClient getGadgets:[_listOfGadgets objectAtIndex:0]];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	
	if (section == 0)
	{
		tmpStr = @"Gadgets";
	}	
	else if (section == 1)
	{
		tmpStr = @"Portlets";
	}
	
	return tmpStr;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int intNumberOfRowsInSection = 0; 
	if (section == 0)
	{
		// check for ipod/iphone
		if ([[[UIDevice currentDevice] model] compare:@"iPhone"] == NSOrderedSame || 
			[[[UIDevice currentDevice] model] compare:@"iPhone Simulator"] == NSOrderedSame)
		{
			intNumberOfRowsInSection = [_listOfGadgets count];
		}
		else
		{
			intNumberOfRowsInSection = [_listOfGadgets count];
		}
	}
	else if (section == 1)
	{
		intNumberOfRowsInSection = 2;
	}
	
	return intNumberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
		//[cell setFont:[UIFont systemFontOfSize:18.0]];
		//[cell setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	}
	
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];

	DisplayCell *tmpCell = [self obtainTableCellForRow:tableView at:row];
	[tmpCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
//	_detailDisclosureButtonType = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
//	_detailDisclosureButtonType.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
//	[_detailDisclosureButtonType addTarget:self action:@selector(action: withIndexOfSection:) forControlEvents:UIControlEventTouchUpInside];
	
	if (section == 0)
	{
		//tmpCell.image = [UIImage imageNamed:@"GadgetsIcon.png"];
		//tmpCell.text = @"Gadgets";
		tmpCell.view = _detailDisclosureButtonType;
	}
	else if (section == 1)
	{
		//tmpCell.image = [UIImage imageNamed:@"PortletsIcon.png"];
		//tmpCell.text = @"Portlets";
		tmpCell.view = _detailDisclosureButtonType;
	}

	cell = tmpCell;
	
	return cell;
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
	
	UIApplication* app = [UIApplication sharedApplication];
	id appDelegate = [app delegate];
	if(appDelegate && [appDelegate respondsToSelector:@selector(changeToEachGadgetViewController:)])
	{
		if(section == 0)
		{
			[appDelegate changeToEachGadgetViewController:[_listOfGadgets objectAtIndex:row]];
		}	
	}
}

// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row
- (DisplayCell *)obtainTableCellForRow:(UITableView*)myTableView at:(NSInteger)row
{
	DisplayCell *cell = nil;
	cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
	return cell;
}

//- (void)action:(id)sender withIndexOfSection:(int)index
//{
//	UIApplication* app = [UIApplication sharedApplication];
//	id appDelegate = [app delegate];
//	if(appDelegate && [appDelegate respondsToSelector:@selector(changeToEachGadgetViewController:)])
//	{
//		[appDelegate changeToEachGadgetViewController:[_listOfGadgets objectAtIndex:index]];
//	}
//}

- (NSMutableArray*)getGadgetsList
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSString *urlString = [domain stringByAppendingString:@"/rest/jcr/repository/gadgets"];
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	NSMutableData *responseData;
	NSMutableArray* tmpArr = [[NSMutableArray alloc] init];
	
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	if (urlData)
	{
		responseData = [[NSMutableData data] retain];
		[responseData setLength:0];
		[responseData appendData:urlData];
		
		NSMutableString *output = [NSMutableString stringWithCapacity:0];
		NSString* inString = [[[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] autorelease]; 
		[output appendString:inString];
		
		tmpArr = [self parseData:inString];	
	}  

	return tmpArr;
}

- (NSMutableArray*)parseData:(NSString*)dataStr;
{
	NSMutableArray* arrOutput = [[NSMutableArray alloc] init];
	[arrOutput removeAllObjects];

	NSString* tmpStr = dataStr;
	NSString* httpStr = @"";
	
	for (int i = 0; i < [tmpStr length]; i++)
	{
		NSRange r = [tmpStr rangeOfString:@"href="];
		
		if(r.length > 0)
		{
			tmpStr = [tmpStr substringFromIndex:r.location + 6];
		}
		else
		{
			break;
		}
		
		for (int j = 0; j < [tmpStr length]; j++)
		{
			NSRange httpStrRange;
			httpStrRange.location = 0;
			if ([tmpStr characterAtIndex:j] == '"')
			{
				httpStrRange.length = j;
				httpStr = [tmpStr substringWithRange:httpStrRange];
				[arrOutput addObject:httpStr];
				tmpStr = [tmpStr substringFromIndex:j + 1];
				i = 0;
				break;
			}
		}
	}
	return arrOutput;
}

- (void)parseXMLData:(NSData *)xmlData
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
	[parser parse];
	[parser release]; 
}
@end

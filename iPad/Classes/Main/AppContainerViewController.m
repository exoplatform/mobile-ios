//
//  AppContainerViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/9/10.
//  Copyright 2010 home. All rights reserved.
//

#import "AppContainerViewController.h"
#import "MainViewController.h"
#import "GadgetViewController.h"
#import "defines.h"
#import "Gadget.h"
#import "Connection.h"
#import "MessengerViewController.h"
#import "XMPPClient.h"

static NSString* kCellIdentifier = @"Cell";

@implementation AppContainerViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
		_gadgetViewController = [[GadgetViewController alloc] initWithNibName:@"GadgetViewController" bundle:nil];
		[_gadgetViewController setDelegate:self];
		
		_arrGateInDbItems = [[NSMutableArray alloc] init];
		_arrGadgets = [[NSMutableArray alloc] init];
		_bGrid = NO;
		_bExistGadget = NO;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	[_btnGrid setBackgroundImage:[UIImage imageNamed:@"GridView.png"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animate
{
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

- (UITableView*)getTableViewAppList
{
	return _tblAppList;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (Connection*)getConnection
{
	_connection = [_delegate getConnection];
	return _connection;
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];	 
	[_gadgetViewController localize];
	[_tblAppList reloadData];
}

- (void)setSelectedLanguage:(int)languageId
{
	[_delegate setSelectedLanguage:languageId];
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
	}
}

- (void)loadGadgets
{
	[self getConnection];
	_arrGateInDbItems = [self getItemsInDashboard];
	
	if([_arrGateInDbItems count] == 0)
	{	
		_bExistGadget = NO;
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"GadgetMessageTitle"]
//														message:[_dictLocalize objectForKey:@"GadgetMessageContent"]
//													   delegate:self 
//											  cancelButtonTitle:@"OK"
//											  otherButtonTitles: nil];
//		[alert show];
	}
	else
	{	
		_bExistGadget = YES;
		[_tblAppList addSubview:_btnGrid];
		for(int i = 0; i < [_arrGateInDbItems count]; i++)
		{
			if([[[_arrGateInDbItems objectAtIndex:i] _arrGadgetsInItem] count] == 0)
			{
				[_arrGateInDbItems removeObjectAtIndex:i];
				i = 0;
			}
		}
	}
	
	for (int i = 0; i < [_arrGateInDbItems count]; i++) 
	{
		GateInDbItem* tmpGateInDbItem = [_arrGateInDbItems objectAtIndex:i];
		if ([tmpGateInDbItem._arrGadgetsInItem count] > 0) 
		{
			break;
		}
	}
	if (_bExistGadget) 
	{
		[_btnGrid setHidden:NO];
		[_btnGrid setFrame:CGRectMake(280, 165, 30, 30)];
	}
	else 
	{
		[_btnGrid setHidden:YES];
	}
	
	[_tblAppList reloadData];
}


- (IBAction)onGridBtn:(id)sender
{
	_bGrid = !_bGrid;
	
	if(_bGrid)
	{  
		[_btnGrid setBackgroundImage:[UIImage imageNamed:@"ListView.png"] forState:UIControlStateNormal];
	}
	else 
	{
		[_btnGrid setBackgroundImage:[UIImage imageNamed:@"GridView.png"] forState:UIControlStateNormal];
	}
	
	[_gadgetViewController onGridBtn];
}


- (NSMutableArray*)getItemsInDashboard
{
	NSMutableArray* arrDbItems = [[NSMutableArray alloc] init];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];	

	NSString* strContent = [_connection getFirstLoginContent];
	
	NSRange range1;
	NSRange range2;
	NSRange range3;
	range1 = [strContent rangeOfString:@"DashboardIcon TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringFromIndex:range1.location + range1.length];
	range1 = [strContent rangeOfString:@"TBIcon"];
	
	if(range1.length <= 0)
		return nil;
	
	strContent = [strContent substringToIndex:range1.location];
	
	do 
	{
		range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		range2 = [strContent rangeOfString:@"\" >"];
		
		if (range1.length > 0 && range2.length > 0) 
		{
			NSString *gadgetTabUrlStr = [strContent substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
			NSURL *gadgetTabUrl = [NSURL URLWithString:gadgetTabUrlStr];
			
			strContent = [strContent substringFromIndex:range2.location + range2.length];
			range3 = [strContent rangeOfString:@"</a>"];
			
			NSString *gadgetTabName = [strContent substringToIndex:range3.location]; 
			NSArray* arrTmpGadgetsInItem = [[NSArray alloc] init];
			arrTmpGadgetsInItem = [self listOfGadgetsWithURL:[domain stringByAppendingFormat:@"%@", gadgetTabUrlStr]];
			GateInDbItem* tmpGateInDbItem = [[GateInDbItem alloc] init];
			[tmpGateInDbItem setObjectWithName:gadgetTabName andURL:gadgetTabUrl andGadgets:arrTmpGadgetsInItem];
			[arrDbItems addObject:tmpGateInDbItem];
			
			strContent = [strContent substringFromIndex:range3.location];
			range1 = [strContent rangeOfString:@"ItemIcon DefaultPageIcon\" href=\""];
		}	
	} 
	while (range1.length > 0);
	
	return arrDbItems;

}

-(NSString *)getStringForGadget:(NSString *)gadgetStr startStr:(NSString *)startStr endStr:(NSString *)endStr
{
	NSString *returnValue = @"";
	NSRange range1;
	NSRange range2;
	
	range1 = [gadgetStr rangeOfString:startStr];
	
	if(range1.length > 0)
	{
		NSString *tmpStr = [gadgetStr substringFromIndex:range1.location + range1.length];
		range2 = [tmpStr rangeOfString:endStr];
		if(range2.length > 0)
		{
			returnValue = [tmpStr substringToIndex:range2.location];
		}
	}
	
	return [returnValue retain];
}

- (NSArray*)listOfGadgetsWithURL:(NSString *)url
{
	NSMutableArray* arrTmpGadgets = [[NSMutableArray alloc] init];
	
	NSString* strGadgetName;
	NSString* strGadgetDescription;
	NSURL* urlGadgetContent;
	UIImage* imgGadgetIcon;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSMutableString* strContent;
	
//	NSRange rangeOfSocial = [domain rangeOfString:@"social"];
//	if (rangeOfSocial.length > 0) 
//	{
//		//dataReply = [[_delegate getConnection] sendRequestToSocialToGetGadget:[url absoluteString]];
//	}
//	else
//	{
//		NSData *data = [[_delegate getConnection] sendRequestToGetGadget:url];
//		strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//		//dataReply = [[_delegate getConnection] sendRequestWithAuthorization:[url absoluteString]];
//		//dataReply = [[_delegate getConnection] sendRequestToGetGadget:[url absoluteString]];
//	}

	NSData *data = [[_delegate getConnection] sendRequestToGetGadget:url];
	strContent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSRange range1;
	NSRange range2;
	
	range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
	if(range1.length <= 0)
		return nil;
	
	do 
	{
		strContent = (NSMutableString *)[strContent substringFromIndex:range1.location + range1.length];
		range2 = [strContent rangeOfString:@"'/eXoGadgetServer/gadgets',"];
		if (range2.length > 0) 
		{
			NSString *tmpStr = [strContent substringToIndex:range2.location + range2.length + 10];

			strGadgetName = [self getStringForGadget:tmpStr startStr:@"\"title\":\"" endStr:@"\","]; 
			strGadgetDescription = [self getStringForGadget:tmpStr startStr:@"\"description\":\"" endStr:@"\","];
			NSString *gadgetIconUrl = [self getStringForGadget:tmpStr startStr:@"\"thumbnail\":\"" endStr:@"\","];
			if([gadgetIconUrl isEqualToString:@""])
				imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
			else
			{
				imgGadgetIcon = [UIImage imageWithData:[[_delegate getConnection] sendRequest:gadgetIconUrl]];
				if(imgGadgetIcon == nil)
				{	
					NSRange range3 = [gadgetIconUrl rangeOfString:@"://"];
					if(range3.length == 0)
					{
						strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
						range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
						continue;
					}
					
					gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location + range3.length];
					range3 = [gadgetIconUrl rangeOfString:@"/"];
					gadgetIconUrl = [gadgetIconUrl substringFromIndex:range3.location];
					//gadgetIconUrl = [NSString stringWithFormat:@"%@%@", domain, gadgetIconUrl];		
					NSString* tmpGGIC= [NSString stringWithFormat:@"%@%@", domain, gadgetIconUrl];		
					imgGadgetIcon = [UIImage imageWithData:[[_delegate getConnection] sendRequest:tmpGGIC]];
					if(imgGadgetIcon == nil)
					{
						imgGadgetIcon = [UIImage imageNamed:@"PortletsIcon.png"];
					}	
				}
			}
		
			NSMutableString *gadgetUrl = [[NSMutableString alloc] initWithString:@""];
			[gadgetUrl appendString:domain];
		
			[gadgetUrl appendFormat:@"%@/", [self getStringForGadget:tmpStr startStr:@"'home', '" endStr:@"',"]];
			[gadgetUrl appendFormat:@"ifr?container=default&mid=1&nocache=0&lang=%@&debug=1&st=default", [self getStringForGadget:tmpStr startStr:@"&lang=" endStr:@"\","]];
		
			NSString *token = [NSString stringWithFormat:@":%@", [self getStringForGadget:tmpStr startStr:@"\"default:" endStr:@"\","]];
			token = [token stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			token = [token stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
			token = [token stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
		
		
			[gadgetUrl appendFormat:@"%@&url=", token];
		
			NSString *gadgetXmlFile = [self getStringForGadget:tmpStr startStr:@"\"url\":\"" endStr:@"\","];
			gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
			gadgetXmlFile = [gadgetXmlFile stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
		
			[gadgetUrl appendFormat:@"%@", gadgetXmlFile];
		
			urlGadgetContent = [NSURL URLWithString:gadgetUrl];
		
			Gadget* gadget = [[Gadget alloc] init];
		
			[gadget setObjectWithName:strGadgetName description:strGadgetDescription urlContent:urlGadgetContent urlIcon:nil imageIcon:imgGadgetIcon];
			[arrTmpGadgets addObject:gadget];
		
			strContent = (NSMutableString *)[strContent substringFromIndex:range2.location + range2.length];
			range1 = [strContent rangeOfString:@"eXo.gadget.UIGadget.createGadget"];
		}	
		
	} while (range1.length > 0);
	
	return arrTmpGadgets;
}

//- (void)onGadgetTableViewCell:(NSURL*)gadgetUrl
//{
//	[_delegate startGadget:gadgetUrl];
//}
																												
- (void)onGadget:(Gadget*)gadget
{
	[_delegate startGadget:gadget];	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	int numberOfSections = 0;
	
	if(_bExistGadget)
	{
		numberOfSections = 2;
	}
	else
	{
		numberOfSections = 1;
	}
	return numberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	int height = 0;
	
	switch (indexPath.section) 
	{
		case 0:
		{
			height = 60;
			break;
		}
		case 1:
		{
			height = 455;
			break;
		}
			
		default:
			break;
	}
	return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	switch (section) 
	{
		case 0:
		{
			tmpStr = @"Applications";
			break;
		}
		case 1:
		{
			tmpStr = @"Dashboard";
			break;
		}
			
		default:
			break;
	}
	return tmpStr;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numOfRows = 0;
	switch (section) 
	{
		case 0:
		{
			numOfRows = 2;
			break;
		}
		case 1:
		{
			numOfRows = 1;
			break;
		}
			
		default:
			break;
	}
	return numOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
  		
	switch (indexPath.section) 
	{
		case 0:
		{
			UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 230.0, 20.0)];
			lbTitle.backgroundColor = [UIColor clearColor];
			lbTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
			[cell addSubview:lbTitle];
			
			/*
			UILabel* lbDescription = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 25.0, 230.0, 33.0)];
			lbDescription.backgroundColor = [UIColor clearColor];
			lbDescription.numberOfLines = 2;
			lbDescription.font = [UIFont fontWithName:@"Helvetica" size:12.0];
			[cell addSubview:lbDescription];
			*/
			
			UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 5.0, 50, 50)];
			[cell addSubview:imgV];
			
			switch (indexPath.row) 
			{
				case 0:
				{
					lbTitle.text = @"Chat";		
					//lbDescription.text = [_dictLocalize objectForKey:@"ChatDescription"];
					XMPPClient *client = [MessengerViewController getXmppClient];
					if(client != nil && [client isAuthenticated])
						imgV.image = [UIImage imageNamed:@"onlineicon.png"];
					else
						imgV.image = [UIImage imageNamed:@"offlineicon.png"];
					
					break;
				}
				
				case 1:
				{
					lbTitle.text = @"Files";
					//lbDescription.text = [_dictLocalize objectForKey:@"FileDescription"];
					imgV.image = [UIImage imageNamed:@"filesApp.png"];
					break;
				}
					
				default:
					break;
			}
			
			break;
		}
		
		case 1:
		{
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			switch (indexPath.row) 
			{
				case 0:
				{					
					[[_gadgetViewController view] setFrame:CGRectMake(15.0, 5.0, 290, 445)];
					[_gadgetViewController loadGateInDbItems:_arrGateInDbItems];
					[cell addSubview:[_gadgetViewController view]];
					UIButton* bg = [[UIButton alloc] initWithFrame:[cell frame]];
					[bg setUserInteractionEnabled:NO];
					[bg setBackgroundImage:[UIImage imageNamed:@"GadgetsContainerBackground.png"] forState:UIControlStateNormal];
					[cell setBackgroundView:bg];
					break;
				}	
				default:
					break;
			}
			
			break;
		}
			
		default:
			break;
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	switch (indexPath.section) 
	{
		case 0:
		{
			switch (indexPath.row) 
			{
				case 0:
				{
					[_delegate startMessengerApplication];
					break;
				}
					
				case 1:
				{
					[_delegate startFilesApplication];
					break;
				}
					
				default:
					break;
			}
			
			break;
		}
		
		default:
			break;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

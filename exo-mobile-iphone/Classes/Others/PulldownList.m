//
//  PulldownList.m
//  CustomControl
//
//  Created by Le van Thang on 10/2/08.
//  Copyright 2008 AVASYS Vietnam. All rights reserved.
//

#import "PulldownList.h"

static NSString *MyIdentifier = @"PulldownList";

@implementation PulldownList

@synthesize myTableView;
@synthesize scrollIndicator;

- (id)initWithCoder:(NSCoder*)coder
{
	if((self = [super initWithCoder:coder])) {
	}
	
	return self;
}


- (void) awakeFromNib
{
	_list = [[NSArray arrayWithObjects:
			  @"AL", //Alabama
			  @"AK", //Alaska
			  @"AZ", //Arizona
			  @"AR", //Arkansas
			  @"CA", //California
			  @"CO", //Colorado
			  @"CT", //Connecticut
			  @"DE", //Delaware
			  @"DC", //District of Columbia
			  @"FL", //Florida
			  @"GA", //Georgia
			  @"HI", //Hawaii
			  @"ID", //Idaho
			  @"IL", //Illinois
			  @"IN", //Indiana
			  @"IA", //Iowa
			  @"KS", //Kansas
			  @"KY", //Kentucky
			  @"LA", //Louisiana
			  @"ME", //Maine
			  @"MD", //Maryland
			  @"MA", //Massachusetts
			  @"MI", //Michigan
			  @"MN", //Minnesota
			  @"MS", //Missisippi
			  @"MO", //Missouri
			  @"MT", //Montana
			  @"NE", //Nebraska
			  @"NV", //Nevada
			  @"NH", //New hampshire
			  @"NJ", //New Jersey
			  @"NM", //New Mexico
			  @"NY", //New York
			  @"NC", //North Carolina
			  @"ND", //North Dakota
			  @"OH", //Ohio
			  @"OK", //Oklahoma
			  @"OR", //Oregon
			  @"PA", //Pennsylvania
			  @"RI", //Rhode Island
			  @"SC", //South Carolina
			  @"SD", //South Dakota
			  @"TN", //Tennessee
			  @"TX", //Texas
			  @"UT", //Utah
			  @"VT", //Vermont
			  @"VA", //Virginia
			  @"WA", //Washington
			  @"WV", //West verginia
			  @"WI", //Wisconsin
			  @"WY", //Wyoming
			  nil] retain];
	
	CGRect frame = self.frame;
	frame.origin.y += (frame.size.height + 3);
	frame.origin.x -= 1;
	
	int height = [_list count]*25;
	
	frame.size.height = height < 100 ? height: 100;
	frame.size.width = 90;
	
	myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = YES; 
	myTableView.showsVerticalScrollIndicator = NO;
	myTableView.showsHorizontalScrollIndicator = NO;
	
	myTableView.hidden = YES;
	myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pulldown_bg.png"]];
	[[self superview] addSubview: myTableView];
	
	[self setTitle:[_list objectAtIndex:0] forState:UIControlStateNormal];
	[self setTitle:[_list objectAtIndex:0] forState:UIControlStateHighlighted];
	
	scrollIndicator = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"scrollindicator.png"]];
	scrollIndicator.frame = CGRectMake(frame.origin.x + 82, frame.origin.y + 2, scrollIndicator.frame.size.width, scrollIndicator.frame.size.height);
	[[self superview] addSubview: scrollIndicator];
	scrollIndicator.hidden = YES;
}

- (void) dealloc
{
	[myTableView release];
	[scrollIndicator release];
	[_list release];
	[super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan: touches withEvent: event];
	myTableView.hidden = !myTableView.hidden;
	scrollIndicator.hidden = !scrollIndicator.hidden;
	if(! myTableView.hidden)
	{
		if([myTableView indexPathForSelectedRow] == nil)
		{
			[myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
		}
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSInteger count = 0;
	if(_list)
	{
		count = [_list count];
	}
	
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result = 25.0;
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 24) reuseIdentifier:MyIdentifier] autorelease];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	}
	
	int row = indexPath.row;
	cell.textLabel.text = [NSString stringWithFormat:@"         %@", [_list objectAtIndex: row]];

	// Set up the cell
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	myTableView.hidden = YES;
	scrollIndicator.hidden = YES;
	[self setTitle:[_list objectAtIndex:indexPath.row] forState:UIControlStateNormal];
	[self setTitle:[_list objectAtIndex:indexPath.row] forState:UIControlStateHighlighted];
	
}

- (NSString*)nameOfselectedRow
{
	NSString* name = nil;
	if(myTableView)
	{
		NSIndexPath* path = [myTableView indexPathForSelectedRow];
		if(path)
		{
			if(_list && ([_list count] > path.row))
			{
				name = [_list objectAtIndex: path.row];
			}
		}
	}
	
	return name;
}

- (NSInteger) selectedRow
{
	NSInteger row = 0;
	if(myTableView)
	{
		NSIndexPath* path = [myTableView indexPathForSelectedRow];
		if(path)
		{
			row = path.row;
		}
	}
	
	return row;
}

- (void) selectRow: (NSInteger) row
{
	if(_list && (row < [_list count]))
	{
		[self setTitle:[_list objectAtIndex:row] forState:UIControlStateNormal];
		[self setTitle:[_list objectAtIndex:row] forState:UIControlStateHighlighted];
		[myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView               // any offset changes
{
	float offset = myTableView.frame.size.height*0.65*scrollView.contentOffset.y/scrollView.contentSize.height;
	if(self.frame.origin.y + 32 + offset + scrollIndicator.frame.size.height <= myTableView.frame.origin.y + myTableView.frame.size.height)
	{
		scrollIndicator.frame = CGRectMake(scrollIndicator.frame.origin.x, self.frame.origin.y + 32 + offset, scrollIndicator.frame.size.width, scrollIndicator.frame.size.height);
	}
	else
	{
		scrollIndicator.frame = CGRectMake(scrollIndicator.frame.origin.x, myTableView.frame.origin.y + myTableView.frame.size.height - scrollIndicator.frame.size.height, scrollIndicator.frame.size.width, scrollIndicator.frame.size.height);
	}	
}

@end

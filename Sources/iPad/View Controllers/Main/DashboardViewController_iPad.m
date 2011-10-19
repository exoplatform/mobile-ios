//
//  DashboardViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "DashboardViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "GadgetDisplayViewController_iPad.h"
#import "Gadget.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "LanguageHelper.h"

@implementation DashboardViewController_iPad

#define kHeightForSectionHeader 40

-(void)viewDidLoad {
    [super viewDidLoad];
    _navigation.topItem.title = Localize(@"Dashboard");
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if([[[_arrTabs objectAtIndex:section] _arrGadgetsInItem] count] == 0){
        return 0;
    }
    return kHeightForSectionHeader;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if([[[_arrTabs objectAtIndex:section] _arrGadgetsInItem] count] == 0){
        return nil;
    }
    // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, _tblGadgets.frame.size.width-5, kHeightForSectionHeader)];
	
	// create the label object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    headerLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    headerLabel.shadowOffset = CGSizeMake(0,1);
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.text = [[_arrTabs objectAtIndex:section] _strDbItemName];
    
    CGSize theSize = [headerLabel.text sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(_tblGadgets.frame.size.width-5, CGFLOAT_MAX) 
                                      lineBreakMode:UILineBreakModeWordWrap];
    headerLabel.frame = CGRectMake(55.0, 11.0, theSize.width, kHeightForSectionHeader);
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"DashboardTabBackground.png"];
    UIImageView *imgVBackground = [[UIImageView alloc] initWithImage:[imgForSection stretchableImageWithLeftCapWidth:5 topCapHeight:7]];
    imgVBackground.frame = CGRectMake(45, 16.0, theSize.width + 20, kHeightForSectionHeader-15);
    
	[customView addSubview:imgVBackground];
    [imgVBackground release];
    
    [customView addSubview:headerLabel];
    [headerLabel release];
    
	return [customView autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString* kCellIdentifier = @"Cell";
	
    //We dequeue a cell
	CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    //Check if we found a cell
    if (cell==nil) 
    {
        
        //Not found, so create a new one
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        //Add subviews only one time, and use the propertie 'Tag' of UIView to retrieve them
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 3.0, 310.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:106.0/255 green:109.0/255 blue:112.0/255 alpha:1];
        //define the tag for the titleLabel
        titleLabel.tag = kTagForCellSubviewTitleLabel; 
        [cell.contentView addSubview:titleLabel];
        //release the titleLabel because cell retain it now
        [titleLabel release];
        
        //Create the descriptionLabel
        UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 20.0, 310.0, 33.0)];
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textColor = [UIColor colorWithRed:152.0/255 green:155.0/255 blue:160.0/255 alpha:1];
        descriptionLabel.tag = kTagForCellSubviewDescriptionLabel;
        [cell.contentView addSubview:descriptionLabel];
        [descriptionLabel release];
        
        //Create the imageView
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 7.0, 45, 45)];
        imgView.tag = kTagForCellSubviewImageView;
        [cell.contentView addSubview:imgView];
        [imgView release];
        
    }
    
    
    //Configurate the cell
    //Configurate the titleLabel and assign good value
	UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:kTagForCellSubviewTitleLabel];
    titleLabel.text = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] name];
    
	//Configuration the DesriptionLabel
    UILabel *descriptionLabel = (UILabel*)[cell.contentView viewWithTag:kTagForCellSubviewDescriptionLabel];
	descriptionLabel.text = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description];
	NSLog(@"%@", [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] description]);
    //Configuration of the ImageView
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:kTagForCellSubviewImageView];
    imgView.image = [[[[_arrTabs objectAtIndex:indexPath.section] _arrGadgetsInItem] objectAtIndex:indexPath.row] imageIcon];
    [self customizeAvatarDecorations:imgView];
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    GateInDbItem *gadgetTab = [_arrTabs objectAtIndex:indexPath.section];
	Gadget *gadget = [gadgetTab._arrGadgetsInItem objectAtIndex:indexPath.row];
	NSURL *tmpURL = gadget._urlContent;
    
    GadgetDisplayViewController_iPad* gadgetDisplayViewController = [[GadgetDisplayViewController_iPad alloc] initWithNibName:@"GadgetDisplayViewController_iPad" bundle:nil];
    gadgetDisplayViewController.title = [gadget name];
    [gadgetDisplayViewController setUrl:tmpURL];
    
    // push the gadgets
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:gadgetDisplayViewController invokeByController:self isStackStartView:FALSE];

}



- (void)setHudPosition {
    _hudDashboard.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}




@end

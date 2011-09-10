//
//  DocumentsViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "DocumentsViewController_iPad.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "FileActionsViewController.h"
#import "DocumentDisplayViewController_iPad.h"


@implementation DocumentsViewController_iPad


#pragma mark - Object management

//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile {
    if ((self = [super initWithNibName:@"DocumentsViewController_iPad" bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}


#pragma mark - HUD Management

- (void)setHudPosition {
    _hudFolder.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}


#pragma mark - UIViewController methods


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    
    //Add the UIBarButtonItem for actions on the NavigationBar of the Controller
    UIBarButtonItem* bbtnActions = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(showActionsPanelFromNavigationBarButton)];
    
    [_navigationBar.topItem setRightBarButtonItem:bbtnActions];
    
    [bbtnActions release];

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



#pragma mark - UINavigationBar Management

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        _navigationBar.topItem.title = _rootFile.fileName;
    } else {
        _navigationBar.topItem.title = @"Documents";
    }
}
 
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                                       bundle:nil 
                                                                                                         file:_rootFile 
                                                                                       enableDeleteThisFolder:YES
                                                                                                     delegate:self];
    
    fileActionsViewController.fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row];

    //Getting the position of the cell in the tableView
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    //Adjust the position for the PopoverController, in Y
    rect.origin.x = tableView.frame.size.width - 25;
    
    //Display the UIPopoverController
	_actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    _actionPopoverController.delegate = self;
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 320) animated:YES];
	[_actionPopoverController presentPopoverFromRect:rect inView:tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];		


    [fileActionsViewController release];

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPad to push it into the navigationController
        DocumentsViewController_iPad *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPad alloc] initWithRootFile:fileToBrowse];
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:newViewControllerForFilesBrowsing invokeByController:self isStackStartView:FALSE];
        
        [newViewControllerForFilesBrowsing release];
	}
	else
	{
        
        NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.urlStr stringByReplacingOccurrencesOfString:@" " 
                                                                                                        withString:@"%20"]];
		DocumentDisplayViewController_iPad* contentViewController = [[DocumentDisplayViewController_iPad alloc] initWithNibAndUrl:@"DocumentDisplayViewController_iPad"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.fileName];
		
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:contentViewController invokeByController:self isStackStartView:FALSE];
        
        [contentViewController release];
        
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];   
}



#pragma mark - Panel Actions
-(void) showActionsPanelFromNavigationBarButton {
    
    //Create the fileActionsView controller
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                                       bundle:nil 
                                                                                                         file:_rootFile 
                                                                                       enableDeleteThisFolder:YES
                                                                                                     delegate:self];
    
    
    //Create the Popover to display potential actions to the user
    _actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    //set its size
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 320) animated:YES];
    //set its delegate
    _actionPopoverController.delegate = self;
    //present the popover from the rightBarButtonItem of the navigationBar
	[_actionPopoverController presentPopoverFromBarButtonItem:_navigationBar.topItem.rightBarButtonItem 
                                     permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                     animated:YES];
    
    //Release the useless controller
    [fileActionsViewController release];
    
    //Prevent any new tap on the button
    _navigationBar.topItem.rightBarButtonItem.enabled = NO;
}

-(void) hideActionsPanel {
    //Enable the button on the navigationBar
    _navigationBar.topItem.rightBarButtonItem.enabled = YES;
    
    //Dismiss the popover
    [_actionPopoverController dismissPopoverAnimated:YES];
}


- (void)hideFileFolderActionsController {
    //[_maskingViewForActions removeFromSuperview];
    [super hideFileFolderActionsController];
}


#pragma - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    //Enable the button on the navigationBar
    _navigationBar.topItem.rightBarButtonItem.enabled = YES;
    
    
    //Release the _actionPopoverController
    [_actionPopoverController release];
    _actionPopoverController = nil;

}
 
@end

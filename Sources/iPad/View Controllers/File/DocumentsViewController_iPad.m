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
#import "FileFolderActionsViewController_iPad.h"
#import "DocumentDisplayViewController_iPad.h"
#import "StackScrollViewController.h"
#import "LanguageHelper.h"


@implementation DocumentsViewController_iPad


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
    UIImage *image = [UIImage imageNamed:@"DocumentNavigationBarActionButton.png"];
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:image forState:UIControlStateNormal];
    bt.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [bt addTarget:self action:@selector(showActionsPanelFromNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
    actionButton.width = image.size.width;
    [_navigation.topItem setRightBarButtonItem:actionButton];
    
    [actionButton release];
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

-(void)dealloc {
    if(_actionPopoverController != nil){
        [_actionPopoverController release];
    }
    [super dealloc];
}

#pragma mark - UINavigationBar Management

- (void)setTitleForFilesViewController {
//    if (_rootFile) {
//        _navigationBar.topItem.title = _rootFile.fileName;
//    } else {
//        _navigationBar.topItem.title = Localize(@"Documents") ;
//    }
}
#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.tag inSection:0];
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                                       bundle:nil 
                                                                                                         file:_rootFile 
                                                                                       enableDeleteThisFolder:YES
                                                                                                     delegate:self];
    
    fileActionsViewController.fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
    
    //Getting the position of the cell in the tableView
    CGRect rect = [_tblFiles rectForRowAtIndexPath:indexPath];
    //Adjust the position for the PopoverController, in Y
    rect.origin.x = _tblFiles.frame.size.width - 25;
    
    displayActionDialogAtRect = rect;
    
    //Display the UIPopoverController
	_actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    _actionPopoverController.delegate = self;
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
	[_actionPopoverController presentPopoverFromRect:rect inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];		
    
    
    [fileActionsViewController release];
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
    
    displayActionDialogAtRect = rect;
    
    //Display the UIPopoverController
	_actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    _actionPopoverController.delegate = self;
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
	[_actionPopoverController presentPopoverFromRect:rect inView:tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];		


    [fileActionsViewController release];

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
    
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:self];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPad to push it into the navigationController
        DocumentsViewController_iPad *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPad alloc] initWithRootFile:fileToBrowse withNibName:@"DocumentsViewController_iPad"];
        newViewControllerForFilesBrowsing.title = fileToBrowse.fileName;
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:newViewControllerForFilesBrowsing invokeByController:self isStackStartView:FALSE];
        
        [newViewControllerForFilesBrowsing release];
	}
	else
	{
        NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[URLAnalyzer enCodeURL:fileToBrowse.urlStr]];
        
		DocumentDisplayViewController_iPad* contentViewController = [[DocumentDisplayViewController_iPad alloc] initWithNibAndUrl:@"DocumentDisplayViewController_iPad"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.fileName];
		
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:contentViewController invokeByController:self isStackStartView:FALSE];
        
        [contentViewController release];
        
    }
}



#pragma mark - Panel Actions
-(void) showActionsPanelFromNavigationBarButton:(id)sender {
    
    //Create the fileActionsView controller
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                                       bundle:nil 
                                                                                                         file:_rootFile 
                                                                                       enableDeleteThisFolder:YES
                                                                                                     delegate:self];
    
    
    //Create the Popover to display potential actions to the user
    _actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    //set its size
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
    //set its delegate
    _actionPopoverController.delegate = self;
    //present the popover from the rightBarButtonItem of the navigationBar
	[_actionPopoverController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem 
                                     permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                     animated:YES];
    
    //Release the useless controller
    [fileActionsViewController release];
    
    //Prevent any new tap on the button
    _navigation.topItem.rightBarButtonItem.enabled = NO;
}

-(void) hideActionsPanel {
    //Enable the button on the navigationBar
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
    //Dismiss the popover
    [_actionPopoverController dismissPopoverAnimated:YES];
}


//SLM Temporary
-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    
    [_actionPopoverController dismissPopoverAnimated:YES];
    
    //Get the controller of the popover
    FileActionsViewController *fileActionViewController = (FileActionsViewController*) _actionPopoverController.contentViewController;
    
    _fileFolderActionsController = [[FileFolderActionsViewController_iPad alloc] initWithNibName:@"FileFolderActionsViewController_iPad" bundle:nil];
    //[_optionsViewController setDelegate:self];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = fileActionViewController.fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    //Give a good position to the popup
    _fileFolderActionsController.view.center = CGPointMake(_tblFiles.center.x, 150);
    
    //Block interactions with the table view
    _tblFiles.userInteractionEnabled = NO;
    
    //_optionsViewController.view.hidden = YES;
    [self.view addSubview:_fileFolderActionsController.view];
}



- (void)hideFileFolderActionsController {
    //Unblock interactions with the table view
    _tblFiles.userInteractionEnabled = YES;
    
    [super hideFileFolderActionsController];
    
    
    //Enable the button on the navigationBar
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
}


#pragma - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    //Enable the button on the navigationBar
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
    
    //Release the _actionPopoverController
    [_actionPopoverController release];
    _actionPopoverController = nil;

}
 
  
@end

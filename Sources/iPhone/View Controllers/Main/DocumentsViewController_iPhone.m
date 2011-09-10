//
//  DocumentsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController_iPhone.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for DocumentsViewController_iPhone
// ================================
@implementation DocumentsViewController_iPhone




//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile {
    if ((self = [super initWithNibName:@"DocumentsViewController_iPhone" bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}


- (void)dealloc
{
    [_actionsViewController release];
    _actionsViewController = nil;
    
    [super dealloc];
}



#pragma mark - UINavigationBar Management

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.fileName;
    } else {
        self.title = @"Documents";
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPhone to push it into the navigationController
        DocumentsViewController_iPhone *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPhone alloc] initWithRootFile:fileToBrowse];
        [self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
	}
	else
	{
		NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.urlStr stringByReplacingOccurrencesOfString:@" " 
                                                                                                        withString:@"%20"]];
		DocumentDisplayViewController_iPhone* fileWebViewController = [[DocumentDisplayViewController_iPhone alloc] initWithNibAndUrl:@"DocumentDisplayViewController_iPhone"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.fileName];
		[self.navigationController pushViewController:fileWebViewController animated:YES];    
        
        [fileWebViewController release];
	}
	
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                    bundle:nil 
                                                                                      file:[_arrayContentOfRootFile objectAtIndex:indexPath.row] 
                                                                    enableDeleteThisFolder:YES
                                                                                  delegate:self];
        if (_maskingViewForActions ==nil) {
            _maskingViewForActions = [[UIView alloc] initWithFrame:self.view.frame];
            _maskingViewForActions.backgroundColor = [UIColor blackColor];
            _maskingViewForActions.alpha = 0.45;
            
            //Add a Gesture Recognizer to remove the FileActionsPanel 
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionsPanel)];
            [_maskingViewForActions addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        
    }
    
    _actionsViewController.fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row] ;
    
    [self.view addSubview:_maskingViewForActions];
    
    _containerView = [[UIView alloc] initWithFrame:self.view.frame];
    _containerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_containerView];
	[_containerView addSubview:_actionsViewController.view];
    _tblFiles.scrollEnabled = NO;


}



-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    _fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    //[_optionsViewController setDelegate:self];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = _actionsViewController.fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    //_optionsViewController.view.hidden = YES;
    [self.view addSubview:_fileFolderActionsController.view];
    [_actionsViewController.view removeFromSuperview]; 
}


#pragma mark - Panel Actions

-(void) showActionsPanelFromNavigationBarButton {

    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                                    bundle:nil 
                                                                                      file:_rootFile 
                                                                    enableDeleteThisFolder:YES
                                                                                  delegate:self];
        if (_maskingViewForActions ==nil) {
            _maskingViewForActions = [[UIView alloc] initWithFrame:self.view.frame];
            _maskingViewForActions.backgroundColor = [UIColor blackColor];
            _maskingViewForActions.alpha = 0.45;
            
            //Add a Gesture Recognizer to remove the FileActionsPanel 
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideActionsPanel)];
            [_maskingViewForActions addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        
    }
    
    _actionsViewController.fileToApplyAction = _rootFile ;
    
    [self.view addSubview:_maskingViewForActions];
	[self.view addSubview:_actionsViewController.view];
    _tblFiles.scrollEnabled = NO;

}



-(void) hideActionsPanel {
    [_actionsViewController.view removeFromSuperview];
    [_maskingViewForActions removeFromSuperview];
    _tblFiles.scrollEnabled = YES;
}


- (void)hideFileFolderActionsController {
    [_maskingViewForActions removeFromSuperview];
    _tblFiles.scrollEnabled = YES;
    [super hideFileFolderActionsController];
}




@end

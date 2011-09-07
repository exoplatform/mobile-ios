//
//  DocumentsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController_iPhone.h"
#import "eXoWebViewController.h"
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
		eXoWebViewController* fileWebViewController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.fileName];
		[self.navigationController pushViewController:fileWebViewController animated:YES];     
	}
	
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController_iPhone alloc] initWithNibName:@"FileActionsViewController_iPhone" 
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
    self.tableView.scrollEnabled = NO;


}



//SLM Temporary
-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    
    
    _fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    //[_optionsViewController setDelegate:self];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.delegate = self;
    
    //_optionsViewController.view.hidden = YES;
    [self.view addSubview:_fileFolderActionsController.view];
    [_actionsViewController.view removeFromSuperview];
    
    /*

    [UIView animateWithDuration:1.5 
                          delay:0 
                        options:UIViewAnimationOptionTransitionFlipFromLeft 
                     animations:^(void) { 
                         [_actionsViewController.view removeFromSuperview];
                         _optionsViewController.view.hidden = NO;
                     } 
                     completion:NULL
     ];
    [UIView transitionFromView:_actionsViewController.view 
                        toView:_optionsViewController.view 
                      duration:1 
                       options:UIViewAnimationOptionTransitionFlipFromLeft 
                    completion:^(BOOL finished) {
        
    }];
    */
    /*
    
    [UIView transitionWithView:_containerView duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^ { 
                        [_actionsViewController.view removeFromSuperview];
                        _optionsViewController.view.hidden = NO;
                        //[_containerView addSubview:_optionsViewController.view];
                    }
                    completion:nil];
 
    */ 

    
    
    
}


#pragma mark - Panel Actions

-(void) showActionsPanelFromNavigationBarButton {

    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController_iPhone alloc] initWithNibName:@"FileActionsViewController_iPhone" 
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
    self.tableView.scrollEnabled = NO;

}



-(void) hideActionsPanel {
    [_actionsViewController.view removeFromSuperview];
    [_maskingViewForActions removeFromSuperview];
    self.tableView.scrollEnabled = YES;
}


- (void)hideFileFolderActionsController {
    [_maskingViewForActions removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    [super hideFileFolderActionsController];
}



#pragma mark - ATMHud Delegate
#pragma mark -
#pragma mark ATMHudDelegate
- (void)userDidTapHud:(ATMHud *)_hud {
	[_hud hide];
}




@end

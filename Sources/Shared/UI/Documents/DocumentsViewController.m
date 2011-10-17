//
//  DocumentsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"
#import "LanguageHelper.h"
#import "NSString+HTML.h"
#import "DataProcess.h"
#import "EmptyView.h"


#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333
#define TAG_EMPTY 111

#pragma mark -
#pragma mark Private

// =================================
// = Interface for private methods
// =================================
@interface DocumentsViewController (PrivateMethods)

- (void)startRetrieveDirectoryContent;
- (void)setTitleForFilesViewController;
- (void)contentDirectoryIsRetrieved;
- (void)hideActionsPanel;
- (void)hideFileFolderActionsController;
- (void)showHUDWithMessage:(NSString *)message;

@end



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for FilesViewController_iPhone
// ================================
@implementation DocumentsViewController

- (id) initWithRootFile:(File *)rootFile withNibName:(NSString *)nibName  {
    if ((self = [super initWithNibName:nibName bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}

// =====================================
// = Implementation of private methods
// =====================================
-(void)startRetrieveDirectoryContent {
    
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
    
    if (_filesProxy == nil) _filesProxy = [FilesProxy sharedInstance];
    
    if (_rootFile == nil) _rootFile = [_filesProxy initialFileForRootDirectory];
    
    _arrayContentOfRootFile = [[_filesProxy getPersonalDriveContent:_rootFile] retain];
    
    
    [pool release];
    
    //Call in the main thread update method
    [self performSelectorOnMainThread:@selector(contentDirectoryIsRetrieved) withObject:nil waitUntilDone:NO];
}

- (void)contentDirectoryIsRetrieved {
    
    //if the empty is, remove it
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
    
    //Now update the HUD
    //TODO Localize this string
    [_hudFolder setCaption:Localize(@"FolderContentUpdated")];
    [_hudFolder setActivity:NO];
    [_hudFolder setImage:[UIImage imageNamed:@"19-check"]];
    [_hudFolder update];
    [_hudFolder hideAfter:1.0];
    
    
    //check if no data
    if([_arrayContentOfRootFile count] == 0){
        [self performSelector:@selector(emptyState) withObject:nil afterDelay:1.0];
    } 
    
    //And finally reload the content of the tableView
    [_tblFiles reloadData];
}

// Empty State
-(void)emptyState {
    //disable scroll in tableview
    _tblFiles.scrollEnabled = NO;
    
    //add empty view to the view    
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForEmptyFolder.png" andContent:Localize(@"EmptyFolder")];
    emptyView.tag = TAG_EMPTY;
    [_tblFiles addSubview:emptyView];
    [emptyView release];
}

- (void)hideActionsPanel{
    
}

- (void)setTitleForFilesViewController{
    
}

- (void)hideFileFolderActionsController {
    [_fileFolderActionsController.view removeFromSuperview];
    [_fileFolderActionsController release]; _fileFolderActionsController = nil;
}


- (void)dealloc
{
    //Release the FileProxy of the Controller.
    _filesProxy = nil;
    
    //Release the rootFile
    [_rootFile release];
    _rootFile = nil;
    
    //Release the content of rootFile
    [_arrayContentOfRootFile release];
    _arrayContentOfRootFile = nil;
    
    [_hudFolder release];
    _hudFolder.delegate = nil;
    
    [_stringForUploadPhoto release];
    _stringForUploadPhoto = nil;
    
    [_tblFiles release];
    _tblFiles = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hudFolder = [[ATMHud alloc] initWithDelegate:self];
    [_hudFolder setAllowSuperviewInteraction:YES];
    [self setHudPosition];
	[self.view addSubview:_hudFolder.view];
    
    //Set the background Color of the view
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    //backgroundView.frame = self.view.frame;
    //_tblFiles.backgroundView = backgroundView;
    //[backgroundView release];
    
    _tblFiles.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    //Set the title of the view controller
    [self setTitleForFilesViewController];
    
    //Add the "Actions" button
    //TODO localize this button
    UIImage *image = [UIImage imageNamed:@"DocumentNavigationBarActionButton.png"];
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setImage:image forState:UIControlStateNormal];
    bt.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [bt addTarget:self action:@selector(showActionsPanelFromNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
    actionButton.width = image.size.width;
    [self.navigationItem setRightBarButtonItem:actionButton];
    
    [actionButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_arrayContentOfRootFile == nil) {
        //TODO Localize this string
        [self showHUDWithMessage:[NSString stringWithFormat:@"%@ : %@", Localize(@"LoadingContent"),self.title]];
        
        //Start the request to load file content
        [self performSelectorInBackground:@selector(startRetrieveDirectoryContent) withObject:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Release the loader
//    [_hudFolder hide];
//    _hudFolder = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrayContentOfRootFile count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier = @"CellIdentifierForFiles";
    CustomBackgroundForCell_iPhone *cell =  (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
        
        UIImageView* imgViewFile = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40, 40)];
        cell.tag = kTagForCellSubviewImageView;
        [cell addSubview:imgViewFile];
        [imgViewFile release];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 200.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = kTagForCellSubviewTitleLabel;
        [cell addSubview:titleLabel];
        [titleLabel release];
        
        UIImage *image = [UIImage imageNamed:@"DocumentDisclosureActionButton.png"];
        UIButton *buttonAccessory = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonAccessory setImage:image forState:UIControlStateNormal];
        buttonAccessory.tag = indexPath.row;
        buttonAccessory.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [buttonAccessory addTarget:self action:@selector(buttonAccessoryClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = buttonAccessory;
    }
    
    File *file = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
    
    NSLog(@"%@", [file fileName]);
    UIImageView* imgViewFile = (UIImageView*)[cell viewWithTag:kTagForCellSubviewImageView];
    if(file.isFolder){
        imgViewFile.image = [UIImage imageNamed:@"DocumentIconForFolder.png"];
    } else{
        imgViewFile.image = [UIImage imageNamed:[File fileType:file.fileName]];
    }
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    titleLabel.text = file.fileName;
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
    
    
}

#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    
}


#pragma mark - FileAction delegate Methods


- (void)showErrorForFileAction:(NSString *)errorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"FileError") message:errorMessage delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//Use this method to do the delete action in a background thread
-(void)deleteFileInBackground:(NSString *)urlFileToDelete {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForDelete source:urlFileToDelete destination:nil data:nil];
    
    //check the status of the operation
    if (errorMessage) {
        //On main thread, as to send the AlertView
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}

//Method needed to retrieve the delete action
-(void)deleteFile:(NSString *)urlFileToDelete {
    
    //TODO Localize this string
    [self showHUDWithMessage:Localize(@"DeleteFile")];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    [self performSelectorInBackground:@selector(deleteFileInBackground:) withObject:urlFileToDelete];
}

-(void)moveOrCopyActionIsSelected {
    [self hideActionsPanel];
}


//Use this method to do the move action in a background thread
- (void)moveFileInBackgroundSource:(NSString *)urlSource
                     toDestination:(NSString *)urlDestination {
    
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForMove source:urlSource destination:urlDestination data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to retrieve the action to move a file
- (void)moveFileSource:(NSString *)urlSource
         toDestination:(NSString *)urlDestination {
    // remove if is
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [self showHUDWithMessage:Localize(@"MoveFile")];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(moveFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(moveFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
}

//Use this method to do the copy action in a background thread
- (void)copyFileInBackgroundSource:(NSString *)urlSource
                     toDestination:(NSString *)urlDestination {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForCopy source:urlSource destination:urlDestination data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to retrieve the action to copy a file
- (void)copyFileSource:(NSString *)urlSource
         toDestination:(NSString *)urlDestination {
    // remove if is
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
    //TODO Localize this string
    [self showHUDWithMessage:Localize(@"CopyFile")];
    
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(copyFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(copyFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 
    
}


- (void)askToAddAPicture:(NSString *)urlDestination {
    
    _stringForUploadPhoto = urlDestination;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
	{  
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
		thePicker.delegate = self;
		thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		thePicker.allowsEditing = YES;
		[self.navigationController presentModalViewController:thePicker animated:YES];
		[thePicker release];
    }
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakePicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
    
    [self hideActionsPanel];
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}



#pragma mark - FileFolderAction delegate Methods

//Use this method to do the copy action in a background thread
- (void)createNewFolderInBackground:(NSString *)urlSource {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForCreateFolder source:urlSource destination:@"" data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}



//Method needed to call to create a new folder
-(void)createNewFolder:(NSString *)newFolderName {
    
    [self hideFileFolderActionsController];

    
    //TODO Localize this string
    [self showHUDWithMessage:Localize(@"CreateNewFile")];

    
    BOOL bExist;
    if([newFolderName length] > 0)
    {
        for (File* file in _arrayContentOfRootFile) {
            if([newFolderName isEqualToString:file.fileName])
            {
                bExist = YES;
                                
                UIAlertView* alert = [[UIAlertView alloc] 
                                      initWithTitle:Localize(@"Info Message")
                                      message: Localize(@"FolderNameAlreadyExist")
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                break;
            }
        }
        
        if (!bExist) 
        {
            if(!_rootFile.isFolder) {
                newFolderName = [newFolderName stringByEncodingHTMLEntities];
                newFolderName = [DataProcess encodeUrl:newFolderName];
            }
            
            NSString* strNewFolderPath = [FilesProxy urlForFileAction:[_rootFile.urlStr stringByAppendingPathComponent:newFolderName]];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(createNewFolderInBackground:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(createNewFolderInBackground:)];
            [invocation setArgument:&strNewFolderPath atIndex:2];
            [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 

        }
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:Localize(@"Info Message")
                              message: Localize(@"FolderNameEmpty")
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}




//Method to call the rename action of the proxy
- (void)renameFolderInBackground:(NSString *)newFolderUrl forFolder:(NSString *)folderToRenameUrl {

    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForMove source:folderToRenameUrl destination:newFolderUrl data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to rename a folder
-(void)renameFolder:(NSString *)newFolderName forFolder:(File *)folderToRename {
    
    [self hideFileFolderActionsController];
    
    
    //TODO Localize this string
    [self showHUDWithMessage:Localize(@"RenameFolder")];
    
    if([newFolderName length] > 0)
    {
        BOOL bExist = NO;
        
        for (File* file in _arrayContentOfRootFile) {
            if([newFolderName isEqualToString:file.fileName])
            {
                bExist = YES;
                
                UIAlertView* alert = [[UIAlertView alloc] 
                                      initWithTitle:Localize(@"Info Message")
                                      message: Localize(@"FolderNameAlreadyExist")
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];

                
                break;
            }
        }
        if (!bExist) 
        {
            if(!_rootFile.isFolder) {
                newFolderName = [newFolderName stringByEncodingHTMLEntities];
                newFolderName = [DataProcess encodeUrl:newFolderName];
            }
            
            NSString *strRenamePath = [FilesProxy urlForFileAction:[_rootFile.urlStr stringByAppendingPathComponent:newFolderName]];
            NSString *strSource = [FilesProxy urlForFileAction:folderToRename.urlStr];

            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(renameFolderInBackground:forFolder:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(renameFolderInBackground:forFolder:)];
            [invocation setArgument:&strRenamePath atIndex:2];
            [invocation setArgument:&strSource atIndex:3];
            [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 
            
        }
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:Localize(@"Info Message")
                              message: Localize(@"FolderNameEmpty")
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}



//Method needed when the Controller must be hidden
-(void)cancelFolderActions {
    
    [self hideFileFolderActionsController];
    
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder{
    
}



#pragma mark - Pictures Management


- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [_filesProxy fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo  
{
	UIImage* selectedImage = image;
	NSData* imageData = UIImagePNGRepresentation(selectedImage);
	
	
	if ([imageData length] > 0) 
	{
		[picker dismissModalViewControllerAnimated:YES];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy_mm_dd_hh_mm_ss"];
		NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
        
        //release the date formatter because, not needed after that piece of code
        [dateFormatter release];
		tmp = [NSString stringWithFormat:@"MobileImage_%@.png", tmp];
		
		
		_stringForUploadPhoto = [_stringForUploadPhoto stringByAppendingFormat:@"/%@",tmp];
		
        //TODO Localize this string
        [self showHUDWithMessage:Localize(@"SendImageToFolder")];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
        [invocation setArgument:&_stringForUploadPhoto atIndex:2];
        [invocation setArgument:&imageData atIndex:3];
        [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
        
	}
	else
	{	
		[picker dismissModalViewControllerAnimated:YES];
	}
}  

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];    
} 



#pragma mark HUD Management

-(void)setHudPosition{
    //default implementation
    //do nothing
}


-(void)showHUDWithMessage:(NSString *)message {
    [self setHudPosition];
    [_hudFolder setCaption:message];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
}




@end

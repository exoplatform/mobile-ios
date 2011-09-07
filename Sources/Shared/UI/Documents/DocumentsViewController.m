//
//  DocumentsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController.h"
#import "eXoWebViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"
#import "LanguageHelper.h"
#import "NSString+HTML.h"
#import "DataProcess.h"

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


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

@end


// =====================================
// = Implementation of private methods
// =====================================

@implementation DocumentsViewController (PrivateMethods)

-(void)startRetrieveDirectoryContent {
    
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
    
    if (_filesProxy == nil) _filesProxy = [FilesProxy sharedInstance];
    
    if (_rootFile == nil) _rootFile = [_filesProxy initialFileForRootDirectory];
    
    _arrayContentOfRootFile = [_filesProxy getPersonalDriveContent:_rootFile];
    
    [pool release];
    
    //Call in the main thread update method
    [self performSelectorOnMainThread:@selector(contentDirectoryIsRetrieved) withObject:nil waitUntilDone:NO];
}

- (void)contentDirectoryIsRetrieved {
    //Now update the HUD
    //TODO Localize this string
    [_hudFolder setCaption:@"Folder content updated"];
    [_hudFolder setActivity:NO];
    [_hudFolder setImage:[UIImage imageNamed:@"19-check"]];
    [_hudFolder update];
    [_hudFolder hideAfter:1.0];
    
    //And finally reload the content of the tableView
    [self.tableView reloadData];
}

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.fileName;
    } else {
        self.title = @"Documents";
    }
}


- (void)hideFileFolderActionsController {
    [_fileFolderActionsController.view removeFromSuperview];
    [_fileFolderActionsController release]; _fileFolderActionsController = nil;
}

@end



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for FilesViewController_iPhone
// ================================
@implementation DocumentsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)dealloc
{
    //Release the FileProxy of the Controller.
    [_filesProxy release];
    _filesProxy = nil;
    
    //Release the rootFile
    [_rootFile release];
    _rootFile = nil;
    
    //Release the content of rootFile
    [_arrayContentOfRootFile release];
    _arrayContentOfRootFile = nil;
    
    //Release the loader
    [_hudFolder release];
    _hudFolder = nil;
    
    [_stringForUploadPhoto release];
    _stringForUploadPhoto = nil;
    
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
	[self.view addSubview:_hudFolder.view];
    
    //Set the background Color of the view
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    self.tableView.backgroundView = backgroundView;
    
    //Set the title of the view controller
    [self setTitleForFilesViewController];
    
    //Add the "Actions" button
    //TODO localize this button
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" style:UIBarButtonItemStylePlain target:self action:@selector(showActionsPanelFromNavigationBarButton)];
    
    [self.navigationItem setRightBarButtonItem:actionButton];
    
    
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
        [_hudFolder setCaption:[NSString stringWithFormat:@"Loading the content of the folder : %@",self.title]];
        [_hudFolder setActivity:YES];
        [_hudFolder show];
        
        //Start the request to load file content
        [self performSelectorInBackground:@selector(startRetrieveDirectoryContent) withObject:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    File *file = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
    
    
    UIImageView* imgViewFile = (UIImageView*)[cell viewWithTag:kTagForCellSubviewImageView];
    if(file.isFolder)
        imgViewFile.image = [UIImage imageNamed:@"folder.png"];
    else
        imgViewFile.image = [UIImage imageNamed:[File fileType:file.fileName]];
    
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
    titleLabel.text = file.fileName;
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
    
    
}




#pragma mark - FileAction delegate Methods


- (void)showErrorForFileAction:(NSString *)errorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File error" message:errorMessage delegate:self 
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
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Delete file..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
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
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Move file to wanted folder..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
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
    
    //TODO Localize this string
    [_hudFolder setCaption:@"Copy file to wanted folder..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];
    
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take Picture" message:@"Camera are not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    [_hudFolder setCaption:@"Create new file folder..."];
    [_hudFolder setActivity:YES];
    [_hudFolder show];

    
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





//Method needed to rename a folder
-(void)renameFolder:(NSString *)newFolderName {

    
}



//Method needed when the Controller must be hidden
-(void)cancelFolderActions {
    [_fileFolderActionsController.view removeFromSuperview];
    
    
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
		[dateFormatter setDateFormat:@"dd-MM-yyy-HH-mm-ss"];
		NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
        
        //release the date formatter because, not needed after that piece of code
        [dateFormatter release];
		tmp = [tmp stringByAppendingFormat:@".png"];
		
		
		_stringForUploadPhoto = [_stringForUploadPhoto stringByAppendingFormat:@"/%@",tmp];
		
        //TODO Localize this string
        [_hudFolder setCaption:@"Sending image to wanted folder..."];
        [_hudFolder setActivity:YES];
        [_hudFolder show];
        
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



#pragma mark - ATMHud Delegate
#pragma mark -
#pragma mark ATMHudDelegate
- (void)userDidTapHud:(ATMHud *)_hud {
	[_hud hide];
}





@end

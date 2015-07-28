//
// Copyright (C) 2003-2015 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "ShareViewController.h"
#import "AccountViewController.h"
#import "Account.h"
#import "PostActivity.h"

#import "defines.h"

#import "UploadViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#define kRestVersion @"v1-alpha3"
#define kRestContextName @"rest"
#define kPortalContainerName @"portal"
#define kMaxSize    10000000

@interface ShareViewController () {
    // IHM part
    SLComposeSheetConfigurationItem *spaceItem;
    SLComposeSheetConfigurationItem *accountItem;

    // User config.
    int loggingStatus;
    SocialSpace * selectedSpace;
    NSMutableArray * allAccounts;
    Account * selectedAccount;
    
    // Connection tools
    NSURLConnection * connection;
    NSURLSession * session;
    NSURLSession * uploadSession;     // Background session, use only for upload the attachment file.
    NSURLSessionDataTask * uploadTask;
    
    //Server size infos.
    NSString* currentRepository;
    NSString* defaultWorkspace;
    NSString* userHomeJcrPath;
    BOOL hasMobileFolder;
    // post activity
    PostActivity * postActivity;
    
    // Upload View Controller
    UploadViewController * uploadVC;
    NSString * uploadId;

}

@end

@implementation ShareViewController

enum {
    eXoStatusNotLogin = 0,
    eXoStatusLoggingIn = 1,
    eXoStatusLoggedFail = 2,
    eXoStatusLoggInAuthentificationFail = 3,
    eXoStatusLoggedIn = 4,
    eXoStatusLoadingSpaceId = 5,
    eXoStatusCheckingUploadFoder = 6,
    eXoStatusCreatingUploadFoder = 7
};

#pragma mark - Share VC life cycle

- (BOOL)isContentValid {
    return (self.contentText != nil && self.contentText.length > 0);
}

-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"eXo";
    
    // Account & Login
    loggingStatus = eXoStatusNotLogin;
    [self initListAccounts];
    
    //Post infos.
    [self getPostInfos];
    [self login];
}

/*
 Get all account which has ever logged in eXo Application.
 The list of account will be share between eXo Application & eXo Share Extension via the share NSUserDefaults.
 Each Account is stored in NSUserDefaults as a Dictionay of 4 keys: username, password, serverURL & accountName.
 There is a selected Account (which is the last logged account in the eXo Application.
 
 */
-(void) initListAccounts {
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.com.exoplatform.mob.eXoPlatformiPHone"];
    allAccounts = [[NSMutableArray alloc] init];
    if (mySharedDefaults){
        NSArray * allUsernames = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_ALL_ACCOUNTS];
        
        if (allUsernames) {
            for (int i=0; i < allUsernames.count; i++){
                Account * account = [[Account alloc] init];
                account.userName = [allUsernames[i] objectForKey:@"username"];
                account.password = [allUsernames[i] objectForKey:@"password"];
                account.serverURL = [allUsernames[i] objectForKey:@"serverURL"];
                account.accountName = [allUsernames[i] objectForKey:@"accountName"];
                [allAccounts addObject:account];
            }
        }
        
        /*
         Some the password is missing (or out of date) from the accounts stored in UserPreference.xml
         Beside the password of the selected account (last logged account) is always updated (each time user logged in this infos would be update.)
         */
        int selectedAccountIndex = [[mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_SELECTED_ACCOUNT_INDEX] intValue];
        if (selectedAccountIndex >=0 && selectedAccountIndex < allAccounts.count){
            selectedAccount = allAccounts[selectedAccountIndex];
            NSString * currentAccount = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_USERNAME];
            NSString * password       = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_PASSWORD];
            NSString * serverURL      = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_DOMAIN];
            if ([selectedAccount.userName isEqualToString:currentAccount] && [selectedAccount.serverURL isEqualToString:serverURL]){
                selectedAccount.password = password;
            }
            
        }
    }
}

/*
 Get the file attachment from the sent from Host App. 
 In case of URL sharing (there is no file to share) the absolute URL will be added to post message.
 */
-(void) getPostInfos {
    
    postActivity = [[PostActivity alloc] init];
    postActivity.type = @"DOC_ACTIVITY";
    //Check All UTI Type Hierachy https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html
    
    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;

    for (NSItemProvider * itemProvider in inputItem.attachments){
        // All file in local (file URL)
        // -> All file share from email for example should be catch in this one.
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeFileURL]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                if (!error && url) {
                    postActivity.url = url;
                }
            }];
            // Image Type.
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    if ([url isKindOfClass:[NSURL class]]){
                        postActivity.url = url;
                    } else if ([url isKindOfClass:[UIImage class]]){
                        postActivity.fileData = UIImagePNGRepresentation((UIImage*)item);
                    } else if ([url isKindOfClass:[NSData class]]){
                        postActivity.fileData = (NSData*)url;
                    }
                    postActivity.fileExtension = @"png";
                }
            }];
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeAudio]) {
            // Type Audio
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeAudio options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    if ([url isKindOfClass:[NSURL class]]){
                        postActivity.url = url;
                    } else if ([url isKindOfClass:[NSData class]]){
                        postActivity.fileData = (NSData*)url;
                        postActivity.fileExtension = @"mp3";
                    }
                }
            }];
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeMovie]) {
            // Type Video
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeMovie options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    if ([url isKindOfClass:[NSURL class]]){
                        postActivity.url = url;
                    } else if ([url isKindOfClass:[NSData class]]){
                        postActivity.fileData = (NSData*)url;
                        postActivity.fileExtension = @"MOV";
                    }
                }
            }];
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeCompositeContent]) {
            // Base type for mixed content. For example, a PDF file contains both text and special formatting data.
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeData options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    if ([url isKindOfClass:[NSURL class]]){
                        postActivity.url = url;
                    } else if ([url isKindOfClass:[NSData class]]){
                        postActivity.fileData = (NSData*)url;
                        postActivity.fileExtension = @"pdf";
                    }
                }
            }];
        }  else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            // case URL: the post message is the text in text field + the URL.
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                if (!error && url) {
                    postActivity.pageWebTitle = self.contentText;
                    postActivity.url = url;
                    postActivity.type = @"LINK_ACTIVITY";
                    [postActivity imageFromPageWeb];
                }
            }];
        }  else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
            // case URL: the post message is the text in text field + the URL.
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                }
            }];
        }
    }
    
}


#pragma mark - Configuration IHM
- (NSArray *)configurationItems {
    
    accountItem = [[SLComposeSheetConfigurationItem alloc] init];
    // Give your configuration option a title.
    [accountItem setTitle:NSLocalizedString(@"Account",nil)];
    // Give it an initial value.
    if (selectedAccount){
        switch (loggingStatus) {
            case eXoStatusLoggedIn:{
                    [accountItem setValue:selectedAccount.accountName];
                }
                break;
            case eXoStatusLoggingIn:
                [accountItem setValue:NSLocalizedString(@"Logging in",nil)];
                break;
            case eXoStatusLoggInAuthentificationFail:
                [accountItem setValue:NSLocalizedString(@"Wrong password",nil)];
                break;
            default:{
                [accountItem setValue:NSLocalizedString(@"Offline",nil)];
            }
                break;
        }
        [accountItem setValue:selectedAccount.accountName];
    } else {
        [accountItem setValue:NSLocalizedString(@"No account",nil)];
    }
    
    // Handle what happens when a user taps your option.
    [accountItem setTapHandler:^(void){
        // Create an instance of your configuration view controller.
        // Transfer to your configuration view controller.
        AccountViewController * accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
        accountVC.delegate = self;
        accountVC.allAccounts = allAccounts;
        [self.navigationController pushViewController:accountVC animated:YES];
    }];
    
    // space item
    spaceItem = [[SLComposeSheetConfigurationItem alloc] init];
    [spaceItem setTitle:NSLocalizedString(@"Space",nil)];
    
    // Give it an initial value.
    // Depense on the loggin status the message value could be the name of space in loggedIn, offline in loggedFail & logging in loggingIn.
    // By default the space is public space
    
    switch (loggingStatus) {
        case eXoStatusLoadingSpaceId:
            [spaceItem setValue:NSLocalizedString(@"Loading space id",nil)];
            break;
            
        default:
            if (selectedSpace){
                [spaceItem setValue:selectedSpace.displayName];
            } else {
                [spaceItem setValue:NSLocalizedString(@"Public",nil)];
            }

            break;
    }
    // Handle what happens when a user taps your option.
    
    [spaceItem setTapHandler:^(void){
        // User can select a space only after authentification.
        if (loggingStatus == eXoStatusLoggedIn){
            SpaceViewController  * spaceSelectionVC = [[SpaceViewController alloc] initWithStyle:UITableViewStylePlain];
            spaceSelectionVC.delegate = self;
            spaceSelectionVC.account  = selectedAccount;
            [self.navigationController pushViewController:spaceSelectionVC animated:YES];
        }
    }];
    if (loggingStatus >= eXoStatusLoggedIn) {
            return @[accountItem, spaceItem];
    } else {
        return @[accountItem];
    }
    
    // Return an array containing your item.

}

#pragma mark - Loggin

NSMutableData * data;
-(void) login {
    if (selectedAccount && selectedAccount.password.length>0){
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization":[self authentificationBase64]}];
        session  = [NSURLSession sessionWithConfiguration:sessionConfig];
        
        loggingStatus = eXoStatusLoggingIn;
        NSString * stringURL = [NSString stringWithFormat:@"%@/rest/private/platform/info#",selectedAccount.serverURL];
        NSURL * url = [NSURL URLWithString:stringURL];
        

        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
        //set default request timeout = 100 ms.
        [request setTimeoutInterval:100];
        [request setHTTPMethod:@"GET"];
        [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

        data = [[NSMutableData alloc] init];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}

// make the authentification for selected accout
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // authentification by challenge: create a credential with user & password.
    if([challenge previousFailureCount] == 0) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:selectedAccount.userName password:selectedAccount.password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        loggingStatus =eXoStatusLoggInAuthentificationFail;
        selectedAccount.password = @"";
        [self reloadConfigurationItems];
    }
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData {
    [data appendData:aData];
}

// finish request. Get the Server infos from the response (JSON)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if (data.length >0){
        NSError * error = nil;
        // convert the JSON to Space object (JSON string --> Dictionary --> Object.
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonObjects) {
            userHomeJcrPath = [jsonObjects objectForKey:@"userHomeNodePath"];
            currentRepository = [jsonObjects objectForKey:@"currentRepoName"];
            defaultWorkspace = [jsonObjects objectForKey:@"defaultWorkSpaceName"];
        }
    }
    
    loggingStatus =eXoStatusLoggedIn;
    [self createMobileFolderIfNeed];
    [self reloadConfigurationItems];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    loggingStatus = eXoStatusLoggedFail;
    [self reloadConfigurationItems];
}



#pragma mark - Account & Space Delegate

// User did selected a space from space selection VC
-(void) spaceSelection:(SpaceViewController *)spaceSelection didSelectSpace:(SocialSpace *)space {
    
    if (!space) {
        selectedSpace = nil;
    } else {
        selectedSpace = space;
        [self getSpaceId:space];
        [self createMobileFolderIfNeed];
    
    }
    [self reloadConfigurationItems];
    
}

// Send Resquest to get space id
-(void) getSpaceId:(SocialSpace*) space {
    
    loggingStatus = eXoStatusLoadingSpaceId;
    
    NSString * path = [NSString stringWithFormat:@"%@/rest/private/api/social/v1-alpha3/portal/identity/space/%@.json",selectedAccount.serverURL, space.name];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError * error = nil;
            // convert the JSON to Space object (JSON string --> Dictionary --> Object.
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (jsonObjects){
                selectedSpace.spaceId = [jsonObjects objectForKey:@"id"];
            }
            loggingStatus = eXoStatusLoggedIn;
        } else {
            loggingStatus = eXoStatusLoggedFail;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadConfigurationItems];
        });
    }];
    [dataTask resume];
}

// User did selected an account.
-(void) accountSelector:(AccountViewController *)accountSelector didSelectAccount:(Account *)account {
    if (account){
        selectedAccount  = account;
        loggingStatus = eXoStatusNotLogin;
        selectedSpace = nil;
        [self login];
        [self reloadConfigurationItems];
    }
}


# pragma mark - post methode

-(NSString *) mobileFolderPath {
    if (selectedSpace){
        return [NSString stringWithFormat:@"%@/rest/private/jcr/%@/%@/Groups%@/Documents/Mobile",selectedAccount.serverURL,currentRepository, defaultWorkspace, selectedSpace.groupId];
    }
    return [NSString stringWithFormat:@"%@/rest/private/jcr/%@/%@%@/Public/Mobile",selectedAccount.serverURL,currentRepository, defaultWorkspace,userHomeJcrPath];
}


-(void) createMobileFolderIfNeed {
    // Post Files process
    // 1. Check if folder contains the photos existe Asynchronous request - see reability
    // 1a. if not Create the folder (method: MKCOL, Authentification base64)
    // 2. Upload File ?
    // 3. Request Post Rest WS (method POST)

    hasMobileFolder = NO;
    NSString * mobileFolderPath = [self mobileFolderPath];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:mobileFolderPath]];
    [request setHTTPMethod:@"HEAD"];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
            hasMobileFolder = statusCode >= 200 && statusCode < 300;
            if (!hasMobileFolder) {
                /*
                 If the Mobile folder doesn't exist, Send a request (method:MKCOL) to ask the server side to create the mobile folder.
                 */
                NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
                [request setURL:[NSURL URLWithString:[self mobileFolderPath]]];
                [request setHTTPMethod:@"MKCOL"];
                [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
                    if(statusCode >= 200 && statusCode < 300) {
                        hasMobileFolder = YES;
                    }
                }];
                [dataTask resume];
            }
        }
    }];
    [dataTask resume];
   
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    AccountViewController * accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    accountVC.delegate = self;
    accountVC.allAccounts = allAccounts;
    [self.navigationController pushViewController:accountVC animated:YES];
    
    // Get the lastest content text.
    
    postActivity.message = self.contentText;
    
    if (loggingStatus == eXoStatusLoggedIn){
        if ([postActivity.type isEqualToString:@"DOC_ACTIVITY"]){
            [self postDocActivity:postActivity];
        } else if ([postActivity.type isEqualToString:@"LINK_ACTIVITY"] ) {
            [self postLinkActivity:postActivity];
        } else {
            [self postMessage:postActivity.message fileURL:nil fileName:nil];
        }

    } else {
        // login fail (cause by: network connection/ wrong username, password/ no space id
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot post",nil) message:[self logMessage] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
 
}
-(NSString *) logMessage {
    if (loggingStatus < eXoStatusLoggedIn) {
        return NSLocalizedString(@"Login fail",nil);
    }
    if (loggingStatus == eXoStatusLoadingSpaceId) {
        return NSLocalizedString(@"No Space Id",nil);
    }
    if (loggingStatus == eXoStatusCreatingUploadFoder || loggingStatus == eXoStatusCheckingUploadFoder) {
        return NSLocalizedString(@"Server Problem",nil);
    }
    return NSLocalizedString(@"Unable to post",nil);

}


-(NSURLSession *) uploadSession {
    if (!uploadSession){
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
        uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return uploadSession;
}
-(void) postDocActivity:(PostActivity *) activity {
    if (activity.url || activity.fileData) {
        
        /*
         In case of the photo attach in e-mail the fileURL is NSData.
         */
        if (activity.url){
            activity.fileExtension =[[activity.url absoluteString] lastPathComponent];
            activity.fileExtension = [activity.fileExtension stringByRemovingPercentEncoding];
            if (!activity.fileData){
                activity.fileData = [NSData dataWithContentsOfURL:activity.url];
            }
        }
        if (activity.fileData.length < kMaxSize){
            uploadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadViewController"];
            uploadVC.delegate = self;
            [self presentViewController:uploadVC animated:YES completion:nil];
            /*
             ECMS web service
             1. Upload file POST
             Query params: uploadId= : An arbitrary value to keep until the end &  action=upload
             Content type: multipart/form-data; boundary= with an arbitrary boundary.
             Body:
             --BOUNDARY
             Content-Disposition: form-data; name="file"; filename="..."  /!\ name must be "file"
             Content-Type: the content type of the file to upload
             
             // File content
             --BOUNDARY
             2. save file GET /portal/rest/managedocument/uploadFile/control
             uploadId= : the value chosen at step 1
             action=save
             workspaceName= : the workspace in which to move the file
             driveName= : the drive, within the workspace, in which to move the file
             currentFolder= : the folder, within the drive, in which to move the file
             fileName= : the name of the file (can be different than the original)
             */
            
            NSString * fileAttachName = [activity makeUploadFileName];

            uploadId = [NSUUID UUID].UUIDString;
            uploadId = [uploadId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * boundary = [NSString stringWithFormat:@"-----%@",uploadId];
            
            NSString * postRESTURL = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/upload?uploadId=%@&action=upload", selectedAccount.serverURL,uploadId];
            
            NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postRESTURL]];
            [request setHTTPMethod:@"POST"];
            [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

            [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
            request.HTTPShouldHandleCookies = YES;
            NSString * bodyBegin = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n",boundary,fileAttachName];
            NSString * bodyEnd = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];

            NSMutableData * bodyData = [[NSMutableData alloc] init];
            
            [bodyData appendData:[bodyBegin dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:activity.fileData];
            [bodyData appendData:[bodyEnd dataUsingEncoding:NSUTF8StringEncoding]];

            [request setHTTPBody:bodyData];
            NSURLSession * aSession = [self uploadSession];
            uploadTask = [aSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
                if(statusCode >= 200 && statusCode < 300) {
                    // save the file to mobile folder
                    
                    NSString * postFileURL = [NSString stringWithFormat:@"%@/%@", [self mobileFolderPath], fileAttachName];
                    NSString * saveRESTURL;
                    if (selectedSpace){
                        NSString * driverName = [selectedSpace.groupId stringByReplacingOccurrencesOfString:@"/" withString:@"."];
                        saveRESTURL  = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/control?uploadId=%@&action=save&workspaceName=%@&driveName=%@&currentFolder=%@&fileName=%@", selectedAccount.serverURL,uploadId,defaultWorkspace,driverName,@"Mobile",fileAttachName];
                        
                    } else {
                        saveRESTURL  = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/control?uploadId=%@&action=save&workspaceName=%@&driveName=%@&currentFolder=%@&fileName=%@", selectedAccount.serverURL,uploadId,defaultWorkspace,@"Personal Documents",@"Public/Mobile",fileAttachName];

                    }
                    saveRESTURL = [saveRESTURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
                    [request setURL:[NSURL URLWithString:saveRESTURL]];
                    [request setHTTPMethod:@"GET"];
                    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
                        if(statusCode >= 200 && statusCode < 300) {
                            [self postMessage:activity.message fileURL:postFileURL fileName:fileAttachName];
                        } else {
                            [uploadVC dismissViewControllerAnimated:YES completion:nil];
                            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
                            
                        }
                    }];
                    [dataTask resume];
                    
                }
            }];
            
            [uploadTask resume];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot post",nil) message:NSLocalizedString(@"File is too large", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    } else {
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
}

#pragma mark - Upload Session Delegate

-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    dispatch_async(dispatch_get_main_queue(), ^{
        uploadVC.progressBar.progress = (float)totalBytesSent/(float)totalBytesExpectedToSend;
    });
    
}

/*
 User did selected the Cancel button while uploading
 */
-(void) uploadViewController:(UploadViewController *)uploadController didSelectCancel:(id)sender {
    [uploadTask cancel];
    [uploadController dismissViewControllerAnimated:YES completion:nil];
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    
}

#pragma mark - POST Activity.

/*
 Post un Doc activity: 
 @param 
    - message: the post message
    - fileURL, fileName (optional): The Path to file upload file & its name.
 
 @discussion 
 The file & fileName are optional
 */
-(void) postMessage:(NSString *) message fileURL:(NSString *) fileURL fileName:(NSString*) fileName {
    
    NSString * title = message;
    NSString * type;
    NSDictionary * templateParams;

    NSString * postURL = [NSString stringWithFormat:@"%@/rest/private/api/social/%@/%@/activity.json",selectedAccount.serverURL, kRestVersion, kPortalContainerName];
    if (selectedSpace && selectedSpace.spaceId.length > 0){
        type = @"exosocial:spaces";
        postURL = [NSString stringWithFormat:@"%@?identity_id=%@", postURL, selectedSpace.spaceId];
    }

    // 2
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

    
    if (fileURL) {
        type = @"DOC_ACTIVITY";
        
        NSString* docPath;
        if (selectedSpace){
            docPath = [NSString stringWithFormat:@"/Groups%@/Documents/Mobile/%@",selectedSpace.groupId,fileName];
        } else {
            docPath = [NSString stringWithFormat:@"%@/Public/Mobile/%@",userHomeJcrPath,fileName];
        }
        
        NSRange rangeOfDocLink = [fileURL rangeOfString:@"jcr"];
        NSString* docLink = [NSString stringWithFormat:@"/rest/%@", [fileURL substringFromIndex:rangeOfDocLink.location]];
        title = [NSString stringWithFormat:@"Shared a document <a href=\"%@\">%@</a>\"", docLink, fileName];
        templateParams = @{
                           @"DOCPATH":docPath,
                           @"MESSAGE":message,
                           @"DOCLINK":docLink,
                           @"WORKSPACE":defaultWorkspace,
                           @"REPOSITORY":currentRepository,
                           @"DOCNAME":fileName
                           };
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:title forKey:@"title"];
    if (type){
        [dictionary setValue:type forKey:@"type"];
    }
    if (templateParams) {
        [dictionary setValue:templateParams forKey:@"templateParams"];
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    [request setHTTPBody:data];
    
    if (!error) {
        NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [uploadVC dismissViewControllerAnimated:YES completion:nil];
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
        [postTask resume];
    } else {
        [uploadVC dismissViewControllerAnimated:YES completion:nil];
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];

    }
}
/*
 Post a link. The Tempate Params need: the URL, the title, the description & the Image (pick one in the page).
 @params
 message: the post message 
 URL: the URL to the page 
 title: the title of the page
 */
-(void) postLinkActivity:(PostActivity*) activity {
    NSString * postURL = [NSString stringWithFormat:@"%@/rest/private/api/social/%@/%@/activity.json",selectedAccount.serverURL, kRestVersion, kPortalContainerName];

    if (selectedSpace && selectedSpace.spaceId.length > 0){
        postURL = [NSString stringWithFormat:@"%@?identity_id=%@", postURL, selectedSpace.spaceId];
    }
    NSString * imgSrc = activity.imageFromURL? activity.imageFromURL : @"";
    
    NSDictionary * templateParams = @{
                       @"comment":activity.message,
                       @"link":activity.url.absoluteString,
                       @"description":@"",
                       @"image":imgSrc,
                       @"title":activity.pageWebTitle
                       };
    NSDictionary * dictionary = @{@"type": activity.type,
                                  @"title":activity.pageWebTitle,
                                  @"templateParams": templateParams
                                  };
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];

    [request setHTTPBody:data];

    if (!error) {
        NSURLSessionDataTask *postTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [uploadVC dismissViewControllerAnimated:YES completion:nil];
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
        [postTask resume];
    } else {
        [uploadVC dismissViewControllerAnimated:YES completion:nil];
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        
    }

}
#pragma mark - BASE 64

-(NSString *) authentificationBase64 {
    NSString * username = selectedAccount.userName;
    NSString * password = selectedAccount.password;
    
    NSString * basicAuth = @"Basic ";
    NSString * authorizationHead = [basicAuth stringByAppendingString: [self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@",username, password]]];
    
    return authorizationHead;
}
/**/
- (NSString*)stringEncodedWithBase64:(NSString*)str
{
    static const char *tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    const char *s = [str UTF8String];
    long length = [str length];
    char *tmp = malloc(length * 4 / 3 + 4);
    
    int i = 0;
    int n = 0;
    char *p = tmp;
    
    while (i < length)
    {
        n = s[i++];
        n *= 256;
        if (i < length) n += s[i];
        i++;
        n *= 256;
        if (i < length) n += s[i];
        i++;
        
        p[0] = tbl[((n & 0x00fc0000) >> 18)];
        p[1] = tbl[((n & 0x0003f000) >> 12)];
        p[2] = tbl[((n & 0x00000fc0) >>  6)];
        p[3] = tbl[((n & 0x0000003f) >>  0)];
        
        if (i > length) p[3] = '=';
        if (i > length + 1) p[2] = '=';
        
        p += 4;
    }
    
    *p = '\0';
    
    NSString* ret = @(tmp);
    free(tmp);
    
    return ret;
}


/**/


@end

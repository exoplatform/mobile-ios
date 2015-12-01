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

#import "MobileFileUploadManager.h"
#import "ApplicationPreferencesManager.h"
#import "defines.h"
#import "SocialSpace.h"

@interface MobileFileUploadManager () {
    
    NSURLSession * uploadSession;
    NSURLSessionUploadTask * uploadTask;
    BOOL isCanceling; // indict that if the user has tapped on Cancel button
}
@end

@implementation MobileFileUploadManager

- (void) suspendUpload {
    if (uploadTask) {
        [uploadTask suspend];
    }
}

- (void) resumeUpload {
    if (uploadTask && !isCanceling && uploadTask.state == NSURLSessionTaskStateSuspended) {
        [uploadTask resume];
    }
}

- (void) cancelUpload {
    isCanceling = YES;
    if (uploadTask) {
        [uploadTask cancel];
        uploadSession = nil;
        uploadTask = nil;
    }
}
/*
 private method: start the upload (after the mobile folder has verified)
 */
- (void) startUploadFile:(NSString *)fileName data:(NSData *)data toSpace:(SocialSpace *) space progess:(ProgressCallBack)progress completion:(CompletionCallBack)completion {

    if (isCanceling) {
        return;
    }
    // Save the progress bock to global variable to use in the delegate of upload session
    self.progressCallBack = progress;

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
    
    NSString * fileAttachName = fileName;
    
    NSString * uploadId = [NSUUID UUID].UUIDString;
    uploadId = [uploadId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * boundary = [NSString stringWithFormat:@"-----%@",uploadId];
    
    NSString * postRESTURL = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/upload?uploadId=%@&action=upload", [ApplicationPreferencesManager sharedInstance].selectedAccount.serverUrl,uploadId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postRESTURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    request.HTTPShouldHandleCookies = YES;
    NSString * bodyBegin = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n\r\n",boundary,fileAttachName];
    NSString * bodyEnd = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    
    NSMutableData * bodyData = [[NSMutableData alloc] init];
    
    [bodyData appendData:[bodyBegin dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:data];
    [bodyData appendData:[bodyEnd dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:bodyData];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    uploadTask = [uploadSession uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
        if(error == nil && statusCode >= 200 && statusCode < 300) {
            // Upload successful: move to destination
            [self moveUploadedFileToDestination:space fileName:fileAttachName uploadId:uploadId completionHandler:completion];
        } else {
            if (completion){
                completion (@"", NO, error);
            }
        }
    }];
    // Start the upload task
    [uploadTask resume];
}

- (void) uploadFile:(NSString *)fileName data:(NSData *)fileData toSpace:(SocialSpace *) space progess:(ProgressCallBack)progress completion:(CompletionCallBack)completion {
    
    isCanceling = NO;
    
    // Upload File process
    // 1. Check if destination folder exists on the server
    // 2. Upload file with ECMS upload service (method POST)
    
    NSString * mobileFolderPath = [self mobileFolderPath:space];
    NSMutableURLRequest* mobileFolderCheckRequest = [[NSMutableURLRequest alloc] init];
    [mobileFolderCheckRequest setURL:[NSURL URLWithString:mobileFolderPath]];
    [mobileFolderCheckRequest setHTTPMethod:@"HEAD"];
    [mobileFolderCheckRequest setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * mobileFolderCheckSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *checkMobileFolderTask = [mobileFolderCheckSession dataTaskWithRequest:mobileFolderCheckRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
            if (statusCode >= 200 && statusCode < 300) {
                // Folder exists: start the upload process
                [self startUploadFile:fileName data:fileData toSpace:space progess:progress completion:completion];
            } else {
                // Mobile folder doesn't exist: send a request (method:MKCOL) to create the mobile folder
                NSMutableURLRequest* createMobileFolderRequest = [[NSMutableURLRequest alloc] init];
                [createMobileFolderRequest setURL:[NSURL URLWithString:mobileFolderPath]];
                [createMobileFolderRequest setHTTPMethod:@"MKCOL"];
                [createMobileFolderRequest setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];
                
                NSURLSessionDataTask *createMobileFolderTask = [mobileFolderCheckSession dataTaskWithRequest:createMobileFolderRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
                    if(statusCode >= 200 && statusCode < 300) {
                        // Folder created: start the upload process
                        [self startUploadFile:fileName data:fileData toSpace:space progess:progress completion:completion];
                    } else {
                        completion (nil, NO, error);
                    }
                }];
                // Start the task to create the Mobile folder
                [createMobileFolderTask resume];
            }
        }
    }];
    // Start the task to check if the Mobile folder exists
    [checkMobileFolderTask resume];
}

-(void) moveUploadedFileToDestination:(SocialSpace*)space fileName:(NSString*)fileAttachName uploadId:(NSString*)uploadId completionHandler:(CompletionCallBack)completion {
    // save the file to mobile folder
    NSString * postFileURL = [NSString stringWithFormat:@"%@/%@",[self mobileFolderPath:space], fileAttachName];
    NSString * saveRESTURL;
    if (space){
        NSString * driverName = [space.groupId stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        saveRESTURL = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/control?uploadId=%@&action=save&workspaceName=%@&driveName=%@&currentFolder=%@&fileName=%@",
                        [ApplicationPreferencesManager sharedInstance].selectedAccount.serverUrl,
                        uploadId,
                        [ApplicationPreferencesManager sharedInstance].defaultWorkspace,
                        driverName,
                        @"Mobile",
                        fileAttachName];
    } else {
        saveRESTURL = [NSString stringWithFormat:@"%@/portal/rest/managedocument/uploadFile/control?uploadId=%@&action=save&workspaceName=%@&driveName=%@&currentFolder=%@&fileName=%@",
                       [ApplicationPreferencesManager sharedInstance].selectedAccount.serverUrl,
                       uploadId,
                       [ApplicationPreferencesManager sharedInstance].defaultWorkspace,
                       @"Personal Documents",
                       @"Public/Mobile",
                       fileAttachName];
    }
    saveRESTURL = [saveRESTURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:saveRESTURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:kUserAgentHeader forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
        if(statusCode >= 200 && statusCode < 300) {
            if (completion){
                completion (postFileURL, YES, error);
            }
        } else {
            if (completion){
                completion (postFileURL, NO, error);
            }
        }
    }];
    [dataTask resume];
}

/*
 * Construct the path to the upload destination folder
 */
-(NSString *) mobileFolderPath:(SocialSpace *) space {
    NSString * photosFolderPath;
    if (space && space.spaceId) {
        photosFolderPath = [NSString stringWithFormat:@"%@/rest/private/jcr/%@/%@/Groups%@/Documents",
                            [ApplicationPreferencesManager sharedInstance].selectedAccount.serverUrl,
                            [ApplicationPreferencesManager sharedInstance].currentRepository,
                            [ApplicationPreferencesManager sharedInstance].defaultWorkspace,
                            space.groupId];
    } else {
        photosFolderPath = [NSString stringWithFormat:@"%@/rest/private/jcr/%@/%@%@/Public/Mobile",
                            [ApplicationPreferencesManager sharedInstance].selectedAccount.serverUrl,
                            [ApplicationPreferencesManager sharedInstance].currentRepository,
                            [ApplicationPreferencesManager sharedInstance].defaultWorkspace,
                            [ApplicationPreferencesManager sharedInstance].userHomeJcrPath];
    }
    return photosFolderPath;
}


#pragma mark - Upload Session Delegate

-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (isCanceling){
        if (task) {
            [task cancel];
        }
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        float p = (float)totalBytesSent/(float)totalBytesExpectedToSend;
        if (self.progressCallBack){
            self.progressCallBack(p);
        }
        
    });
    
}

- (void) URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
}


@end

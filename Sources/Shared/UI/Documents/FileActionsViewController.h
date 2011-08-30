//
//  FileActionViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FileActionsProtocol 
//Method needed to retrieve the delete action
-(void)deleteFile:(NSString *)urlFileToDelete;

//Method needed to ctach when an move/copy action is requested over one file
-(void)moveOrCopyActionIsSelected;

//Method needed to retrieve the action to move a file
- (void)moveFileSource:urlSource
         toDestination:urlDestination;

//Method needed to retrieve the action to copy a file
- (void)copyFileSource:urlSource
         toDestination:urlDestination;

//Method needed to retrieve the action when the user ask an image
- (void)askToAddAPicture:(NSString *)urlDestination;

@end


@interface FileActionsViewController : NSObject {
    
}

@end

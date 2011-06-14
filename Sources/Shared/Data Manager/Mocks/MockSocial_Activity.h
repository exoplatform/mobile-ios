//
//  MockSocial_Activity.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//======================== INNER CLASS =========================
//==============================================================


@interface Activity : NSObject {
    
    NSString *userID;
    NSString *title;
    NSString *body;
    NSString *avatarUrl;
    NSDate *lastUpdateDate;
    long postedTime;
    int nbLikes;
    int nbComments;
}

@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *avatarUrl;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *lastUpdateDate;
@property long postedTime;
@property int nbLikes;
@property int nbComments;


-(id)initWithUserID:(NSString *)_userID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(long)_postedTime
      numberOfLikes:(int)_numberOfLikes
   numberOfComments:(int)_numberOfComments;

-(NSString*)datePrepared; // Method to calcul the date information (ie : 2minutes ago, 2 days ago...)

@end




@interface MockSocial_Activity : NSObject {
    
    NSMutableArray *arrayOfActivities;
}

@property (nonatomic, retain) NSMutableArray* arrayOfActivities;

@end

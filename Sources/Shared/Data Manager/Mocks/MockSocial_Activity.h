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
    
    NSString *activityID;
    NSString *userID;
    NSString *title;
    NSString *body;
    NSString *avatarUrl;
    NSDate *lastUpdateDate;
    long postedTime;
    int nbLikes;
    int nbComments;
    NSString *postedTimeInWords;
    NSArray* arrComments;
    NSArray* arrLikes;
}

@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *avatarUrl;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *lastUpdateDate;
@property (nonatomic, retain) NSString *postedTimeInWords;
@property (nonatomic, retain) NSArray *arrComments;
@property (nonatomic, retain) NSArray *arrLikes;
@property long postedTime;
@property int nbLikes;
@property int nbComments;

-(id)initWithUserID:(NSString *)_userID
         activityID:(NSString *)_activityID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(long)_postedTime
              likes:(NSArray*)_arrLikes
           comments:(NSArray*)_arrComments;

@end

//================================================================

@interface ActivityDetail : NSObject 
{
    
    NSString *activityID;
    NSMutableArray *arrLikes;
    NSMutableArray *arrComments;
}

@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSMutableArray *arrLikes;
@property (nonatomic, retain) NSMutableArray *arrComments;

- (id)initWithUserID:(NSString *)_activityID
            arrLikes:(NSMutableArray *)_arrLikes
         arrComments:(NSMutableArray *)_arrComments;
@end

//================================================================

@interface Comment : NSObject 
{
    NSString *activityID;
    NSString *userID;
    NSMutableArray *arrTxtComments;
}
@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSMutableArray *arrTxtComments;

- (id)initWithUserID:(NSString *)_activityID
              userID:(NSString *)_userID
      arrTxtComments:(NSMutableArray *)_arrTxtComments;
@end


//================================================================

@interface MockSocial_Activity : NSObject {
    
    NSMutableArray *arrayOfActivities;
    
    NSMutableArray* arrLikes;
    NSMutableArray* arrComments;
}

@property (nonatomic, retain) NSMutableArray* arrayOfActivities;
@property (nonatomic, retain) NSMutableArray* arrLikes;
@property (nonatomic, retain) NSMutableArray* arrComments;

@end

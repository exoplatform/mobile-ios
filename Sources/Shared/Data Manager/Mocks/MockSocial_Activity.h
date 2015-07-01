//
// Copyright (C) 2003-2014 eXo Platform SAS.
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

#import <Foundation/Foundation.h>

//======================== INNER CLASS =========================
//==============================================================


@interface Activity : NSObject {
    
    NSString *activityID;
    NSString *userID;
    NSString *userFullName;
    NSString *title;
    NSString *body;
    NSString *avatarUrl;
    NSDate *lastUpdateDate;
    double postedTime;
    int nbLikes;
    int nbComments;
    NSString *postedTimeInWords;
    NSArray* arrComments;
    NSArray* arrLikes;
}

@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *userFullName;
@property (nonatomic, retain) NSString *avatarUrl;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *lastUpdateDate;
@property (nonatomic, retain) NSString *postedTimeInWords;
@property (nonatomic, retain) NSArray *arrComments;
@property (nonatomic, retain) NSArray *arrLikes;
@property double postedTime;
@property int nbLikes;
@property int nbComments;


-(instancetype)initWithUserID:(NSString *)_userID
         activityID:(NSString *)_activityID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(double)_postedTime
      numberOfLikes:(int)_numberOfLikes
   numberOfComments:(int)_numberOfComments; 

-(instancetype)initWithUserID:(NSString *)_userID
         activityID:(NSString *)_activityID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(double)_postedTime
              likes:(NSArray*)_arrLikes
           comments:(NSArray*)_arrComments;

@end

//================================================================

@interface ActivityDetail : NSObject 
{
    
    NSString *activityID;
    NSString *userFullName;
    NSArray *arrLikes;
    NSArray *arrComments;
}

@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSString *userFullName;
@property (nonatomic, retain) NSArray *arrLikes;
@property (nonatomic, retain) NSArray *arrComments;
@property (nonatomic, retain) NSString* userImageAvatar;

- (instancetype)initWithUserID:(NSString *)_activityID
            arrLikes:(NSArray *)_arrLikes
         arrComments:(NSArray *)_arrComments;
@end

//================================================================

@interface Comment : NSObject 
{
    NSString *activityID;
    NSString *userID;
    NSString *userFullName;
    NSMutableArray *arrTxtComments;
}
@property (nonatomic, retain) NSString *activityID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *userFullName;
@property (nonatomic, retain) NSMutableArray *arrTxtComments;

- (instancetype)initWithUserID:(NSString *)_activityID
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

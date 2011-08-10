//
//  MockSocial_Activity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MockSocial_Activity.h"
#import "NSDate+Formatting.h"

@implementation Activity

@synthesize userID, userFullName,activityID,avatarUrl,title,body,lastUpdateDate,postedTime,nbLikes,nbComments,postedTimeInWords, arrComments, arrLikes;

-(id)initWithUserID:(NSString *)_userID
         activityID:(NSString *)_activityID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(double)_postedTime
      numberOfLikes:(int)_numberOfLikes
   numberOfComments:(int)_numberOfComments 
{
    if ((self =[super init])) {
        self.userID = _userID;
        self.activityID = _activityID;
        self.avatarUrl = _avatarUrl;
        self.title = [_title copy];
        self.postedTime = _postedTime;
        self.body = _body;
        self.nbLikes = _numberOfLikes;
        self.nbComments = _numberOfComments;
//        self.postedTimeInWords = [[NSDate date] distanceOfTimeInWords:[[NSDate date] dateByAddingTimeInterval:postedTime]];

        self.postedTimeInWords = [[NSDate date] distanceOfTimeInWordsWithTimeInterval:postedTime];

    }
    return self;
}

-(id)initWithUserID:(NSString *)_userID
         activityID:(NSString *)_activityID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(double)_postedTime
              likes:(NSArray*)_arrLikes
           comments:(NSArray*)_arrComments
{
    return self;
}


-(NSString*)datePrepared { // Method to calcul the date information (ie : 2minutes ago, 2 days ago...)

    return @"datePrepared not Implemented";
}

@end


//================================================================

@implementation ActivityDetail
    
@synthesize activityID;
@synthesize userFullName;
@synthesize arrLikes;
@synthesize arrComments;
@synthesize userImageAvatar;

- (id)initWithUserID:(NSString *)_activityID
            arrLikes:(NSArray *)_arrLikes
         arrComments:(NSArray *)_arrComments
{
    if ((self =[super init])) 
    {
        self.activityID = _activityID;
        self.arrLikes = _arrLikes;
        self.arrComments = _arrComments;
    }
    return self;
}

@end

//================================================================

@implementation Comment

@synthesize activityID;
@synthesize userID;
@synthesize userFullName;
@synthesize arrTxtComments;

- (id)initWithUserID:(NSString *)_activityID
              userID:(NSString *)_userID
      arrTxtComments:(NSMutableArray *)_arrTxtComments
{
    if ((self =[super init])) 
    {
        self.activityID = _activityID;
        self.userID = _userID;
        self.arrTxtComments = _arrTxtComments;
    }
    return self;
}
@end


//================================================================

@implementation MockSocial_Activity

@synthesize arrayOfActivities;
@synthesize arrLikes;
@synthesize arrComments;

-(id)init{
    if ((self = [super init])) {
   
        //Create a list of activities
        /*
        Activity *act_01 = [[Activity alloc] initWithUserID:@"32D52" 
                                                 activityID:@"ABC001"
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_02 = [[Activity alloc] initWithUserID:@"32D52" 
                                                 activityID:@"ABC002"
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"This is a normal message, with some content. And a second sentence." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_03 = [[Activity alloc] initWithUserID:@"32D52"
                                                 activityID:@"ABC003"
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_04 = [[Activity alloc] initWithUserID:@"32D52" 
                                                 activityID:@"ABC004"
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_05 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC005"
                                                 avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_06 = [[Activity alloc] initWithUserID:@"1D52" 
                                                 activityID:@"ABC006"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_07 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC007"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:0 
                                         numberOfComments:0];
        
        Activity *act_08 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC008"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:2 
                                           numberOfComments:0];
        
        Activity *act_09 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC009"
                                                 avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:20 
                                           numberOfComments:0];
        
        Activity *act_10 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC010"
                                                 avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:200 
                                           numberOfComments:0];
        
        Activity *act_11 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC011"
                                                 avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:2000 
                                           numberOfComments:0];
        
        Activity *act_12 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC012"
                                                 avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:0];
        
        Activity *act_13 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC013"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:2];
        
        Activity *act_14 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC014"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:20];
        
        Activity *act_15 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC015"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:200];
        
        Activity *act_16 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC016"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:2000];
        
        Activity *act_17 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC017"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:0 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_18 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC018"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:30 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_19 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC019"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:60 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_20 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC020"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:600 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_21 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC021"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_22 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC022"
                                               avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:7200 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_23 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC023"
                                              avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:86400 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_24 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC024"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:172800 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_25 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC025"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:864000 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_26 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC026"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:2592000 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_27 = [[Activity alloc] initWithUserID:@"33D52" 
                                                 activityID:@"ABC027"
                                                avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:5184000
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        
        arrayOfActivities = [[NSMutableArray alloc] initWithObjects:act_01,
                             act_02,
                             act_03,
                             act_04,
                             act_05,
                             act_06,
                             act_07,
                             act_08,
                             act_09,
                             act_10,
                             act_11,
                             act_12,
                             act_13,
                             act_14,
                             act_15,
                             act_16,
                             act_17,
                             act_18,
                             act_19,
                             act_20,
                             act_21,
                             act_22,
                             act_23,
                             act_24,
                             act_24,
                             act_25,
                             act_26,
                             act_27,                        
                             nil];
        
        arrLikes = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:act_01,act_02,act_03, nil]];
        arrComments = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:act_04,act_05,act_06, nil]];
         */
    }    
    return self;
}

@end

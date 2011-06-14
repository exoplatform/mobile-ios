//
//  MockSocial_Activity.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MockSocial_Activity.h"

@implementation Activity

@synthesize userID,avatarUrl,title,body,lastUpdateDate,postedTime,nbLikes,nbComments;



-(id)initWithUserID:(NSString *)_userID
          avatarUrl:(NSString *)_avatarUrl
              title:(NSString *)_title
               body:(NSString *)_body
         postedTime:(long)_postedTime
      numberOfLikes:(int)_numberOfLikes
   numberOfComments:(int)_numberOfComments 
{
    if ((self =[super init])) {
        self.userID = _userID;
        self.avatarUrl = _avatarUrl;
        self.title = [_title retain];
        self.postedTime = _postedTime;
        self.body = _body;
        self.nbLikes = _numberOfLikes;
        self.nbComments = _numberOfComments;
    }
    return self;
}


-(NSString*)datePrepared { // Method to calcul the date information (ie : 2minutes ago, 2 days ago...)

    return @"datePrepared not Implemented";
}


@end




@implementation MockSocial_Activity

@synthesize arrayOfActivities;

-(id)init{
    if ((self = [super init])) {
   
        //Create a list of activities
        
        Activity *act_01 = [[Activity alloc] initWithUserID:@"32D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_02 = [[Activity alloc] initWithUserID:@"32D52" 
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"This is a normal message, with some content. And a second sentence." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_03 = [[Activity alloc] initWithUserID:@"32D52" 
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_04 = [[Activity alloc] initWithUserID:@"32D52" 
                                                  avatarUrl:@"http://www.foxnews.com/images/332496/1_42_alba_jessica_warren120907.jpg"
                                                    title:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_05 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_06 = [[Activity alloc] initWithUserID:@"1D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:1 
                                         numberOfComments:1];
        
        Activity *act_07 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                    title:@"This is a short message" 
                                                     body:@"" 
                                               postedTime:3600 
                                            numberOfLikes:0 
                                         numberOfComments:0];
        
        Activity *act_08 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:2 
                                           numberOfComments:0];
        
        Activity *act_09 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:20 
                                           numberOfComments:0];
        
        Activity *act_10 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:200 
                                           numberOfComments:0];
        
        Activity *act_11 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:2000 
                                           numberOfComments:0];
        
        Activity *act_12 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:0];
        
        Activity *act_13 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:2];
        
        Activity *act_14 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:20];
        
        Activity *act_15 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:200];
        
        Activity *act_16 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:0 
                                           numberOfComments:2000];
        
        Activity *act_17 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:0 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_18 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:30 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_19 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:60 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_20 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:600 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_21 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:3600 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_22 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:7200 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_23 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:86400 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_24 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:172800 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_25 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:864000 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_26 = [[Activity alloc] initWithUserID:@"33D52" 
                                                  avatarUrl:@"http://assets0.ordienetworks.com/images/user_photos/1121804/jessica_alba-houri_square_medium.jpg?037a0d17"
                                                      title:@"This is a short message" 
                                                       body:@"" 
                                                 postedTime:2592000 
                                              numberOfLikes:1 
                                           numberOfComments:1];
        
        Activity *act_27 = [[Activity alloc] initWithUserID:@"33D52" 
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
        
        
        
        
    }    
    return self;
}

@end

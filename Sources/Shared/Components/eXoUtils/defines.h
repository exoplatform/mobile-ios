//
//  defines.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#define TIMEOUT_SEC							60.0
#define HEIGHT_OF_KEYBOARD_IPHONE_PORTRAIT	216.0
#define HEIGHT_OF_KEYBOARD_IPHONE_LANDSCAPE	162.0
#define HEIGHT_OF_KEYBOARD_IPAD_PORTRAIT	262.0
#define HEIGHT_OF_KEYBOARD_IPAD_LANDSCAPE	352.0

#define WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT 250
#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409

#define DISTANCE_LANDSCAPE                  18
#define DISTANCE_PORTRAIT                   24
#define WIDTH_LANDSCAPE_WEBVIEW             800
#define WIDTH_PORTRAIT_WEBVIEW              550

// Key for storing the combination server_username when we sign-in
#define EXO_LAST_LOGGED_USER                @"last-logged-user"
#define EXO_PREFERENCE_USERID				@"userId"
#define EXO_PREFERENCE_USERNAME				@"username"
#define EXO_PREFERENCE_PASSWORD				@"password"
#define EXO_PREFERENCE_EXO_USERID			@"exo_user_id"
#define EXO_PREFERENCE_DOMAIN				@"domain_name"
#define EXO_PREFERENCE_SELECTED_SEVER		@"selected_server"
#define EXO_IS_USER_LOGGED                  @"sigin"
#define EXO_PREFERENCE_VERSION_SERVER       @"version_server"
#define EXO_PREFERENCE_EDITION_SERVER       @"edition_server"
#define EXO_PREFERENCE_VERSION_APPLICATION  @"version_application"
#define EXO_NOTIFICATION_ACTIVITY_UPDATED   @"notification-activity-updated"
#define EXO_NOTIFICATION_CHANGE_LANGUAGE    @"notification-change-language"
#define EXO_NOTIFICATION_SHOW_PRIVATE_DRIVE @"notification-show-private-drive"
#define EXO_NOTIFICATION_SERVER_ADDED       @"notification-server-added"
#define EXO_NOTIFICATION_SERVER_DELETED     @"notification-server-deleted"

#define EXO_PREFERENCE_LANGUAGE				@"language"
#define HTTP_PROTOCOL                       @"http://"
#define HTTPS_PROTOCOL                       @"https://"

#define SCR_WIDTH_LSCP_IPAD                 1024
#define SCR_HEIGHT_LSCP_IPAD                748

#define SCR_WIDTH_PRTR_IPAD                 768
#define SCR_HEIGHT_PRTR_IPAD                1004

#define EXO_MAX_HEIGHT                      80

#define SPECIAL_CHAR_NAME_SET                    @"[]/\\&~?*|<>\";:+()$%@#!"
#define SPECIAL_CHAR_URL_SET                    @"[]\\&~?*|<>\";+"


//#define ACTIVITY_GETTING_TITLE              @"Getting activity"
//#define ACTIVITY_GETTING_MESSAGE_ERROR      @"Getting action cannot be completed"
//#define ACTIVITY_UPDATING_TITLE             @"Updating activity"
//#define ACTIVITY_UPDATING_MESSAGE_ERROR     @"Updating action cannot be completed"
//#define ACTIVITY_LIKING_TITLE               @"Liking activity"
//#define ACTIVITY_LIKING_MESSAGE_ERROR       @"Liking action cannot be completed"
//
//#define ACTIVITY_POSTING_TITLE              @"Posting activity"
//#define ACTIVITY_POSTING_MESSAGE_ERROR      @"Posting action cannot be completed"
//#define ACTIVITY_COMMENT_TITLE              @"Comment activity"
//#define ACTIVITY_COMMENT_MESSAGE_ERROR      @"Comment action cannot be completed"
//
//#define ACTIVITY_DETAIL_GETTING_TITLE       @"Getting activity detail"
//#define ACTIVITY_DETAIL_UPDATING_TITLE      @"Updating activity detail"


#define EXO_BACKGROUND_COLOR                [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]]
#define SELECTED_CELL_BG_COLOR              [UIColor colorWithRed:225./255 green:225./255 blue:225./255 alpha:1.]

#define DOCUMENT_JCR_PATH_REST              @"/rest/private/jcr/"
#define DOCUMENT_DRIVE_PATH_REST            @"/rest/private/managedocument/getDrives?driveType="
#define DOCUMENT_DRIVE_SHOW_PRIVATE_OPT     @"&showPrivate="
#define DOCUMENT_FILE_PATH_REST             @"/rest/private/managedocument/getFoldersAndFiles?driveName="
#define DOCUMENT_WORKSPACE_NAME             @"&workspaceName="
#define DOCUMENT_CURRENT_FOLDER             @"&currentFolder=" 


/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//iPhone 5 screen height minus the navigation bar and status bar: 568 - 44 - 20 = 504
#define iPHONE_5_SCREEN_HEIGH_MINUS_NAV_AND_STATUS_BAR 504

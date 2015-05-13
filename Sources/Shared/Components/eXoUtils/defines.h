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

// selected domain
#define SELECTED_DOMAIN                     [ApplicationPreferencesManager sharedInstance].selectedDomain

// Key for storing the combination server_username when we sign-in
#define EXO_LAST_LOGGED_USER                [NSString stringWithFormat:@"%@_last_logged_user",SELECTED_DOMAIN]
#define EXO_PREFERENCE_USERID				@"userId"
#define EXO_PREFERENCE_USERNAME				[NSString stringWithFormat:@"%@_username",SELECTED_DOMAIN]
#define EXO_PREFERENCE_PASSWORD				[NSString stringWithFormat:@"%@_password",SELECTED_DOMAIN]
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
#define EXO_IMAGE_CELL_HEIGHT               150

#define SPECIAL_CHAR_NAME_SET                    @"[]/\\&~?*|<>\";:+()$%@#!"
#define SPECIAL_CHAR_URL_SET                    @"[]\\&~?*|<>\";+"

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

#define iPHONE_5_SCREEN_HEIGHT 548
#define iPHONE_SCREEN_HEIGH 460
//eXo cloud sign up
#define EXO_CLOUD_USER_NAME_FROM_URL @"exo_cloud_user_name_from_url"
#define EXO_CLOUD_ACCOUNT_CONFIGURED @"exo_cloud_account_configured"
#define EXO_NOT_COMPILANT_ERROR_DOMAIN @"exo_not_compliant"

#define EXO_CLOUD_URL  @"http://exoplatform.net"
#define EXO_CLOUD_HOST @"exoplatform.net"
#define EXO_CLOUD_TENANT_SERVICE_PATH @"rest/cloud-admin/cloudworkspaces/tenant-service"
//#define EXO_CLOUD_HOST @"netstg.exoplatform.org"
//#define EXO_CLOUD_URL @"http://netstg.exoplatform.org"
//#define EXO_CLOUD_HOST @"wks-acc.exoplatform.org"
//#define EXO_CLOUD_URL @"http://wks-acc.exoplatform.org"
#define scrollHeight 50 /* how much should we scroll up/down when the keyboard is displayed/hidden */

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kAttributeURL @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14], NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.9333 alpha:1], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)}

#define kAttributeText @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]}

#define kAttributeNameSpace @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:17.0/255.0 green:94.0/255 blue:174.0/255.0 alpha:1] }


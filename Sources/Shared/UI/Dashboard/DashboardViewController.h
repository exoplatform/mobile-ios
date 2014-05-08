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

#import <UIKit/UIKit.h>
#import "DashboardProxy.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "eXoViewController.h"
#import "EGORefreshTableHeaderView.h"

//Constants Definitions
#define kTagForCellSubviewTitleLabel 22
#define kTagForCellSubviewDescriptionLabel 33
#define kTagForCellSubviewImageView 44

@interface DashboardViewController : eXoViewController <DashboardProxyDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>{
    
    NSArray*         _arrDashboard;	//Dashboard array 
    IBOutlet UITableView*   _tblGadgets;
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    //Proxy
    DashboardProxy*         _dashboardProxy;
    
    BOOL                    _isEmpty;
    
    //Error message for dashboard problems
    NSMutableString*        _errorForRetrievingDashboard;
    
}

@property(nonatomic, retain) NSArray* _arrDashboard;

- (CGRect)rectOfHeader:(int)width;
- (void)emptyState;
- (UITableView*)tblGadgets;

@end

//
//  DocumentSettingController.h
//  iChm
//
//  Created by Robin Lu on 3/30/09.
//  Copyright 2009 CodeWalrus.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMBrowserController;

@interface DocumentSettingController : UITableViewController {
    IBOutlet UITableViewCell    *textEncodingCell;
    IBOutlet UITextField        *textEncodingField;
    
    CHMBrowserController *delegate;
}

@property (nonatomic, assign) CHMBrowserController *delegate;

- (void)settingChanged:(id)sender;
@end

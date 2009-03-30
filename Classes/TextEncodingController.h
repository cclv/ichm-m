//
//  TextEncodingController.h
//  iChm
//
//  Created by Robin Lu on 3/30/09.
//  Copyright 2009 CodeWalrus.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DocumentSettingController;

@interface TextEncodingController : UITableViewController {
    NSArray *encodingNames;
    DocumentSettingController *settingController;
}

@property (nonatomic, assign) DocumentSettingController * settingController;
@end

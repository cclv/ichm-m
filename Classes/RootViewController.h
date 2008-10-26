//
//  RootViewController.h
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileManagerController;

@interface RootViewController : UITableViewController {
	FileManagerController *fileManagerController;
}

- (IBAction)startFileManager:(id)sender;
- (void)uploadingFinished:(NSNotification*)notification;
- (void)fileDeleted:(NSNotification*)notification;
@end

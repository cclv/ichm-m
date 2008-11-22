//
//  FileManagerController.h
//  iChm
//
//  Created by Robin Lu on 10/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class   HTTPServer;

@interface FileManagerController : UITableViewController {
	HTTPServer *httpServer;
	IBOutlet UITextView *fileNameLabel;
	IBOutlet UIProgressView *uploadProgress;
	IBOutlet UIView *uploadNoticeView;
	IBOutlet UIView *headerView;
	
	BOOL serverIsRunning;
}
- (void)uploadingStarted:(NSNotification*)notification;
- (void)updateUploadingStatus:(NSNotification*)notification;
- (void)uploadingFinished:(NSNotification*)notification;
- (void)fileDeleted:(NSNotification*)notification;

- (IBAction)helpPage:(id)sender;
@end

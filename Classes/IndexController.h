//
//  IndexController.h
//  iChm
//
//  Created by Robin Lu on 10/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMBrowserController;
@class LinkItem;

@interface IndexController : UITableViewController {
	CHMBrowserController *browserController;
	LinkItem* rootItem;
}

- (id)initWithBrowserController:(CHMBrowserController*)controller idxSource:(LinkItem*)root;
@end

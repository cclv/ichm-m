//
//  TableOfContentController.h
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMBrowserController;
@class LinkItem;

@interface TableOfContentController : UITableViewController {
	CHMBrowserController *browserController;
	LinkItem* rootItem;
}

- (id)initWithBrowserController:(CHMBrowserController*)controller tocRoot:(LinkItem*)root;
@end

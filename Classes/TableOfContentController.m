//
//  TableOfContentController.m
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TableOfContentController.h"
#import "CHMDocument.h"
#import "CHMBrowserController.h"
#import "CHMTableOfContent.h"


@implementation TableOfContentController

- (id)initWithBrowserController: (CHMBrowserController*)controller tocRoot:(LinkItem*)root
{
	if (self = [super initWithNibName:@"TableOfContent"	bundle:nil]) {
		browserController = controller;
		[browserController retain];
		rootItem = root;
		
		if (rootItem == [[CHMDocument CurrentDocument] tocItems])
			self.title = NSLocalizedString(@"Table Of Contents",@"Table Of Contents");
		else
			self.title = [root name];
		[rootItem retain];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	/*
	 Return the index titles for each of the sections (e.g. "A", "B", "C"...).
	 Use key-value coding to get the value for the key @"letter" in each of the dictionaries in list.
	 */
	NSString *title;
	if (rootItem == [[CHMDocument CurrentDocument] tocItems])
		title = NSLocalizedString(@"Table Of Contents",@"Table Of Contents");
	else
		title = [rootItem name];
	return title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rootItem numberOfChildren];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	LinkItem *item = [rootItem childAtIndex:indexPath.row];
	cell.text = [item name];
	
	if ([item numberOfChildren] > 0)
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	LinkItem *item = [rootItem childAtIndex:indexPath.row];
	TableOfContentController *tocController = [[TableOfContentController alloc] initWithBrowserController:browserController tocRoot:item];
	[[self navigationController] pushViewController:tocController animated:YES];
	[tocController release];	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LinkItem *item = [rootItem childAtIndex:indexPath.row];
	[browserController loadPath:[item path]];
	[self.navigationController popToViewController:browserController animated:NO];
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
	[browserController release];
	[rootItem release];
    [super dealloc];
}


@end


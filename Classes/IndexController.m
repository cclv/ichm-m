//
//  IndexController.m
//  iChm
//
//  Created by Robin Lu on 10/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IndexController.h"
#import "CHMBrowserController.h"
#import "CHMTableOfContent.h"


@implementation IndexController

- (id)initWithBrowserController:(CHMBrowserController*)controller idxSource:(LinkItem*)root
{
	if (self = [super initWithNibName:@"IndexController" bundle:nil]) {
		browserController = controller;
		[browserController retain];
		rootItem = root;
		
		self.title = NSLocalizedString(@"IDX", @"IDX");
		[rootItem retain];
	}
	return self;	
}
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [rootItem numberOfChildren];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[rootItem childAtIndex:section] numberOfChildren];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	LinkItem *item = [[rootItem childAtIndex:indexPath.section] childAtIndex:indexPath.row];
	cell.text = [item name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LinkItem *item = [[rootItem childAtIndex:indexPath.section] childAtIndex:indexPath.row];
	[browserController loadPath:[item path]];
	[self.navigationController popToViewController:browserController animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	return [[rootItem childAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView { 
	return [[rootItem children] valueForKey:@"name"]; 
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
	[rootItem release];
	[browserController release];
    [super dealloc];
}


@end


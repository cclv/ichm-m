//
//  RootViewController.m
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "iChmAppDelegate.h"
#import "CHMDocument.h"
#import "TableOfContentController.h"
#import "CHMBrowserController.h"
#import "FileManagerController.h"
#import "HTTPServer.h"

@interface RootViewController (Private)

- (NSArray*) fileList;

@end

@implementation RootViewController

#pragma mark init
- (void)awakeFromNib
{
	self.title = NSLocalizedString(@"File List", @"File List");
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(uploadingFinished:) name:HTTPUploadingFinishedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(fileDeleted:) name:HTTPFileDeletedNotification object:nil];
	fileManagerController = nil;
}

- (NSArray*) fileList
{
	iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	return [appDelegate fileList];
}
#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self fileList] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"fileListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
	cell.text = [[self fileList] objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	NSString* filename = [[self fileList] objectAtIndex:indexPath.row];
	CHMDocument *doc = [CHMDocument OpenDocument:filename];
	//TableOfContentController *tocController = [[TableOfContentController alloc] initWithCHMDocument:doc];
	//[[self navigationController] pushViewController:tocController animated:YES];
	//[tocController release];
	CHMBrowserController *browserController = [[CHMBrowserController alloc] initWithCHMDocument:doc];
	[[self navigationController] pushViewController:browserController animated:YES];
	
	iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	NSDictionary *pref = [appDelegate getPreferenceForFile:filename];
	NSString *docPath = [doc homePath];
	if (pref && [pref objectForKey:@"last path"] )
	{
		docPath = [pref objectForKey:@"last path"];
	}
	[browserController loadPath:docPath];
	
	[browserController release];
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to add the Edit button to the navigation bar.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


/*
// Override to support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[fileManagerController release];
    [super dealloc];
}

#pragma mark actions
- (IBAction)startFileManager:(id)sender
{
	if (nil == fileManagerController)
		fileManagerController = [[FileManagerController alloc] init];
	[self.navigationController pushViewController:fileManagerController animated:YES];
}

#pragma mark notification
- (void)uploadingFinished:(NSNotification*)notification
{
	[self.tableView reloadData];
}

- (void)fileDeleted:(NSNotification*)notification
{
	[self.tableView reloadData];
}
@end

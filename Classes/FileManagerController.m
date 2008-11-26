//
//  FileManagerController.m
//  iChm
//
//  Created by Robin Lu on 10/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FileManagerController.h"
#import "HTTPServer.h"
#import "HelpViewController.h"

@interface FileManagerController (Private)
- (NSString*)setupDocroot;

@end

@implementation FileManagerController

- (id)init {
	[self initWithNibName:@"FileManager" bundle:nil];
	serverIsRunning = NO;
	
	NSString * docroot = [self setupDocroot];
	
	httpServer = [[HTTPServer alloc] init];
	[httpServer setType:@"_http._tcp."];
	
	[httpServer setPort:8080];
	[httpServer setName:@"iChm"];
	[httpServer setDocumentRoot:docroot];
	
	NSError *error;
	serverIsRunning = [httpServer start:&error];
	
	if(!serverIsRunning)
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
		
	// setup notification
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(uploadingStarted:) name:HTTPUploadingStartNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(updateUploadingStatus:) name:HTTPUploadingProgressNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(uploadingFinished:) name:HTTPUploadingFinishedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
			 selector:@selector(fileDeleted:) name:HTTPFileDeletedNotification object:nil];

	// setup view header
	self.tableView.tableHeaderView = headerView;
	[headerView setBackgroundColor:[UIColor clearColor]];
	
	// setup view footer
	[fileNameLabel setText:@""];
	fileNameLabel.font = [UIFont systemFontOfSize:14];
	[uploadProgress setHidden:YES];
	uploadNoticeView.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = uploadNoticeView;

	// help page
	UIBarButtonItem *helpButton = [[[UIBarButtonItem alloc]
									initWithTitle:NSLocalizedString(@"Help", @"Help")
									style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(helpPage:)] autorelease];
	self.navigationItem.rightBarButtonItem = helpButton;
	
	return self;
}

- (NSString*)setupDocroot
{
	NSString* docroot =[NSString stringWithFormat:@"%@/tmp/docroot", NSHomeDirectory()];
	NSLog(docroot);
	NSFileManager *manager = [NSFileManager defaultManager];
	NSError *error;
	if(![manager removeItemAtPath:docroot error:&error])
	{
		NSLog([NSString stringWithFormat:@"Can not remove old docroot: %@", error ]);
	}
	[manager createDirectoryAtPath:docroot attributes:nil];
	
	NSArray * localizations = [[NSBundle mainBundle] preferredLocalizations];
	NSString *localizedName = [localizations objectAtIndex:0];
	NSString* localizedDocroot = [NSString stringWithFormat:@"%@/localized_docroot/%@.lproj", 
								  [[NSBundle mainBundle] sharedSupportPath],
								  localizedName];
	[manager copyItemAtPath:[NSString stringWithFormat:@"%@/%@", localizedDocroot, @"index.html"]
					 toPath:[NSString stringWithFormat:@"%@/%@", docroot, @"index.html"] error:&error];
	//link scripts directory
	NSString *scriptsPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"scripts"];
	NSString *destPath = [NSString stringWithFormat:@"%@/scripts", docroot];
	if (![manager createSymbolicLinkAtPath:destPath pathContent: scriptsPath])
	{
		NSLog([NSString stringWithFormat:@"Can not create scripts path: %@", error]);
		return nil;
	}	
	NSString *imagessPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"webimages"];
	destPath = [NSString stringWithFormat:@"%@/images", docroot];
	if (![manager createSymbolicLinkAtPath:destPath pathContent: imagessPath])
	{
		NSLog([NSString stringWithFormat:@"Can not create image path: %@", error]);
		return nil;
	}	
	return docroot;
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!serverIsRunning || [httpServer hostName] == nil)
		return 0;
	
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FileManagerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell
	if (indexPath.row == 0)
		cell.text =  NSLocalizedString(@"Use web browser to connect to:",@"Use web browser to connect to:");
	else if (indexPath.row == 1)
	{
		if ([httpServer port] == 80)
			cell.text = [NSString stringWithFormat:@"http://%@", [httpServer hostName]];
		else
			cell.text = [NSString stringWithFormat:@"http://%@:%d", [httpServer hostName], [httpServer port]];
			
		cell.textColor = [UIColor blueColor];
		cell.textAlignment = UITextAlignmentCenter;
		cell.font = [UIFont boldSystemFontOfSize:20];
	}
	else if (indexPath.row == 2)
	{
		cell.text = NSLocalizedString(@"for uploading and deleting.",@"for uploading and deleting.");
	}
    return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return NSLocalizedString(@"Service is running...",@"Service is running...");
}
 */
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/

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


- (void)viewWillAppear:(BOOL)animated {
	if(!serverIsRunning)
	{
		NSError *error;
		serverIsRunning = [httpServer start:&error];
	}
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	if (!serverIsRunning || [httpServer hostName] == nil)
	{
		UIAlertView *alertView = [[[UIAlertView alloc]
				   initWithTitle:@"" 
				   message:@"Cannot establish the file manager service. Please check your Wi-Fi connection settings and try again." 
				   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alertView show];
	}
    [super viewDidAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/

- (void)viewDidDisappear:(BOOL)animated {
	if (serverIsRunning)
	{
		[httpServer stop];
		serverIsRunning = NO;
	}
}

/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
    [super dealloc];
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark notifications
- (void)uploadingStarted:(NSNotification*)notification
{
	NSString* filename = [notification object];
	if ([filename length] == 0)
		return;
	
	NSString *label = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Uploading",@"Uploading"), filename];
	[fileNameLabel setText:label];
	
	[uploadProgress setHidden:NO];
}

- (void)updateUploadingStatus:(NSNotification*)notification
{
	float progress = [(NSString*)[notification object] floatValue];
	[uploadProgress setProgress:progress];
}

- (void)uploadingFinished:(NSNotification*)notification
{
	NSString* filename = [notification object];
	if ([filename length] == 0)
		return;
	[uploadProgress setProgress:1.0];
	[uploadProgress setHidden:YES];
	[fileNameLabel setText:[NSString stringWithFormat:@"%@ %@", filename, NSLocalizedString(@"uploaded.",@"uploaded.")]];
}

- (void)fileDeleted:(NSNotification*)notification
{
	NSString* filename = [notification object];
	if ([filename length] == 0)
		return;
	[uploadProgress setProgress:1.0];
	[uploadProgress setHidden:YES];
	[fileNameLabel setText: [NSString stringWithFormat:@"%@ %@", filename, NSLocalizedString(@"deleted.",@"deleted.")]];
}

- (IBAction)helpPage:(id)sender
{
	HelpViewController *controller = [[HelpViewController alloc] init];
	[[self navigationController] pushViewController:controller animated:YES];
}

@end


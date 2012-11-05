//
//  FTableView.m
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//

#import "FTableView.h"
#import "Foursquare.h"
#import "JSONKit.h"


@implementation FTableView


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Results";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark -
#pragma mark Table view data source

//Loading the results to the UITableViewController
- (void) loadResults:(NSDictionary *)dictionary {
	
	NSArray *res = [dictionary valueForKey:@"name"];
	results = [[NSArray alloc] initWithArray:res copyItems:YES];
	NSArray *loc = (NSArray*)[dictionary valueForKey:@"location"];
	NSArray *add = [(NSDictionary*)loc valueForKey:@"address"];

	addresses = [[NSArray alloc] initWithArray:add copyItems:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(results == nil){
		return 0;
	} else {
		return [results count];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 2;

	NSString * tmp = [[NSString alloc] initWithFormat:@"%@",[addresses objectAtIndex:indexPath.row]];
	NSString *cellText;
	if ([tmp isEqualToString:@"<null>"]) {
		 cellText = [[NSString alloc] initWithFormat:@"+ %@,\nNo address available",[results objectAtIndex:indexPath.row]];	
	} else {
		cellText = [[NSString alloc] initWithFormat:@"+ %@,\n%@",[results objectAtIndex:indexPath.row],[addresses objectAtIndex:indexPath.row]];	
	}
	cell.textLabel.text = cellText;
	[tmp release];
	[cellText release];
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super dealloc];
	[results release];
	[addresses release];

}


- (void)dealloc {
    [super dealloc];
	[results release];
	[addresses release];
}


@end


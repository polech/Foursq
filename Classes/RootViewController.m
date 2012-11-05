//
//  RootViewController.m
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//

#import "Constants.h"
#import "RootViewController.h"
#import "FTableView.h"
#import "Foursquare.h"
#import "JSONKit.h"



@implementation RootViewController
@synthesize statusLabel, longitudeLabel, latitudeLabel, CLController, latit, longit, searchButton; 
@synthesize cLatitudeLabel, cLongitudeLabel, latField, longField;

-(IBAction) ButtonClicked {
	// Button clicked - coolecting Foursquare data and parsing by JSONkit
	
	if (self.latField.hidden == NO) {
		//if custom data - reading it
		[self.latField resignFirstResponder];
		[self.longField resignFirstResponder];
		self.longit = [self.longField.text doubleValue];
		self.latit = [self.latField.text doubleValue];
		
		NSString * strLa = [[NSString alloc] initWithFormat:@"Latitude: %f", self.latit];
		NSString * strLo = [[NSString alloc] initWithFormat:@"Longitude: %f", self.longit];
		[self reloadView:strLa longitude:strLo status:@"Custom values:"];
		[strLa release];
		[strLo release];
		
	}
	
	results = [[Foursquare sharedInstance] findLocationsNearbyLatitude:self.latit longitude:self.longit limit:LOCATION_LIMIT radius:LOCATION_RADIUS];
	NSDictionary *dict = [results objectFromJSONString];
	
	if(dict != nil && [dict isKindOfClass:[NSDictionary class]]){

	//Further data parsing...
	NSDictionary *response = [(NSDictionary*)dict objectForKey:@"response"];
	NSDictionary *vGroup;

	if(response != nil && [response count] > 0)
	{
		vGroup = [(NSDictionary*)response objectForKey:@"venues"];
		
	}
	
	FTableView *tView = [[FTableView alloc] initWithNibName:@"FTableView" bundle:nil];
	[tView loadResults:vGroup];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	// the View with the results
	[self.navigationController pushViewController:tView animated:YES];
	[tView release];
	} else { // If we cannot parse the received data
		NSString * strLa = [[NSString alloc] initWithFormat:@"Latitude: %f", self.latit];
		NSString * strLo = [[NSString alloc] initWithFormat:@"Longitude: %f", self.longit];
		[self reloadView:strLa longitude:strLo status:@"Could not parse"];
		[strLa release];
		[strLo release];
	}

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark View lifecycle

// starting the main view
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Location config";
	[self reloadView:@"Latitude: updating..." longitude:@"Longitude: updating..." status:@"Status:"];
	//not clicking the results until the location is set
	self.searchButton.enabled = NO;
	
	//custom values hidden when trying to locate GPS position
	self.cLatitudeLabel.hidden = YES;
	self.cLongitudeLabel.hidden = YES;
	self.latField.hidden = YES;
	self.longField.hidden = YES;
	self.latField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	self.longField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	
	//allocation of the Core Location Controller
	CLController = [[CoreLoc alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];

	//stopping if we cannot obtain the location
	[self performSelector:@selector(stopUpdatingLocation:) withObject:@"GPS Timed Out" afterDelay:GPS_TIMEOUT];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


//When the location is updated
- (void)locationUpdate:(CLLocation *)location {
	self.latit = location.coordinate.latitude;
	self.longit = location.coordinate.longitude;
	NSString * strLa = [[NSString alloc] initWithFormat:@"Latitude: %f", self.latit];
	NSString * strLo = [[NSString alloc] initWithFormat:@"Longitude: %f", self.longit];

	[self reloadView:strLa longitude:strLo status:@"Location found:"];
	[self.CLController.locMgr stopUpdatingLocation];
	self.searchButton.enabled = YES;
	[strLa release];
	[strLo release];
}


//When error during the location obtaining occured - sample coordinates
- (void)locationError:(NSError *)error {
	//creating sample location due to error with GPS connection
	self.latit = SAMPLE_LATITUDE;
	self.longit = SAMPLE_LONGITUDE;
	
	//enabling custom view
	self.cLatitudeLabel.hidden = NO;
	self.cLongitudeLabel.hidden = NO;
	self.latField.hidden = NO;
	self.longField.hidden = NO;
	self.latField.text = [NSString stringWithFormat:@"%f",self.latit];
	self.longField.text = [NSString stringWithFormat:@"%f",self.longit];
	
	
	NSString * strLa = [[NSString alloc] initWithFormat:@"Latitude: %f", self.latit];
	NSString * strLo = [[NSString alloc] initWithFormat:@"Longitude: %f", self.longit];
	
	[self reloadView:strLa longitude:strLo status:@"[ERR] Using sample:"];
	//continue the location search with sample coodrinates
	self.searchButton.enabled = YES;
	[strLa release];
	[strLo release];
}

//this method is invoked when the GPS timeout occurs
- (void)stopUpdatingLocation:(NSString *)state {
	[CLController.locMgr stopUpdatingLocation];
	self.latit = SAMPLE_LATITUDE;
	self.longit = SAMPLE_LONGITUDE;
	
	//enabling custom view
	self.cLatitudeLabel.hidden = NO;
	self.cLongitudeLabel.hidden = NO;
	self.latField.hidden = NO;
	self.longField.hidden = NO;
	self.latField.text = [NSString stringWithFormat:@"%f",self.latit];
	self.longField.text = [NSString stringWithFormat:@"%f",self.longit];
	
	
	
	NSString * strLa = [[NSString alloc] initWithFormat:@"Lat (sample): %f", self.latit];
	NSString * strLo = [[NSString alloc] initWithFormat:@"Long (sample): %f", self.longit];
	[self reloadView:strLa longitude:strLo status:@"GPS Timed Out:"];
	//search with sample location
	self.searchButton.enabled = YES;
	[strLa release];
	[strLo release];
}

//reloadint he view with the labels
- (void) reloadView:(NSString*) latitude longitude:(NSString*) longitude status:(NSString*) status
{
	
	[self.latitudeLabel setText:latitude];
	[self.longitudeLabel setText:longitude];
	[self.statusLabel setText:status];
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

//Core Location Controller is initialized on ViewDidLoad
- (void)viewDidUnload {
	CLController.delegate = self;
	[CLController release];
	[results release];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	CLController.delegate = self;
    [super dealloc];
	[CLController release];
	[results release];
}


@end


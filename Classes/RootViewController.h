//
//  RootViewController.h
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//

//main view of the application
//the view starts updating GPS location, if fails (after 15 seconds)
//the sample values are loaded and the custom fields are enables
//thus we can manually se our location and proceed
//with testing the application without GPS

#import <UIKit/UIKit.h>
#import "CoreLoc.h"


@interface RootViewController : UIViewController <UITextFieldDelegate, CoreLocDelegate>{
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *latitudeLabel;
	IBOutlet UILabel *longitudeLabel;
	IBOutlet UIButton *searchButton;
	IBOutlet UILabel *cLatitudeLabel;
	IBOutlet UILabel *cLongitudeLabel;
	IBOutlet UITextField *latField;
	IBOutlet UITextField *longField;
	
	//results from the foursquare
	NSString *results;
	
	//GPS controller
	CoreLoc *CLController;
	
	//latitude, longitude
	double latit, longit;
}

@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) CoreLoc *CLController;
@property (nonatomic, retain) UILabel *latitudeLabel;
@property (nonatomic, retain) UILabel *longitudeLabel;
@property (nonatomic, retain) UIButton *searchButton;
@property (nonatomic, retain) UILabel *cLatitudeLabel;
@property (nonatomic, retain) UILabel *cLongitudeLabel;
@property (nonatomic, retain) UITextField *latField;
@property (nonatomic, retain) UITextField *longField;
@property (nonatomic) double latit;
@property (nonatomic) double longit;

-(IBAction) ButtonClicked;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;

//when GPS updated the location
- (void)locationUpdate:(CLLocation *)location;

//when location updating failed
- (void)locationError:(NSError *)error;

//stopping updating the location (e.g due to the timeout)
- (void)stopUpdatingLocation:(NSString *)state;

//reload values in labels
- (void) reloadView:(NSString*) latitude longitude:(NSString*) longitude status:(NSString*) status;


@end

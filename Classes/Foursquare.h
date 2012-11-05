//
//  Foursqueare.h
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//
//Singleton class to use HTTP connector to foursquare.
//Some parameters (radius, limit) are predefined in Constants.h
//Authentication keys are hard-coded.


@interface Foursquare : NSObject {
	//string with HTTP response
	NSString* bodyText;
}
	
@property (nonatomic, retain) NSString* bodyText;
+ (Foursquare*) sharedInstance;


// Find locations method
- (NSString*) findLocationsNearbyLatitude:(double) latitude longitude:(double)longitude limit:(int) limit radius:(int) radius;

@end
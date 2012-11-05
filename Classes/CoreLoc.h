//
//  CoreLoc.h
//  Foursq
//
//  Created by Piotr Olech on 11/2/12.
//  Copyright 2012 SMP. All rights reserved.
//

// the class responsible for connecting with GPS
// in case we cannot obtain GPS there are implemented options
// to continue with custom values.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocDelegate 
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLoc : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;

@end

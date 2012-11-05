//
//  Foursquare.m
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//


#import "Foursquare.h"
#import "JSONKit.h"


// Instance fo singleton
static Foursquare* sharedInstance_;


#pragma mark -
#pragma mark Anonyms category

@interface Foursquare()

@end


#pragma mark -
#pragma mark Class implementation


@implementation Foursquare

@synthesize bodyText;
#pragma mark -

#pragma mark Foursquare service methods

/**
 Using fourquare API v2!
 */ 

- (NSString*) findLocationsNearbyLatitude:(double) latitude longitude:(double)longitude limit:(int) limit radius:(int) radius
{
	// if there is any old data, cleaning it
	bodyText = nil;
	
	//Foursquare parameters to obtain data
	NSMutableString *venuesURL = [[NSMutableString alloc] initWithFormat:@"https://api.foursquare.com/v2/venues/search?"];
	[venuesURL appendFormat:@"ll=%f,%f", latitude, longitude];

	[venuesURL appendFormat:@"&limit=%d", limit];
	[venuesURL appendFormat:@"&client_secret=E5CBAAHSEU1MT3WHUQ4A2WRHOYZ2AGUQXSED21OCHXLFAL3Q"];
	[venuesURL appendFormat:@"&client_id=HKUKKFDG42PDMXFX3RD0CWYSBTAUXTPHLLKRLNPNZJSSXTSR&v=20120101"];

	NSURL *url = [[NSURL alloc] initWithString:venuesURL];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	// Execute URL and read response
	NSHTTPURLResponse *httpResponse;
	NSData *resp = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:NULL];
	
	if(resp != nil && httpResponse != NULL && [httpResponse statusCode] >= 200 && [httpResponse statusCode] < 300)
	{
		bodyText = [[NSString alloc] initWithData:resp encoding:NSUTF8StringEncoding];
	}
	else
	{ 
		bodyText = nil;
	}
	
	//release objects
	[venuesURL release];
	[url release];
	[request release];
	[NSURL release];
	
	
	return bodyText;
}


#pragma mark -
#pragma mark Singelton methods

- (id) init
{
	self = [super init];
	bodyText = nil;
	return self;
}


// Get the shared instance of this singelton.
+ (Foursquare*) sharedInstance
{
	@synchronized(self)
	{
		[[self alloc] init];
	}
	
	return sharedInstance_;
}

// Overwrite allocWithZone to be sure to 
// allocate memory only once.
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedInstance_ == nil) {
			sharedInstance_ = [super allocWithZone:zone];
			return sharedInstance_;
		}
	}
	
	return nil;
}

// Nobody should be able to copy 
// the shared instance.
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

// Retaining the shared instance should not
// effect the retain count.
- (id)retain
{
	return self;
}

// Releasing the shared instance should not
// effect the retain count.
- (void)release
{
	if(bodyText != nil){
		[bodyText release];
	}
}

// Auto-releasing the shared instance should not
// effect the retain count.
- (id)autorelease
{
	return self;
}

// Retain count should not go to zero.
- (NSUInteger)retainCount
{
	return NSUIntegerMax;
}


@end

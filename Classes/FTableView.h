//
//  FTableView.h
//  Foursq
//
//  Created by Piotr Olech on 11/1/12.
//  Copyright 2012 SMP. All rights reserved.
//

//second view of the application 
//FableView gets the results from RootViewController and parses them
//then fill UITableCiewController

#import <UIKit/UIKit.h>


@interface FTableView : UITableViewController {

	NSArray *results;
	NSArray *addresses;
	
}

//loading and parsing the results
-(void) loadResults:(NSDictionary *)dictionary;

@end

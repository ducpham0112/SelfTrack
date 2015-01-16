//
//  TimeTrack.h
//  Self-Track
//
//  Created by Duc Pham on 1/16/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryTracked;

@interface TimeTrack : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) CategoryTracked *category;

@end

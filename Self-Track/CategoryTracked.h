//
//  CategoryTracked.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TimeTrack;

@interface CategoryTracked : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *listTimeTracked;
@end

@interface CategoryTracked (CoreDataGeneratedAccessors)

- (void)addListTimeTrackedObject:(TimeTrack *)value;
- (void)removeListTimeTrackedObject:(TimeTrack *)value;
- (void)addListTimeTracked:(NSSet *)values;
- (void)removeListTimeTracked:(NSSet *)values;

@end

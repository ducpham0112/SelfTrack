//
//  CoreDataFunctions.m
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import "CoreDataFunctions.h"
#import "AppDelegate.h"
#import "CategoryTracked.h"
#import "TimeTrack.h"

#define SECONDS_PER_MINUTE (60)
#define MINUTES_PER_HOUR (60)
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * MINUTES_PER_HOUR)
#define HOURS_PER_DAY (24)

@implementation CoreDataFunctions

+ (NSString*)stringSecondFromInterval: (double) timeInterval {
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int ti = (int)timeInterval;
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", ti / SECONDS_PER_HOUR, (ti / SECONDS_PER_MINUTE) % MINUTES_PER_HOUR, ti % SECONDS_PER_MINUTE];
}

+ (NSTimeInterval)durationFrom:(NSDate *)startTime To:(NSDate *)endTime {
    NSTimeInterval totalTime = ([endTime timeIntervalSinceDate:startTime]);
    return totalTime;
}
+ (NSArray*) listCategory {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate.fetchedResultsController.fetchedObjects;
}

+ (NSInteger) daysWithinEraFromDate: (NSDate*) startDate toDate: (NSDate*) endDate{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* fromDate, *toDate;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:startDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    
    NSDateComponents* diff = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return [diff day];
}

+ (NSArray*) listCategoryWithDuration: (BOOL) type {
    NSMutableArray* listCategoryWithDuration = [[NSMutableArray alloc] init];
    
    for (CategoryTracked* category in [self listCategory]) {
        NSArray* listTime = [category.listTimeTracked allObjects];
        NSInteger day = type ? 7 : 30;
        double duration = 0;
        for (TimeTrack* time in listTime) {
            NSInteger diff = [self daysWithinEraFromDate:(NSDate*)time.startTime toDate:[NSDate date]];
            if (diff < day) {
                duration += [time.duration doubleValue];
            }
        }
        
        NSDictionary* categoryWithDuration = @{
                                               @"name": category.name,
                                               @"duration": [NSNumber numberWithDouble:duration],
                                               @"color": category.color,
                                               @"durationStr": [self stringSecondFromInterval:duration]
                                               };
        [listCategoryWithDuration addObject:categoryWithDuration];
    };
    return listCategoryWithDuration;
}
+ (int) getIndexOfCategoryWithName: (NSString*) categoryName {
    if (categoryName == nil) {
        return -1;
    }
    NSArray* listCategory = [self listCategory];
    for (int i = (int)[listCategory count]; --i >= 0; ) {
        CategoryTracked* curCategory = [listCategory objectAtIndex:i];
        if ([curCategory.name isEqualToString:categoryName]) {
            return i;
        }
    }
    return -1;
}
+ (BOOL) addNewCategoryWithName: (NSString*) name  withChartColor: (UIColor*) color{
    if (name == nil) {
        return NO;
    }
    for (CategoryTracked* category in [self listCategory]) {
        if ([category.name isEqualToString:name]) {
            return NO;
        }
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    CategoryTracked* newCategory = (CategoryTracked*)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryTracked" inManagedObjectContext:delegate.managedObjectContext];
    newCategory.name = name;
    newCategory.color = [NSKeyedArchiver archivedDataWithRootObject:color];
    return [self saveContent];
}

+ (BOOL) editCategoryWithName: (NSString*) oldName withNewName: (NSString*) newName hasColor:(UIColor*) color {
    CategoryTracked* category;
    for (CategoryTracked* cat in [self listCategory]) {
        if ([cat.name isEqualToString:oldName]) {
            category = cat;
            break;

        }
    }
    if (category == nil) {
        return NO;
    }
    
    category.name = newName;
    category.color = [NSKeyedArchiver archivedDataWithRootObject:color];
    
    return [self saveContent];
}

+ (BOOL) addNewTimeWithStarttime: (NSDate*) startTime endTime:(NSDate*) endTime inCategoryWithName: (NSString*) categoryName{
    CategoryTracked* category = nil;
    for (CategoryTracked* cat in [self listCategory]) {
        if ([cat.name isEqualToString:categoryName]){
            category = cat;
            break;
        }
    }
    if (category == nil) {
        return NO;
    }
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    TimeTrack* newTime = (TimeTrack*)[NSEntityDescription insertNewObjectForEntityForName:@"TimeTrack" inManagedObjectContext:delegate.managedObjectContext];
    newTime.startTime = startTime;
    newTime.duration = [NSNumber numberWithDouble:[self durationFrom:startTime To:endTime]];
    newTime.category = category;
    
    [category addListTimeTrackedObject:newTime];
    
    return [self saveContent];
}

+ (BOOL) saveContent {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSError* error;
    [delegate.managedObjectContext save:&error];
    delegate.fetchedResultsController = nil;
    if (error == nil) {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"UpdateTable" object:self];
        return YES;
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to save content to database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        NSLog(@"Fail to save content! Error: %@", [error userInfo]);
        return NO;
    }
}

@end

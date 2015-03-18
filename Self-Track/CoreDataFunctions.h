//
//  CoreDataFunctions.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreDataFunctions : NSObject
+ (NSTimeInterval)durationFrom:(NSDate *)startTime To:(NSDate *)endTime ;
+ (BOOL) editCategoryWithName: (NSString*) oldName withNewName: (NSString*) newName hasColor:(UIColor*) color;
+ (NSString*)stringSecondFromInterval: (double) timeInterval;
+ (NSArray*) listCategory;
+ (BOOL) addNewCategoryWithName: (NSString*) name withChartColor: (UIColor*) color;
+ (BOOL) saveContent ;
+ (NSArray*) listCategoryWithDuration: (BOOL) type ;
+ (BOOL) addNewTimeWithStarttime: (NSDate*) startTime endTime:(NSDate*) endTime inCategoryWithName: (NSString*) categoryName;
+ (int) getIndexOfCategoryWithName: (NSString*) categoryName;
@end

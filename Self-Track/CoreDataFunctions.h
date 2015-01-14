//
//  CoreDataFunctions.h
//  Self-Track
//
//  Created by Duc Pham on 1/14/15.
//  Copyright (c) 2015 CSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataFunctions : NSObject

+ (NSArray*) listCategory;
+ (BOOL) addNewCategoryWithName: (NSString*) name ;
+ (BOOL) saveContent ;
+ (NSArray*) listCategoryWithDuration ;
+ (BOOL) addNewTimeWithStarttime: (NSDate*) startTime endTime:(NSDate*) endTime inCategoryWithName: (NSString*) categoryName;
+ (int) getIndexOfCategoryWithName: (NSString*) categoryName;
@end

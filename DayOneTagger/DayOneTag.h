//
//  DayOneTag.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/4/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayOneEntry;

@interface DayOneTag : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) DayOneEntry *entry;

@end

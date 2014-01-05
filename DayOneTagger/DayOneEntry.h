//
//  DayOneEntry.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/4/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DayOneEntry : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *tags;
@end

@interface DayOneEntry (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

//
//  DayOneEntry.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/4/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayOneTag;

@interface DayOneEntry : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * starred;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * touched;
@property (nonatomic, retain) NSSet *tags;

- (void) removeTag:(NSString *)tagText;
- (void) addTag:(NSString *)tagText;

- (void) saveAsDayOneEntry;
@end

@interface DayOneEntry (CoreDataGeneratedAccessors)

- (void)addTagsObject:(DayOneTag *)value;
- (void)removeTagsObject:(DayOneTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end

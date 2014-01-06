//
//  DayOneEntry.m
//  DayOneTagger
//
//  Created by Brock Boland on 1/4/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import "DayOneEntry.h"
#import "DayOneTag.h"


@implementation DayOneEntry

@dynamic text;
@dynamic creationDate;
@dynamic starred;
@dynamic uuid;
@dynamic touched;
@dynamic tags;

-(void)awakeFromInsert {
  self.touched = NO;
}

// Add a tag to this entry. Just takes the string for the tag text
- (void) addTag:(NSString *)tagText {
  for (DayOneTag *tag in self.tags) {
    if ([tag.text isEqualToString:tagText]) {
      // Tag is already on the object, so there's nothing to do
      return;
    }
  }
  // If we got this far, the tag wasn't found in the tags already on this entry, so add it
  DayOneTag *newTag = (DayOneTag *)[NSEntityDescription insertNewObjectForEntityForName:@"DayOneTag" inManagedObjectContext:[self managedObjectContext]];
  newTag.text = tagText;
  [self addTagsObject:newTag];
}


// Remove a tag for this entry. Just takes the string for the tag text
- (void) removeTag:(NSString *)tagText {
  for (DayOneTag *tag in self.tags) {
    if ([tag.text isEqualToString:tagText]) {
      // Found the tag: remove it, and bail out of the loop
      [self removeTagsObject:tag];
      break;
    }
  }
}




@end

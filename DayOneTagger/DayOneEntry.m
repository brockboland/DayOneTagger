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


- (void) saveAsDayOneEntry {
  NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
  [values setValue:self.creationDate forKey:@"Creation Date"];
  [values setValue:self.text forKey:@"Entry Text"];
  [values setValue:self.uuid forKey:@"UUID"];

  if ([self.starred intValue] > 0) {
    [values setValue:@YES forKey:@"Starred"];
  }
  else {
    [values setValue:@NO forKey:@"Starred"];
  }

  if ([self.tags count] > 0) {
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (DayOneTag *tag in self.tags) {
      [tags addObject:tag.text];
    }
    [values setValue:tags forKey:@"Tags"];
  }

  NSString *filename = [NSString stringWithFormat:@"%@%@.doentry", @"/Users/bboland/Desktop/Testing/", self.uuid];
  [values writeToFile:filename atomically:YES];
}

@end

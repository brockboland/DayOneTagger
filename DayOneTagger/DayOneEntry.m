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
  // Only update the entry
  if ([self.tags count] > 0) {
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (DayOneTag *tag in self.tags) {
      [tags addObject:tag.text];
    }

    // @todo: replace with directory that is selected in file dialog
    NSString *entriesDirectory = @"/Users/bboland/Desktop/Journal.dayone/entries/";
    // @todo: check if file exists, and create full NSDictionary for all values if it does not
    NSString *fullPath = [NSString stringWithFormat:@"%@%@.doentry", entriesDirectory, self.uuid];
    NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:fullPath];

    // Overwrite the old tags in the entry
    [contents setValue:tags forKey:@"Tags"];
    // Re-save
    [contents writeToFile:fullPath atomically:YES];
  }
}

@end

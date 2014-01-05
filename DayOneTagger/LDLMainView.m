//
//  LDLMainView.m
//  DayOneTagger
//
//  Created by Brock Boland on 1/5/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import "LDLMainView.h"
#import "DayOneEntry.h"

@implementation LDLMainView

-(BOOL)acceptsFirstResponder {
  return YES;
}


- (NSUInteger)entryCount {
  return [self.entryList count];
}


- (void)keyDown:(NSEvent*)event {
  // Keycodes:
  // 126 up
  // 125 down
  switch( [event keyCode] ) {
    case 124:       // right arrow
      [self nextEntry:self];
      break;
    case 123:       // left arrow
      [self prevEntry:self];
      break;
    default:
      break;
  }
}


- (IBAction)prevEntry:(id)sender {
  if (self.currentEntryIndex > 0) {
    self.currentEntryIndex = self.currentEntryIndex - 1;
    [self updateDisplay];
  }
}

- (IBAction)nextEntry:(id)sender {
  self.currentEntryIndex = self.currentEntryIndex + 1;
  if (self.currentEntryIndex >= [self entryCount]) {
    self.currentEntryIndex = [self entryCount] - 1;
  }
  [self updateDisplay];
}

- (void)updateDisplay {
  DayOneEntry *currentEntry = [self.entryList objectAtIndex:self.currentEntryIndex];
  [self.entryTextView setString:currentEntry.text];

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  [self.entryDateField setStringValue:[dateFormatter stringFromDate:currentEntry.creationDate]];
}


@end

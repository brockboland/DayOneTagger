//
//  LDLMainView.m
//  DayOneTagger
//
//  Created by Brock Boland on 1/5/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import "LDLMainView.h"
#import "DayOneEntry.h"
#import "DayOneTag.h"
#import "LDLAppDelegate.h"

@implementation LDLMainView

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.defaultTagList = @[@"daylog", @"journal", @"travel", @"delete", @"review"];
    self.tagButtons = [[NSMutableArray alloc] init];

    // Become first responder so that other buttons are not highlighted
    [self becomeFirstResponder];
  }
  return self;
}

- (void)prepForDisplayWithManagedObjectContext:(NSManagedObjectContext*)context {
  self.managedObjectContext = context;

  // Start off filtering on All
  self.currentFiltering = 0;
  // Load saved entries
  [self updateEntryList:nil];

  self.currentEntryIndex = 0;

  // Reset to default tags
  self.tagList = [[NSMutableArray alloc] initWithArray:self.defaultTagList];

  // Get any other tags that are in use in the CoreData store
  NSFetchRequest *tagFetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *tagEntity = [NSEntityDescription entityForName:@"DayOneTag" inManagedObjectContext:self.managedObjectContext];
  [tagFetchRequest setEntity:tagEntity];
  NSError *tagError = nil;
  NSArray *tagFetchedObjects = [self.managedObjectContext executeFetchRequest:tagFetchRequest error:&tagError];
  if (tagFetchedObjects == nil) {
    NSLog(@"Error loading tags");
  }
  else {
    for (id tag in tagFetchedObjects) {
      NSString *tagText = [tag valueForKey:@"text"];
      if (![self.tagList containsObject:tagText]) {
        [self.tagList addObject:tagText];
      }
    }
  }

  [self addTagToggleButtons];

  // Finally, we are ready to show the first entry
  [self displayCurrentEntry];
}

// Flip the grid so that 0,0 is at the top left, so that tag toggle buttons can be positioned more easily
-(BOOL)isFlipped {
  return YES;
}

// Loop over the tag list and add a toggle button for each tag
- (void)addTagToggleButtons {
  CGFloat runningTop = 30;

  // Start the button counter with 1, so they correspond as expected to keypresses: those start at 1, not 0
  NSUInteger buttonIndexCounter = 1;
  // Put a blank object at 0, because it won't add at 1 if there is on 0
  [self.tagButtons insertObject:@"" atIndex:0];

  for (id tagName in self.tagList) {
    // Create and place a button
    NSButton *tagButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(10, runningTop, 175, 32))];
    [self addSubview:tagButton];
    [tagButton setTitle:[NSString stringWithFormat:@"%lu: %@", (unsigned long)buttonIndexCounter, tagName]];
    [tagButton setTag:buttonIndexCounter-1];

    // Make an on-off toggle button and start it in the off state
    [tagButton setButtonType:NSPushOnPushOffButton];
    [tagButton setBezelStyle:NSRoundedBezelStyle];
    [tagButton setAllowsMixedState:NO];
    [tagButton setState:NSOffState];

    [tagButton setTarget:self];
    [tagButton setAction:@selector(tagButtonClick:)];

    [self.tagButtons insertObject:tagButton atIndex:buttonIndexCounter];
    buttonIndexCounter++;

    runningTop += 32;
  }
}

// Allow this view to become first responder, so that it gets the focus (might also be necessary to capture keypresses)
-(BOOL)acceptsFirstResponder {
  return YES;
}


- (NSUInteger)entryCount {
  return [self.entryList count];
}


- (void)keyDown:(NSEvent*)event {
  // Check if the key pressed was a number
  NSInteger pressedNumber;
  NSScanner *scanner = [NSScanner scannerWithString:[event characters]];
  if ([scanner scanInteger:&pressedNumber]) {
    [self toggleTag:pressedNumber];
  }
  else {
    // Not a number: check the actual keycode
    switch( [event keyCode] ) {
      case kVK_RightArrow:       // right arrow
        [self nextEntry:self];
        break;
      case kVK_LeftArrow:       // left arrow
        [self prevEntry:self];
        break;
    }
  }
}


// Click handler for the Previous button. Also triggered by pressing the left arrow
- (IBAction)prevEntry:(id)sender {
  if (self.currentEntryIndex > 0) {
    self.currentEntryIndex = self.currentEntryIndex - 1;
    [self displayCurrentEntry];
  }
}

// Click handler for the Next button. Also triggered by pressing the right arrow
- (IBAction)nextEntry:(id)sender {
  self.currentEntryIndex = self.currentEntryIndex + 1;
  if (self.currentEntryIndex >= [self entryCount]) {
    self.currentEntryIndex = [self entryCount] - 1;
  }
  [self displayCurrentEntry];
}

// Update the view to display the current entry
- (void)displayCurrentEntry {
  // Make sure we're looking at a valid index
  if ([self entryCount] > self.currentEntryIndex) {
    // First, clear the tag toggle buttons
    [self toggleAllTagsOff];

    DayOneEntry *currentEntry = [self.entryList objectAtIndex:self.currentEntryIndex];

    // Show the entry text
    [self.entryTextView setString:currentEntry.text];
    [self.entryTextView setEditable:NO];

    // Format and display the entry date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.entryDateField setStringValue:[dateFormatter stringFromDate:currentEntry.creationDate]];

    // Toggle on the tag buttons for tags already on the current entry
    for (DayOneTag *tag in currentEntry.tags) {
      [self turnOnTag:tag.text];
    }
  }

  // Show the "x of y" count at the bottom of the window
  NSString *progressIndicator = [NSString stringWithFormat:@"Entry %lu of %lu", self.currentEntryIndex+1, (unsigned long)[self entryCount]];
  [self.entryProgressIndicator setStringValue:progressIndicator];
}


// Toggle button click
- (void)tagButtonClick:(NSButton *)tagButton {
  DayOneEntry *currentEntry = [self.entryList objectAtIndex:self.currentEntryIndex];
  // State has already changed by the time this method runs
  if (tagButton.state == NSOnState) {
    [currentEntry addTag:[self.tagList objectAtIndex:tagButton.tag]];
  }
  else {
    [currentEntry removeTag:[self.tagList objectAtIndex:tagButton.tag]];
  }
  [self.appDelegate saveAction:self];
}


// Toggle a tag on or off for the current entry. Triggered by keypresses
- (void)toggleTag:(NSUInteger)tagIndex {
  @try {
    DayOneEntry *currentEntry = [self.entryList objectAtIndex:self.currentEntryIndex];
    NSButton *tagButton = [self.tagButtons objectAtIndex:tagIndex];
    if (tagButton.state == NSOnState) {
      tagButton.state = NSOffState;
      [currentEntry removeTag:[self.tagList objectAtIndex:tagIndex-1]];
    }
    else {
      tagButton.state = NSOnState;
      [currentEntry addTag:[self.tagList objectAtIndex:tagIndex-1]];
    }
    [self.appDelegate saveAction:self];
  }
  @catch (NSException *exception) {
    // Trying to toggle a button that doens't exist
  }
}

// Turn on the tag toggle button for hte given tag name
- (void) turnOnTag:(NSString *)tagText {
  NSUInteger tagIndex = [self.tagList indexOfObject:tagText];
  if (tagIndex != NSNotFound) {
    // Add one to the tag index, since the tagButton array starts at 1 to correspond with keyboard shortcuts
    NSButton *tagButton = [self.tagButtons objectAtIndex:tagIndex+1];
    tagButton.state = NSOnState;
  }
}

// "Clear" all tag toggles by switching them off
- (void)toggleAllTagsOff {
  for (id item in self.tagButtons) {
    if ([item isKindOfClass:[NSButton class]]) {
      NSButton *tagButton = (NSButton*)item;
      tagButton.state = NSOffState;
    }
  }
}


// Click handler for the segment control
// Change the filtering on the entry list
- (IBAction)changedFilter:(NSSegmentedControl*)sender {
  if ([sender selectedSegment] != self.currentFiltering) {
    switch ([sender selectedSegment]) {
      case LDLItemToggleAll:
        [self updateEntryList:nil];
        break;
      case LDLItemToggleUntagged:
        [self updateEntryList:[NSPredicate predicateWithFormat:@"tags.@count == 0"]];
        break;
      case LDLItemToggleTagged:
        [self updateEntryList:[NSPredicate predicateWithFormat:@"tags.@count > 0"]];
        break;
    }

    self.currentFiltering = [sender selectedSegment];

    // Display the first item
    self.currentEntryIndex = 0;
    [self displayCurrentEntry];
  }
}


// Update the entry list. Takes a filtering predicate; if nil, all entries are returned
- (void)updateEntryList:(NSPredicate *)predicate {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayOneEntry" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Add the filtering predicate, if there is one
  if (predicate != nil) {
    [fetchRequest setPredicate:predicate];
  }

  // Sort by creation date
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];


  NSError *error = nil;
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  if (fetchedObjects == nil) {
    NSLog(@"Error updating result set");
  }
  else {
    self.entryList = fetchedObjects;
  }
}

@end

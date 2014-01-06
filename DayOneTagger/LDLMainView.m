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




/*
 *  Summary:
 *    Virtual keycodes
 *    From http://snipplr.com/view/42797/ (removed some extras)
 *
 *  Discussion:
 *    These constants are the virtual keycodes defined originally in
 *    Inside Mac Volume V, pg. V-191. They identify physical keys on a
 *    keyboard. Those constants with "ANSI" in the name are labeled
 *    according to the key position on an ANSI-standard US keyboard.
 *    For example, kVK_ANSI_A indicates the virtual keycode for the key
 *    with the letter 'A' in the US keyboard layout. Other keyboard
 *    layouts may have the 'A' key label on a different physical key;
 *    in this case, pressing 'A' will generate a different virtual
 *    keycode.
 */
enum {
  kVK_ANSI_A                    = 0x00,
  kVK_ANSI_S                    = 0x01,
  kVK_ANSI_D                    = 0x02,
  kVK_ANSI_F                    = 0x03,
  kVK_ANSI_H                    = 0x04,
  kVK_ANSI_G                    = 0x05,
  kVK_ANSI_Z                    = 0x06,
  kVK_ANSI_X                    = 0x07,
  kVK_ANSI_C                    = 0x08,
  kVK_ANSI_V                    = 0x09,
  kVK_ANSI_B                    = 0x0B,
  kVK_ANSI_Q                    = 0x0C,
  kVK_ANSI_W                    = 0x0D,
  kVK_ANSI_E                    = 0x0E,
  kVK_ANSI_R                    = 0x0F,
  kVK_ANSI_Y                    = 0x10,
  kVK_ANSI_T                    = 0x11,
  kVK_ANSI_1                    = 0x12,
  kVK_ANSI_2                    = 0x13,
  kVK_ANSI_3                    = 0x14,
  kVK_ANSI_4                    = 0x15,
  kVK_ANSI_6                    = 0x16,
  kVK_ANSI_5                    = 0x17,
  kVK_ANSI_Equal                = 0x18,
  kVK_ANSI_9                    = 0x19,
  kVK_ANSI_7                    = 0x1A,
  kVK_ANSI_Minus                = 0x1B,
  kVK_ANSI_8                    = 0x1C,
  kVK_ANSI_0                    = 0x1D,
  kVK_ANSI_RightBracket         = 0x1E,
  kVK_ANSI_O                    = 0x1F,
  kVK_ANSI_U                    = 0x20,
  kVK_ANSI_LeftBracket          = 0x21,
  kVK_ANSI_I                    = 0x22,
  kVK_ANSI_P                    = 0x23,
  kVK_ANSI_L                    = 0x25,
  kVK_ANSI_J                    = 0x26,
  kVK_ANSI_Quote                = 0x27,
  kVK_ANSI_K                    = 0x28,
  kVK_ANSI_Semicolon            = 0x29,
  kVK_ANSI_Backslash            = 0x2A,
  kVK_ANSI_Comma                = 0x2B,
  kVK_ANSI_Slash                = 0x2C,
  kVK_ANSI_N                    = 0x2D,
  kVK_ANSI_M                    = 0x2E,
  kVK_ANSI_Period               = 0x2F,
  kVK_ANSI_Grave                = 0x32,
  kVK_ANSI_KeypadDecimal        = 0x41,
  kVK_ANSI_KeypadMultiply       = 0x43,
  kVK_ANSI_KeypadPlus           = 0x45,
  kVK_ANSI_KeypadClear          = 0x47,
  kVK_ANSI_KeypadDivide         = 0x4B,
  kVK_ANSI_KeypadEnter          = 0x4C,
  kVK_ANSI_KeypadMinus          = 0x4E,
  kVK_ANSI_KeypadEquals         = 0x51,
  kVK_ANSI_Keypad0              = 0x52,
  kVK_ANSI_Keypad1              = 0x53,
  kVK_ANSI_Keypad2              = 0x54,
  kVK_ANSI_Keypad3              = 0x55,
  kVK_ANSI_Keypad4              = 0x56,
  kVK_ANSI_Keypad5              = 0x57,
  kVK_ANSI_Keypad6              = 0x58,
  kVK_ANSI_Keypad7              = 0x59,
  kVK_ANSI_Keypad8              = 0x5B,
  kVK_ANSI_Keypad9              = 0x5C
};

/* keycodes for keys that are independent of keyboard layout*/
enum {
  kVK_Return                    = 0x24,
  kVK_Tab                       = 0x30,
  kVK_Space                     = 0x31,
  kVK_Delete                    = 0x33,
  kVK_Escape                    = 0x35,
  kVK_Command                   = 0x37,
  kVK_Shift                     = 0x38,
  kVK_CapsLock                  = 0x39,
  kVK_Option                    = 0x3A,
  kVK_Control                   = 0x3B,
  kVK_RightShift                = 0x3C,
  kVK_RightOption               = 0x3D,
  kVK_RightControl              = 0x3E,
  kVK_Function                  = 0x3F,
  kVK_F17                       = 0x40,
  kVK_VolumeUp                  = 0x48,
  kVK_VolumeDown                = 0x49,
  kVK_Mute                      = 0x4A,
  kVK_F18                       = 0x4F,
  kVK_F19                       = 0x50,
  kVK_F20                       = 0x5A,
  kVK_F5                        = 0x60,
  kVK_F6                        = 0x61,
  kVK_F7                        = 0x62,
  kVK_F3                        = 0x63,
  kVK_F8                        = 0x64,
  kVK_F9                        = 0x65,
  kVK_F11                       = 0x67,
  kVK_F13                       = 0x69,
  kVK_F16                       = 0x6A,
  kVK_F14                       = 0x6B,
  kVK_F10                       = 0x6D,
  kVK_F12                       = 0x6F,
  kVK_F15                       = 0x71,
  kVK_Help                      = 0x72,
  kVK_Home                      = 0x73,
  kVK_PageUp                    = 0x74,
  kVK_ForwardDelete             = 0x75,
  kVK_F4                        = 0x76,
  kVK_End                       = 0x77,
  kVK_F2                        = 0x78,
  kVK_PageDown                  = 0x79,
  kVK_F1                        = 0x7A,
  kVK_LeftArrow                 = 0x7B,
  kVK_RightArrow                = 0x7C,
  kVK_DownArrow                 = 0x7D,
  kVK_UpArrow                   = 0x7E
};
//////// END keycodes



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
  switch( [event keyCode] ) {
    case kVK_RightArrow:       // right arrow
      [self nextEntry:self];
      break;
    case kVK_LeftArrow:       // left arrow
      [self prevEntry:self];
      break;

    case kVK_ANSI_0:
      [self toggleTag:0];
      break;
    case kVK_ANSI_1:
      [self toggleTag:1];
      break;
    case kVK_ANSI_2:
      [self toggleTag:2];
      break;
    case kVK_ANSI_3:
      [self toggleTag:3];
      break;
    case kVK_ANSI_4:
      [self toggleTag:4];
      break;
    case kVK_ANSI_5:
      [self toggleTag:5];
      break;
    case kVK_ANSI_6:
      [self toggleTag:6];
      break;
    case kVK_ANSI_7:
      [self toggleTag:7];
      break;
    case kVK_ANSI_8:
      [self toggleTag:8];
      break;
    case kVK_ANSI_9:
      [self toggleTag:9];
      break;
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
      case 0:
        // All items
        [self updateEntryList:nil];
        break;
      case 1:
        // Untagged
        [self updateEntryList:[NSPredicate predicateWithFormat:@"tags.@count == 0"]];
        break;
      case 2:
        // Tagged
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

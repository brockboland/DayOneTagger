//
//  LDLMainView.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/5/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LDLAppDelegate;

// Virtual keycodes. From http://snipplr.com/view/42797/
enum {
  kVK_LeftArrow                 = 0x7B,
  kVK_RightArrow                = 0x7C,
  kVK_DownArrow                 = 0x7D,
  kVK_UpArrow                   = 0x7E
};

typedef NS_ENUM(NSInteger, LDLItemToggle) {
  LDLItemToggleAll = 0,
  LDLItemToggleUntagged = 1,
  LDLItemToggleTagged = 2
};



@interface LDLMainView : NSView

@property (unsafe_unretained) IBOutlet NSTextView *entryTextView;
@property (weak) IBOutlet NSTextField *entryDateField;
@property (weak) IBOutlet NSTextField *entryProgressIndicator;
@property (weak) NSManagedObjectContext *managedObjectContext;

@property NSUInteger currentEntryIndex;
@property (strong) NSArray *entryList;
@property (strong) NSMutableArray *tagList;
@property (strong) NSArray *defaultTagList;
@property (strong) NSMutableArray *tagButtons;
@property (weak) LDLAppDelegate *appDelegate;
@property NSInteger currentFiltering;


- (void)prepForDisplayWithManagedObjectContext:(NSManagedObjectContext*)context;
- (IBAction)prevEntry:(id)sender;
- (IBAction)nextEntry:(id)sender;
- (void)displayCurrentEntry;
- (IBAction)changedFilter:(NSSegmentedControl*)sender;

@end

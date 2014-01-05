//
//  LDLMainView.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/5/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LDLMainView : NSView

@property (unsafe_unretained) IBOutlet NSTextView *entryTextView;
@property (weak) IBOutlet NSTextField *entryDateField;

@property NSUInteger currentEntryIndex;
@property (strong) NSArray *entryList;


- (IBAction)prevEntry:(id)sender;
- (IBAction)nextEntry:(id)sender;

- (void)updateDisplay;

@end
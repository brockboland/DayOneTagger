//
//  LDLAppDelegate.h
//  DayOneTagger
//
//  Created by Brock Boland on 1/4/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LDLAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)importEntries:(id)sender;

@end

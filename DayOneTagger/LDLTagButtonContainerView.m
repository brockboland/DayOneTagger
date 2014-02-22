//
//  LDLTagButtonContainerView.m
//  DayOneTagger
//
//  Created by Brock Boland on 2/21/14.
//  Copyright (c) 2014 Lucky Dog Labs. All rights reserved.
//

#import "LDLTagButtonContainerView.h"

@implementation LDLTagButtonContainerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(BOOL)isFlipped {
  return YES;
}

@end

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

@end

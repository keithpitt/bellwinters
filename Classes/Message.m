//
//  Message.m
//  Winterbells
//
//  Created by Keith Pitt on 18/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize hidden;

- (id)init {
				self = [super init];
				if (self != nil) {
        hidden = true;
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"TapToStart.png"]];
        position.x = 55;
        position.y = 50;
				}
				return self;
}

-(void)render {
				if (!hidden) {
        [sprite renderAtPoint:position centerOfImage:false];
				}
}

@end

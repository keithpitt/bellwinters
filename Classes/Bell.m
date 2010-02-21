//
//  Bell.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Bell.h"
#import "Player.h"
#import "World.h"

@implementation Bell

@synthesize activated;

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bell.png"]];
								position.x = rand() % 320;
								position.y = rand() % 300;
				}
				return self;
}

-(void)collisionWith:(Player *)player {
				[world unregisterEntity:self];
				[world registerEntity:[[Bell alloc] init]];
}

-(void)render {
				if (!activated) {
								[sprite renderAtPoint:position centerOfImage:false];
				}
}

@end

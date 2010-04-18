//
//  Bell.m
//  Winterbells
//
//  Created by Keith Pitt on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Bell.h"
#import "Player.h"
#import "World.h"
#import "Game.h"

@implementation Bell

@synthesize activated;

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bell.png"]];
				}
				return self;
}

-(void)collisionWith:(Player *)player {
    if ( [player isKindOfClass: [Player class]] == YES ) {
        [self kill];
    }
}

-(void)render {
				if (!activated) {
								[sprite renderAtPoint:[self getPositionOnScreen] centerOfImage:false];
				}
}

-(void)kill {
    [super kill];
    [(Game *)world generateBell];
}

-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY {
    // If the bell goes past (x)px at the bottom of the screen, take it out of memory.
    if (deltaY < -70) {
        [self kill];
    }
}

@end

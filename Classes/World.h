//
//  Universe.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Player.h"

@interface World : NSObject {
				@private
				CGPoint gravity; // m/s^2
				float windResistance;
				CGRect bounds;
    CGPoint center;
    Player * player;
    CGPoint offset;
				
				NSMutableArray * entities;
				NSMutableArray * entitiesToRelease;
    NSMutableArray * entitiesToAdd;
}

@property(nonatomic, readonly)NSMutableArray *	entities;
@property(nonatomic, readonly)Player         * player;
@property(nonatomic, readonly)CGPoint        offset;

// Init methods
- (id)initWithBounds:(CGRect)bounds;

// Entity management
- (void)registerPlayer:(Player*)entity;
- (void)registerEntity:(Entity*)entity;
- (void)unregisterEntity:(Entity*)entity;
- (CGPoint)positionOnScreen:(CGPoint)x;

// User Input
- (void)handleAccelerometer:(UIAcceleration *)acceleration;
- (void)handleTapAtPoint:(CGPoint)point;

// Game logic
- (void)render;
- (void)cleanup;
- (void)update:(float)delta;
- (void)focus;
- (void)replay;

- (void)setup; // This is overwritten in the level.
- (void)logic; // This is overwritten in the level.

@end

//
//  Universe.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface World : NSObject {
				@private
				CGPoint gravity; // m/s^2
				float windResistance;
				CGRect bounds;
				NSMutableArray * entities;
}

// Init methods
- (id)initWithBounds:(CGRect)bounds;

// Entity management
- (void)registerEntity:(Entity*)entity;

// User Input
- (void)handleAccelerometer:(UIAcceleration *)acceleration;
- (void)handleTapAtPoint:(CGPoint)point;

// Game logic
- (void)render;
- (void)update:(float)delta;

@end

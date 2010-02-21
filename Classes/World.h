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
				float gravity; // m/s^2
				float windResistance;
				NSMutableArray * entities;
}

// Entity management
- (void)registerEntity:(Entity*)entity;

// User Input
- (void)handleAccelerometer:(UIAcceleration *)acceleration;

// Game logic
- (void)render;
- (void)update:(float)delta;


@end

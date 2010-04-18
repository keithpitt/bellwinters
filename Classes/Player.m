//
//  Player.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Player.h"
#import "Bell.h"
#import "World.h"

@interface Player()
    BOOL grounded;
@end

@implementation Player

@synthesize active;
@synthesize hidden;
@synthesize killed;

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bunny.png"]];
								//position.x = 125;
        position.x = 100;
								position.y = 10;
								movement.x = 0;
								movement.y = 0;
								grounded = false;
        focused = true;
        killed = false;
        hidden = false;
				}
				return self;
}

-(void)update:(float)delta {
    
    // No need to calculate anymore.
    if (killed && hidden) {
        return;
    }
				
				// If the entity is in the air, apply gravity.
				if (position.y > 0) {
								movement.y += gravity.y * delta;
				}

				// Move by our movement vector
				position.x += movement.x * delta;
				position.y += movement.y * delta;
    
    // NSLog(@"%f", position.y);
				
				if (position.y > 0) {
								grounded = false;
				}
    
				if(grounded){
								movement.y = 0;
				}
    
}

-(void)kill {
    focused = false;
    killed = true;
}

-(void)render {
				if (!hidden) {
								[sprite renderAtPoint:[self getPositionOnScreen] centerOfImage:false];
				}
}

-(void)handleTapAtPoint:(CGPoint)point {
				if(grounded) {
								movement.y = 17.0f;				
				}
}

-(void)handleAcceleration:(UIAcceleration *)acceleration {
				// Offset the x movement with the accelerometer.
    if (!grounded || (acceleration.x > 0.2f || acceleration.x < -0.2f)) {
        movement.x += (acceleration.x * 6);
    } else {
        movement.x = 0;
    }
				
}

-(void)collisionWith:(Bell *)bell {
    if ( [bell isKindOfClass: [Bell class]] == YES ) {
        if (!bell.activated) {
            bell.activated = true;
            movement.y = 17.0f;
        }
        active = true;
    }
}

-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY {
    
				if(deltaX != 0){
								position.x -= deltaX;
								movement.x = 0;
				}
				
				if(deltaY != 0 && !killed){
        position.y -= deltaY;
        movement.y = 0;
        grounded = true;  
				}
    
    if(deltaY < -30 && killed) {
        hidden = true;
    }
				
}

@end

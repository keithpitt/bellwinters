//
//  Player.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Player.h"
#import "Bell.h"

@interface Player()
BOOL grounded;
@end


@implementation Player

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bunny.png"]];
								position.x = 100;
								position.y = 100;
								movement.x = 0;
								movement.y = 0;
								grounded = false;
				}
				return self;
}

-(void)update:(float)delta {
				
				// If the entity is in the air, apply gravity.
				if (position.y > 0) {
								movement.y += gravity.y * delta;
				}

				// Move by our movement vector
				position.x += movement.x * delta;
				position.y += movement.y * delta;
				
				if (position.y > 0) {
								grounded = false;
				}
				if(grounded){
								movement.y = 0;
				}
}

-(void)handleTapAtPoint:(CGPoint)point {
				if(grounded) {
								movement.y = 20.0f;				
				}
}

-(void)handleAcceleration:(UIAcceleration *)acceleration {
				// Offset the x movement with the accelerometer.
//    NSLog(@"%f", acceleration.x);
    
    if (!grounded || (acceleration.x > 0.1f || acceleration.x < -0.1f)) {
        movement.x += (acceleration.x * 6);
    } else {
        movement.x = 0;
    }
				
}

-(void)collisionWith:(Bell *)bell {
				if (!bell.activated) {
								bell.activated = true;
								movement.y = 20.0f;
				}
}

-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY {
				
				if(deltaX != 0){
								position.x -= deltaX;
								movement.x = 0;
				}
				
				if(deltaY != 0){
								position.y -= deltaY;
								movement.y = 0;
								grounded = true;
				}
				
}

@end

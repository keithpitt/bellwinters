//
//  Universe.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "World.h"

@interface World()
Boolean paused;
-(void)setDefaults;
-(void)checkBounds:(Entity*)entity;
-(void)checkCollisions:(Entity*)entity;
-(void)doCollisionWithEntity:(Entity*)entity And:(Entity*)collider;
@end


@implementation World

@synthesize entities;
@synthesize player;
@synthesize offset;

- (id)init {
				self = [super init];
				if (self != nil) {
								[self setDefaults];
        [self setup];
				}
				return self;
}

-(void)setup {
    // Nothing goes here. This is overwritten in the subclass.
}

- (id)initWithBounds:(CGRect)rect {
				self = [super init];
				if (self != nil) {
								[self setDefaults];
								bounds = rect;
        center.x = bounds.size.width / 2;
        center.y = bounds.size.height / 2;
        [self setup];
				}
				return self;
}

-(void)setDefaults{
				// gravity = CGPointMake(0, -0.83);
    gravity = CGPointMake(0, -0.45);
				windResistance = 0;
				entities = [[NSMutableArray alloc] init];
				entitiesToRelease = [[NSMutableArray alloc] init];
    entitiesToAdd = [[NSMutableArray alloc] init];
    paused = false;
    
    // No world offset
    offset.x = 0;
    offset.y = 0;
}

-(void)replay {
    paused = true;
    [self cleanup];
    [entitiesToRelease release];
    [entitiesToAdd release];
    [entities release];    
    [self setDefaults];
    [self setup];
}

-(void)registerPlayer:(Player*)entity {
				player = entity;
    [self registerEntity:entity];
}

-(void)registerEntity:(Entity*)entity {
				entity.gravity = gravity;
				entity.world = self;
				[entitiesToAdd addObject:entity];
}

-(void)unregisterEntity:(Entity *)entity {
    if([entitiesToAdd containsObject:entity]) {
        [entitiesToAdd removeObject:entity];
    } else {
        [entitiesToRelease addObject:entity];
    }
}

-(CGPoint)positionOnScreen:(CGPoint)x {
    return CGPointMake(offset.x + x.x, offset.y + x.y);
}

- (void)handleTapAtPoint:(CGPoint)point {
				for(Entity * entity in entities){
								[entity handleTapAtPoint:point];
				}
}

-(void)handleAccelerometer:(UIAcceleration *)acceleration {
				for(Entity * entity in entities){
								[entity handleAcceleration:acceleration];
				}
}

-(void)update:(float)delta {
    
    // If we have paused the flow.
    if(paused) {
        return;
    }

				// Firstly, release any objects that needed to be relased
				// from the previous iteration.
				for (Entity * entity in entitiesToRelease) {
								[entities removeObject:entity];
								[entity release];
				}
				
				// Remove all the entites that needed to be cleared.
				// We should have all our memory back now...
				[entitiesToRelease removeAllObjects];
    
    // Secondaly, add entities to the "real" entities array.
    for (Entity * entity in entitiesToAdd) {
        [entities addObject:entity];
    }
    
    // Remove all the entities that we needed to add.
    [entitiesToAdd removeAllObjects];
				
				// Create a temporary clone of the entities array.
				NSMutableArray * updaters = [[NSMutableArray alloc]initWithArray:entities];
    
    // Game logic implemented in the level.
    [self logic];
				
				for(Entity * entity in updaters){
								[entity update:delta];
				}
    
    [self focus];
				
				for(Entity * entity in updaters){
								[self checkBounds:entity];
								[self checkCollisions:entity];
				}
				
				[updaters release];
				
}

-(void)checkBounds:(Entity*)entity{

				//				NSLog(@"%f",[entity rectInWorld].size.width);
				CGRect rect = [entity getRectOnScreen];
				
				float x = 0;
				float y = 0;
				
				CGPoint b = bounds.origin;
				CGPoint bx = CGPointMake(b.x + bounds.size.width, b.y + bounds.size.height);
				
				CGPoint r = rect.origin;
				CGPoint rx = CGPointMake(r.x + rect.size.width, r.y + rect.size.height);
				
				// If they hit the left side of the world. x will be set to
				// the amount of pixels they were past the boundary. For example,
				// if the rect is -5px past the left boundary (which is 0),
				// x will be set to -5px.
				if (r.x < b.x) {
								x = r.x - b.x;
				}
				
				// This is the same at the above condition, except this time we
				// are checking against the right hand side of the world.
				if (rx.x > bx.x) {
								x = rx.x - bx.x;
				}
				
				// Determine if we have gone below the rect. In any sane wolrd, this
				// would actually mean go over the top, but because Open GL is retarded,
				// we use the bottom left as 0.0
				if (r.y < b.y) {
								y = r.y - b.y;
				}
				
				// If we have gone over the top of the rect.
				if (rx.y > bx.y) {
								y = rx.y - bx.y;
				}
				
				// Todo: Check to see if the entitiy to too big for the world.
				
				if (x != 0 || y != 0) {
								[entity collisionWithWorldX:x Y:y];
				}
				
}

-(void)checkCollisions:(Entity *)entity {
				
				// Create a temporary clone of the entities array.
				NSMutableArray * colliders = [[NSMutableArray alloc]initWithArray:entities];
				
				for(Entity * collider in colliders) {
        CGRect entityRect = [entity getRectOnScreen];
        CGRect colliderRect = [collider getRectOnScreen];
								if (entity != collider && CGRectIntersectsRect(entityRect, colliderRect)) {
            // NSLog(@"entityRect: x: %f, y: %f, width: %f, height: %f", entityRect.origin.x, entityRect.origin.y, entityRect.size.width, entityRect.size.height);
            // NSLog(@"colliderRect: x: %f, y: %f, width: %f, height: %f", colliderRect.origin.x, colliderRect.origin.y, colliderRect.size.width, colliderRect.size.height);
            // NSLog(@"--");
            [self doCollisionWithEntity:entity And:collider];
								}
				}
				
				[colliders release];
				
}

-(void)doCollisionWithEntity:(Entity*)entity And:(Entity*)collider {
    [entity collisionWith:collider];
}

-(void)focus {
    if(player.position.y >= center.y) {
        if (player.focused) {
            offset.y = center.y - player.position.y;
        }
        // NSLog(@"center: %f, player.position.y: %f, offset.x: %f", center.y, player.position.y, offset.y); 
    }
}

-(void)render {	
				for(Entity * entity in entities) {
								[entity render];
				}
}

-(void)cleanup {	
				for(Entity * entity in entities) {
								[entity cleanup];
				}
}

-(void)logic {
    // Nothing goes here. This is overwritten in the subclass.
}

-(void)dealloc {
				[entities release];
				[super dealloc];
}

@end

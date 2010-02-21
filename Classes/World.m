//
//  Universe.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "World.h"

@interface World()
-(void)setDefaults;
-(void)checkBounds:(Entity*)entity;
-(void)checkCollisions:(Entity*)entity;
@end

@implementation World

- (id)init {
				self = [super init];
				if (self != nil) {
								[self setDefaults];
				}
				return self;
}

- (id)initWithBounds:(CGRect)rect {
				self = [super init];
				if (self != nil) {
								[self setDefaults];
								bounds = rect;
				}
				return self;
}

-(void)setDefaults{
				gravity = CGPointMake(0, -0.83);
				windResistance = 0;
				entities = [[NSMutableArray alloc] init];
				entitiesToRelease = [[NSMutableArray alloc] init];
}

-(void)registerEntity:(Entity*)entity {
				entity.gravity = gravity;
				entity.world = self;
				[entities addObject:entity];
}

-(void)unregisterEntity:(Entity *)entity {
				[entitiesToRelease addObject:entity];
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
				
				// First release any objects that needed to be relased
				// from the previous iteration.
				for (Entity * entity in entitiesToRelease) {
								[entities removeObject:entity];
								[entity release];
				}
				
				// Remove all the entites that needed to be cleared.
				// We should have all our memory back now...
				[entitiesToRelease removeAllObjects];
				
				// Create a temporary clone of the entities array.
				NSMutableArray * updaters = [[NSMutableArray alloc]initWithArray:entities];
				
				for(Entity * entity in updaters){
								[entity update:delta];
				}
				
				for(Entity * entity in updaters){
								[self checkBounds:entity];
								[self checkCollisions:entity];
				}
				
				[updaters release];
				
}

-(void)checkBounds:(Entity*)entity{

				//				NSLog(@"%f",[entity getRect].size.width);
				CGRect rect = [entity getRect];
				
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
								if (entity != collider && CGRectIntersectsRect([entity getRect], [collider getRect])) {
												[entity collisionWith:collider];
								}
				}
				
				[colliders release];
				
}

-(void)render {	
				for(Entity * entity in entities) {
								[entity render];
				}
}

-(void)dealloc {
				[entities release];
				[super dealloc];
}

@end

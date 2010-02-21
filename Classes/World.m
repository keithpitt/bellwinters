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
}

-(void)registerEntity:(Entity*)entity {
				entity.gravity = gravity;
				[entities addObject:entity];
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
				for(Entity * entity in entities){
								[entity update:delta];
				}
				for(Entity * entity in entities){
								[self checkBounds:entity];
				}
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

-(void)render {	
				for(Entity * entity in entities){
								[entity render];
				}
}

-(void)dealloc {
				[entities release];
				[super dealloc];
}

@end

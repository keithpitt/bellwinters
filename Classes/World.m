//
//  Universe.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "World.h"


@implementation World

- (id)init {
				self = [super init];
				if (self != nil) {
								gravity = 9.81f;
								windResistance = 0;
								entities = [[NSMutableArray alloc] init];
				}
				return self;
}

-(void)registerEntity:(Entity*)entity {
				[entities addObject:entity];
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

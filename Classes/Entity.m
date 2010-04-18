//
//  Entity.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Entity.h"
#import "World.h"

@implementation Entity

@synthesize gravity;
@synthesize position;
@synthesize world;
@synthesize focused;

-(void)render {
				[sprite renderAtPoint:[self getPositionOnScreen] centerOfImage:false];
}

-(void)cleanup {
				// Do nothing.
}

-(void)update:(float)delta {
				// Do nothing.
}

-(void)kill {
    [world unregisterEntity:self];
}

-(void)handleAcceleration:(UIAcceleration *)acceleration {
				// Do nothing.
}

-(void)handleTapAtPoint:(CGPoint)point {
				// Do nothing.
}

-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY {
				// Do nothing.
}

-(void)collisionWith:(Entity *)entitiy {
				// Do nothing.
}

-(void)setPosition:(CGPoint)point {
    position.x = point.x;
    position.y = point.y;
}

-(CGPoint)getPositionOnScreen {
				return [world positionOnScreen:position];
}

-(CGRect)getRectOnScreen {
    CGPoint point = [self getPositionOnScreen];
				return CGRectMake(point.x, point.y, sprite.imageWidth, sprite.imageHeight);
}

@end

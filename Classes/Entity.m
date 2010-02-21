//
//  Entity.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Entity.h"


@implementation Entity

@synthesize gravity;
@synthesize position;

-(void)render {
				[sprite renderAtPoint:position centerOfImage:false];
}

-(void)update:(float)delta {
				// Do nothing.
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

-(CGRect)getRect{
				return CGRectMake(position.x, position.y, sprite.imageWidth, sprite.imageHeight);
}

@end

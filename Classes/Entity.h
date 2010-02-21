//
//  Entity.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@interface Entity : NSObject {
				Image * sprite;
				CGPoint gravity;
				CGPoint position;
}

@property(nonatomic, readonly)CGPoint			position;
@property(nonatomic)CGPoint													gravity;

// Game input
-(void)handleAcceleration:(UIAcceleration *)acceleration;
-(void)handleTapAtPoint:(CGPoint)point;

// Collision methods
-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY;
-(void)collisionWith:(Entity *)entitiy;

// Game logic and rendering
-(void)render;
-(void)update:(float)delta;

// Utility methods.
-(CGRect)getRect;

@end

//
//  Entity.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"

@class World;

@interface Entity : NSObject {
				World * world;
				Image * sprite;
				CGPoint gravity;
				CGPoint position;
    Boolean focused;
}

@property(nonatomic, readonly)CGPoint			position;
@property(nonatomic)CGPoint													gravity;
@property(nonatomic)Boolean													focused;
@property(nonatomic, assign)World							* world;

// Game input
-(void)handleAcceleration:(UIAcceleration *)acceleration;
-(void)handleTapAtPoint:(CGPoint)point;

// Collision methods
-(void)collisionWithWorldX:(float)deltaX Y:(float)deltaY;
-(void)collisionWith:(Entity *)entitiy;

// Game logic and rendering
-(void)render;
-(void)cleanup;
-(void)update:(float)delta;
-(void)kill;

// Position methods.
-(CGPoint)getPositionOnScreen;
-(CGRect)getRectOnScreen;

// Custom setters
-(void)setPosition:(CGPoint)point;

@end

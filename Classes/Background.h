//
//  Background.h
//  Winterbells
//
//  Created by Keith Pitt on 18/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Image.h"

@interface Background : Entity {

    Image * spriteTile;
    
    CGPoint spriteTilePositionA;
    CGPoint spriteTilePositionB;   
    int backgroundHeight;
    float speed;
    
}

@property(nonatomic, readonly)CGPoint			spriteTilePositionA;
@property(nonatomic, readonly)CGPoint			spriteTilePositionB;
@property(nonatomic, readonly)int       backgroundHeight;

@end

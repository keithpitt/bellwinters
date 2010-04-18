//
//  Background.m
//  Winterbells
//
//  Created by Keith Pitt on 18/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Background.h"
#import "World.h"

@implementation Background

@synthesize spriteTilePositionA;
@synthesize spriteTilePositionB;
@synthesize backgroundHeight;

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        spriteTile = [[Image alloc] initWithImage:[UIImage imageNamed:@"BackgroundTile.png"]];
        
        spriteTilePositionA = CGPointMake(0, 480);
        spriteTilePositionB = CGPointMake(0, 960);        
        position.x = 0; position.y = 0;
        
        backgroundHeight = 480;
				}
				return self;
}

-(void)update:(float)delta {
    
    CGPoint point = [world positionOnScreen:position];
    
    int backgroundsFromBottom = ((int)point.y * -1) / 480;
    
    spriteTilePositionA.y = (backgroundsFromBottom == 0 ? backgroundHeight : 0) + (backgroundsFromBottom * backgroundHeight);
    spriteTilePositionB.y = spriteTilePositionA.y + backgroundHeight;

}

-(void)render {

    CGPoint point = [self getPositionOnScreen];
    
    // Only render the bottom most sprite if its in view.
    if (point.y > -500) {
        [sprite renderAtPoint:point centerOfImage:false];
    }
    
    [spriteTile renderAtPoint:[world positionOnScreen:spriteTilePositionA] centerOfImage:false];
    [spriteTile renderAtPoint:[world positionOnScreen:spriteTilePositionB] centerOfImage:false];

}

@end

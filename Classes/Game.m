//
//  Game.m
//  Winterbells
//
//  Created by Keith Pitt on 17/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Game.h"
#import "World.h"
#import "Player.h"
#import "Bell.h"
#import "Background.h"
#import "Texture2D.h"
#import "Image.h"

@implementation Game

@synthesize lastEntity;

- (void)setup {
    
    [self registerEntity:[[Background alloc] init]];
    [self registerPlayer:[[Player alloc] init]];
    
    // Show the starter message.
    message = [[Message alloc] init];
    message.hidden = false;
    [self registerEntity:message];
    
    for (int i = 0, l = 6; i < l; i++) {
        [self generateBell];
    }
    
    highestPoint = 0;
    score = 0;
    
}

- (void)replay {
    lastEntity = NULL;
    score = 0;
    highestPoint = 0;
    [super replay];
}

- (void)logic {
    
    if (self.player.active) {
        
        int currentPoint = (int)self.offset.y * -1;
        
        // Did the get higher?
        if (currentPoint > highestPoint) {
            highestPoint = currentPoint;
        } else {
            
            // Have they fallen far enough to fail?
            int fallen = highestPoint - currentPoint;
            if (fallen > 400) {
                [self.player kill];
                message.hidden = false;
            }
            
        }
        
    }
    
}

- (void)generateBell {
    
    Bell * bell = [[Bell alloc] init];
    CGPoint point;
    
    point.x = rand() % 300;
    
    if (lastEntity != NULL) {
        point.y = lastEntity.position.y + 180;
    } else {
        point.y = 200;
    }
    
    [bell setPosition: point];
    [self registerEntity:bell];
    
    lastEntity = bell;
    
}

-(void)doCollisionWithEntity:(Entity*)entity And:(Entity*)collider {
    if ( [entity isKindOfClass: [Player class]] == YES && [collider isKindOfClass: [Bell class]] == YES) {
        score += 100;
    }
    [entity collisionWith:collider];
}

- (void)render {
    
    [super render];
    
    // Display the score board if we have something to show.
    if (score > 0) {
        NSString * display = [NSString stringWithFormat:@"%i", score];
        
        texture = [[Texture2D alloc] initWithString:display dimensions:CGSizeMake(320.0f, 28.0f) 
                                     alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:15.0f];
        image = [[Image alloc] initWithTexture:texture];
        
        [image renderAtPoint:CGPointMake(10, 0) centerOfImage:false];                
    }
    
}

- (void)cleanup {
    if (image) {
        [image dealloc];
        image = NULL;
    }
    [super cleanup];
}

- (void)handleTapAtPoint:(CGPoint)point {
    if (self.player.hidden && self.player.killed) {
        [self replay];
    } else {
        message.hidden = true;
        [super handleTapAtPoint:point];
    }
}

@end

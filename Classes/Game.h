//
//  Game.h
//  Winterbells
//
//  Created by Keith Pitt on 17/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "Entity.h"
#import "Message.h"

@interface Game : World {
    Entity * lastEntity;
    int highestPoint;
    int score;
    
    Texture2D * texture;
    Image * image;
    Message * message;
}

@property(nonatomic, retain)Entity *     lastEntity;

- (void)generateBell;

@end
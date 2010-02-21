//
//  Bell.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Image.h"

@class Player;

@interface Bell : Entity {
				bool activated;
}

@property(nonatomic)bool activated;

-(void)collisionWith:(Player *)player;

@end

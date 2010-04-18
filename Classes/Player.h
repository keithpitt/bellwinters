//
//  Player.h
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Image.h"

@class Bell;

@interface Player : Entity {
				// Nothing for the moment.
				CGPoint movement;
    Boolean active;
    Boolean killed;
    Boolean hidden;
}

@property(nonatomic)Boolean active;
@property(nonatomic)Boolean hidden;
@property(nonatomic)Boolean killed;

@end

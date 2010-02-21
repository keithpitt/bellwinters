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
				CGPoint position;
}

@property(nonatomic, readonly)CGPoint			position;
@property(nonatomic, readonly)Image	*				sprite;

// Game input
-(void)handleAcceleration:(UIAcceleration *)acceleration;

// Game logic and rendering
-(void)render;
-(void)update:(float)delta;

@end

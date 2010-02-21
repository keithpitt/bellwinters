//
//  Player.m
//  Winterbells
//
//  Created by Ryan Whiteley on 21/02/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init {
				self = [super init];
				if (self != nil) {
        sprite = [[Image alloc] initWithImage:[UIImage imageNamed:@"Bunny.png"]];
								position.x = 10;
								position.y = 10;
				}
				return self;
}

-(void)update:(float)delta {
				// NSLog(@"%f", delta);
}

-(void)handleAcceleration:(UIAcceleration *)acceleration {
				NSLog(@"%f", acceleration.x);	
}

@end

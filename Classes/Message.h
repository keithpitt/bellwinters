//
//  Message.h
//  Winterbells
//
//  Created by Keith Pitt on 18/04/10.
//  Copyright 2010 asdfasdf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Image.h"

@interface Message : Entity {
    bool hidden;
}

@property(nonatomic, readwrite)bool hidden;

@end

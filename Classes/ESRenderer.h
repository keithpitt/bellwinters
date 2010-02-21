//
//  ES1Renderer.h
//  Winterbells
//
//  Created by Keith Pitt on 20/02/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "ESRenderer.h"
#import "Texture2D.h"

#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "World.h"
#import "Player.h"
#import "Bell.h"

#import "AccelerometerSimulation.h"

@interface ESRenderer : NSObject <UIApplicationDelegate, UIAccelerometerDelegate>
{
@private
    EAGLContext *context;
    
    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;
				CFTimeInterval lastTime;
    
    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint defaultFramebuffer, colorRenderbuffer;
				
				UIAccelerometer * accelerometer;
    
				World * world;
    
}

// Game input
- (void)handleTapAtPoint:(CGPoint)point;

// Game logic
- (void)mainGameLoop;

// Graphics handling
- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer;

@end
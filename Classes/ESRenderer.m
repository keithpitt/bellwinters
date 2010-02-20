//
//  ES1Renderer.m
//  Winterbells
//
//  Created by Keith Pitt on 20/02/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "ESRenderer.h"

@interface ESRenderer()

-(void)updateScene:(float)delta;
-(void)renderScene;

@end

@implementation ESRenderer

// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }
        
        // Gett the bounds of the main screen
        CGRect rect = [[UIScreen mainScreen] applicationFrame];
        
        // Set up OpenGL projection matrix
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrthof(0, rect.size.width, 0, rect.size.height, -1, 1);
        glMatrixMode(GL_MODELVIEW);
        
        // Init OpenGL States
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_DEPTH_TEST);
        glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        
        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
        
        // Init the Trollface image
        bunnyRabbit = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"Bunny.png"]];
        
        lastTime = CFAbsoluteTimeGetCurrent();
        
    }
    
    return self;
}

- (void)mainGameLoop
{
    CFTimeInterval	time;
    float			delta;
    time = CFAbsoluteTimeGetCurrent();
    delta = (time - lastTime) / (1.0f/60.0f);
    
    [self updateScene:delta];	
    [self renderScene];	
    
    lastTime = time;
}

- (void)updateScene:(float)delta
{
    // Update game logic.
}

- (void)renderScene
{
    
    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];
    
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    [bunnyRabbit drawAtPoint:CGPointMake(120, 270)];
    
    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }
    
    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }
    
    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [bunnyRabbit release];
    
    [context release];
    context = nil;
    
    [super dealloc];
}

@end

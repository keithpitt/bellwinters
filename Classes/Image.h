//
//  Image.h
//  OGLGame
//
//  Created by Michael Daley on 15/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/* 
 This Image class is used to wrap the Texture2D class.  It provides our own methods to render the texture to the
 screen as well as being able to rotate and scale the image.  Below is an explanation of how we use texture 
 coordinates to only render the part of the texture returned by Texture2D we are interested in.
 
 When Texture2D takes an image and turns it into a texture, it makes sure that the texture is ^2.  Using the player.png
 image from our current example, it means that the texture created is 64x128px.  Within this texture out player.png 
 image is 48x71px.  This is shown in the diagram below:
 
			 imageWidth
			 48px
			 |------|
 
		-    +------+---+   -
 image  !    |iiiiii|   |   !
 Height !    |iiiiii|   |   !
 71px   !    |iiiiii|   |   ! textureHeight
		-    +------+   |   ! 128px
			 |          |   ! 
             |          |   !
             +----------+   -
 
			 |----------|
			 textureWidth
			 64px	
 
 Texture coordinates in OpenGL are defined from 0.0 to 1.0 so within the texture above an x texture coordinate of 
 1.0f would be 64px and a y texture coordinate of 1.0f would be 128px.  We can use this information to calculate
 the texture coordinates we need to use to make sure that just our image 48x71 is used when rendering the texture
 into our quad.  The calculation we use is:
 
 maxTexWidth = width / textureWidth;
 maxTexHeight = height / textureHeight;
 
 For our example image the result would be
 
 maxTexWidth = 48 / 64 = 0.750000
 maxTexHeight = 71 / 128 = 0.554688
 
 We then use these values within the methods that draw the image so that only the image within the texture is
 used and nont of the blank texture is used.  We can use this same approach to select images from a sprite 
 sheet or texture atlas.
 */	


#import <Foundation/Foundation.h>
#import "Texture2D.h"

@interface Image : NSObject {
	// The OpenGL texture to be used for this image
	Texture2D		*texture;	
	// The width of the image
	NSUInteger		imageWidth;
	// The height of the image
	NSUInteger		imageHeight;
	// The texture coordinate width to use to find the image
	NSUInteger		textureWidth;
	// The texture coordinate height to use to find the image
	NSUInteger		textureHeight;
	// The maximum texture coordinate width maximum 1.0f
	float			maxTexWidth;
	// The maximum texture coordinate height maximum 1.0f
	float			maxTexHeight;
	// The texture width to pixel ratio
	float			texWidthRatio;
	// The texture height to pixel ratio
	float			texHeightRatio;
	// The X offset to use when looking for our image
	NSUInteger		textureOffsetX;
	// The Y offset to use when looking for our image
	NSUInteger		textureOffsetY;
	// Angle to which the image should be rotated
	float			rotation;
	// Scale at which to draw the image
	float			scale;
	// Colour Filter = Red, Green, Blue, Alpha
	float			colourFilter[4];
}

@property(nonatomic)NSUInteger					imageWidth;
@property(nonatomic)NSUInteger					imageHeight;
@property(nonatomic, readonly)NSUInteger		textureWidth;
@property(nonatomic, readonly)NSUInteger		textureHeight;
@property(nonatomic, readonly)float				texWidthRatio;
@property(nonatomic, readonly)float				texHeightRatio;
@property(nonatomic)NSUInteger					textureOffsetX;
@property(nonatomic)NSUInteger					textureOffsetY;
@property(nonatomic)float						rotation;
@property(nonatomic)float						scale;

// Initializers
- (id)initWithTexture:(Texture2D *)tex;
- (id)initWithTexture:(Texture2D *)tex scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image;
- (id)initWithImage:(UIImage *)image filter:(GLenum)filter;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale;
- (id)initWithImage:(UIImage *)image scale:(float)imageScale filter:(GLenum)filter;

// Action methods
- (Image*)getSubImageAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight scale:(float)subImageScale;
- (void)renderAtPoint:(CGPoint)point centerOfImage:(BOOL)center;
- (void)renderSubImageAtPoint:(CGPoint)point offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth subImageHeight:(GLfloat)imageHeigt centerOfImage:(BOOL)center;

// Setters
- (void)setColourFilterRed:(float)red green:(float)green blue:(float)blue alpha:(float)a;
- (void)setAlpha:(float)alpha;

@end

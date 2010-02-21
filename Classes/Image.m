//
//  Image.m
//  OGLGame
//
//  Created by Michael Daley on 15/03/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Image.h"

// Private methods
@interface Image ()
- (void)initImpl;
- (void)renderAt:(CGPoint)point texCoords:(GLfloat[])coordinates quadVertices:(GLfloat[])vertices;
@end

@implementation Image

@synthesize	imageWidth;
@synthesize imageHeight;
@synthesize textureWidth;
@synthesize textureHeight;
@synthesize texWidthRatio;
@synthesize texHeightRatio;
@synthesize textureOffsetX;
@synthesize textureOffsetY;
@synthesize rotation;
@synthesize scale;

// Added 07/02/10 as this method was missing causing memory leaks
- (void)dealloc {
	
	if(texture)
		[texture release];
	[super dealloc];
}

- (id)init {
	self = [super init];
	if (self != nil) {
		imageWidth = 0;
		imageHeight = 0;
		textureWidth = 0;
		textureHeight = 0;
		texWidthRatio = 0.0f;
		texHeightRatio = 0.0f;
		maxTexWidth = 0.0f;
		maxTexHeight = 0.0f;
		textureOffsetX = 0;
		textureOffsetY = 0;
		rotation = 0.0f;
		scale = 1.0f;
		colourFilter[0] = 1.0f;
		colourFilter[1] = 1.0f;
		colourFilter[2] = 1.0f;
		colourFilter[3] = 1.0f;
	}
	return self;
}


- (id)initWithTexture:(Texture2D *)tex {
	self = [super init];
	if (self != nil) {
		texture = tex;
		scale = 1.0f;
		[self initImpl];
	}
	return self;
}


- (id)initWithTexture:(Texture2D *)tex scale:(float)imageScale {
	self = [super init];
	if (self != nil) {
		texture = tex;
		scale = imageScale;
		[self initImpl];
	}
	return self;
}


- (id)initWithImage:(UIImage *)image {
	self = [super init];
	if (self != nil) {
		// By default set the scale to 1.0f and the filtering to GL_NEAREST
		texture = [[Texture2D alloc] initWithImage:image filter:GL_NEAREST];
		scale = 1.0f;
		[self initImpl];
	}
	return self;
}


- (id)initWithImage:(UIImage *)image filter:(GLenum)filter {
	self = [super init];
	if (self != nil) {
		// By default set the scale to 1.0f
		texture = [[Texture2D alloc] initWithImage:image filter:filter];
		scale = 1.0f;
		[self initImpl];
	}
	return self;
}


- (id)initWithImage:(UIImage *)image scale:(float)imageScale {
	self = [super init];
	if (self != nil) {
		// By default set the filtering to GL_NEAREST
		texture = [[Texture2D alloc] initWithImage:image filter:GL_NEAREST];
		scale = imageScale;
		[self initImpl];
	}
	return self;
}


- (id)initWithImage:(UIImage *)image scale:(float)imageScale filter:(GLenum)filter {
	self = [super init];
	if (self != nil) {
		texture = [[Texture2D alloc] initWithImage:image filter:filter];
		scale = imageScale;
		[self initImpl];
	}
	return self;
}


- (void)initImpl {
	imageWidth = texture.contentSize.width;
	imageHeight = texture.contentSize.height;
	textureWidth = texture.pixelsWide;
	textureHeight = texture.pixelsHigh;
	maxTexWidth = imageWidth / (float)textureWidth;
	maxTexHeight = imageHeight / (float)textureHeight;
	texWidthRatio = 1.0f / (float)textureWidth;
	texHeightRatio = 1.0f / (float)textureHeight;
	textureOffsetX = 0;
	textureOffsetY = 0;
	rotation = 0.0f;
	colourFilter[0] = 1.0f;
	colourFilter[1] = 1.0f;
	colourFilter[2] = 1.0f;
	colourFilter[3] = 1.0f;
}


- (NSString *)description {
	return [NSString stringWithFormat:@"texture:%d width:%d height:%d texWidth:%d texHeight:%d maxTexWidth:%f maxTexHeight:%f angle:%f scale:%f", [texture name], imageWidth, imageHeight, textureWidth, textureHeight, maxTexWidth, maxTexHeight, rotation, scale];
}


- (Image*)getSubImageAtPoint:(CGPoint)point subImageWidth:(GLuint)subImageWidth subImageHeight:(GLuint)subImageHeight scale:(float)subImageScale {
	
	//Create a new Image instance using the texture which has been assigned to the current instance
	Image *subImage = [[Image alloc] initWithTexture:texture scale:subImageScale];
	
	// Define the offset of the subimage we want using the point provided
	[subImage setTextureOffsetX:point.x];
	[subImage setTextureOffsetY:point.y];
	
	// Set the width and the height of the subimage
	[subImage setImageWidth:subImageWidth];
	[subImage setImageHeight:subImageHeight];
	
	// Set the rotatoin of the subImage to match the current images rotation
	[subImage setRotation:rotation];
	
	return subImage;
}


- (void)renderAtPoint:(CGPoint)point centerOfImage:(BOOL)center {
	// Use the textureOffset defined for X and Y along with the texture width and height to render the texture
	CGPoint texOffsetPoint = CGPointMake(textureOffsetX, textureOffsetY);
	[self renderSubImageAtPoint:point offset:texOffsetPoint subImageWidth:imageWidth subImageHeight:imageHeight centerOfImage:center];
}


- (void)renderSubImageAtPoint:(CGPoint)point offset:(CGPoint)offsetPoint subImageWidth:(GLfloat)subImageWidth subImageHeight:(GLfloat)subImageHeight centerOfImage:(BOOL)center {
	
	// Calculate the texture coordinates using the offset point from which to start the image and then using the width and height
	// passed in
	GLfloat	textureCoordinates[] = {
		texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x),	texHeightRatio * offsetPoint.y,
		texWidthRatio * subImageWidth + (texWidthRatio * offsetPoint.x),	texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y),
		texWidthRatio * offsetPoint.x,										texHeightRatio * offsetPoint.y,
		texWidthRatio * offsetPoint.x,										texHeightRatio * subImageHeight + (texHeightRatio * offsetPoint.y)
	};
	
	// Calculate the width and the height of the quad using the current image scale and the width and height
	// of the image we are going to render
	GLfloat quadWidth = subImageWidth * scale;
	GLfloat quadHeight = subImageHeight * scale;
	
	// Define the vertices for each corner of the quad which is going to contain our image.
	// We calculate the size of the quad to match the size of the subimage which has been defined.
	// If center is true, then make sure the point provided is in the center of the image else it will be
	// the bottom left hand corner of the image
	GLfloat quadVertices[8];
	if(center) {
		quadVertices[0] = quadWidth / 2;
		quadVertices[1] = quadHeight / 2;
		
		quadVertices[2] = quadWidth / 2;
		quadVertices[3] = -quadHeight / 2;
		
		quadVertices[4] = -quadWidth / 2;
		quadVertices[5] = quadHeight / 2;
		
		quadVertices[6] = -quadWidth / 2;
		quadVertices[7] = -quadHeight / 2;
	} else {
		quadVertices[0] = quadWidth;
		quadVertices[1] = quadHeight;
		
		quadVertices[2] = quadWidth;
		quadVertices[3] = 0;
		
		quadVertices[4] = 0;
		quadVertices[5] = quadHeight;
		
		quadVertices[6] = 0;
		quadVertices[7] = 0;
	}		
	
	// Now that we have defined the texture coordinates and the quad vertices we can render to the screen 
	// using them
	[self renderAt:point texCoords:textureCoordinates quadVertices:quadVertices];
}


- (void)renderAt:(CGPoint)point texCoords:(GLfloat[])texCoords quadVertices:(GLfloat[])quadVertices {
	// Save the current matrix to the stack
	glPushMatrix();
	
	// Move to where we want to draw the image
	glTranslatef(point.x, point.y, 0.0f);
	
	// Rotate around the Z axis by the angle define for this image
	glRotatef(-rotation, 0.0f, 0.0f, 1.0f);
	
	// Set the glColor to apply alpha to the image
	glColor4f(colourFilter[0], colourFilter[1], colourFilter[2], colourFilter[3]);
	
	// Set client states so that the Texture Coordinate Array will be used during rendering
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// Enable Texture_2D
	glEnable(GL_TEXTURE_2D);
	
	// Bind to the texture that is associated with this image
	glBindTexture(GL_TEXTURE_2D, [texture name]);
	
	// Set up the VertexPointer to point to the vertices we have defined
	glVertexPointer(2, GL_FLOAT, 0, quadVertices);
	
	// Set up the TexCoordPointer to point to the texture coordinates we want to use
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	// Enable blending as we want the transparent parts of the image to be transparent
	glEnable(GL_BLEND);
	
	// Draw the vertices to the screen
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// Now we are done drawing disable blending
	glDisable(GL_BLEND);
	
	// Disable as necessary
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	// Restore the saved matrix from the stack
	glPopMatrix();
}


- (void)setColourFilterRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
	colourFilter[0] = red;
	colourFilter[1] = green;
	colourFilter[2] = blue;
	colourFilter[3] = alpha;
}


- (void)setAlpha:(float)alpha {
	colourFilter[3] = alpha;
}

@end

//
//  WinterbellsAppDelegate.m
//  Winterbells
//
//  Created by Keith Pitt on 20/02/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "WinterbellsAppDelegate.h"
#import "EAGLView.h"

@implementation WinterbellsAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];

    [super dealloc];
}

@end

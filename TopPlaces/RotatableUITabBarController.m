//
//  RotatableUITabBarController.m
//  TopPlaces
//
//  Created by Timothée Boucher on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotatableUITabBarController.h"

@implementation RotatableUITabBarController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)wantsFullScreenLayout {
    return YES;
}

@end

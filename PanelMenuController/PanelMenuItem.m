//
//  PanelMenuItem.m
//  photomovie
//
//  Created by Evgeny Rusanov on 18.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "PanelMenuItem.h"

#import "PanelMenuViewController.h"

@implementation PanelMenuItem

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount && self.menuController)
    {
        [self.menuController performSelector:@selector(menuItemSelected:) withObject:self];
    }
}

@end

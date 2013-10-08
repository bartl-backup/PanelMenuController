//
//  PanelMenuItem.h
//  photomovie
//
//  Created by Evgeny Rusanov on 18.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PanelMenuViewController;

@interface PanelMenuItem : UIView

@property (nonatomic) int index;
@property (nonatomic,weak) PanelMenuViewController *menuController;

@end

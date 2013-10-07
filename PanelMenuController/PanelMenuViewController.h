//
//  PanelMenuViewController.h
//  photomovie
//
//  Created by Evgeny Rusanov on 18.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PanelMenuItem.h"

enum ePanelMenuViewControllerStyle
{
    PanelMenuViewControllerStyleBottom,
    PanelMenuViewControllerStyleTop,
    PanelMenuViewControllerStyleLeft,
    PanelMenuViewControllerStyleRight,
};


typedef enum ePanelMenuViewControllerStyle PanelMenuViewControllerStyle;

@class PanelMenuViewController;

@protocol PanelMenuControllerDataSource <NSObject>
-(int)menuItemsNumberInPanelMenuController:(PanelMenuViewController*)panelMenuController;
-(PanelMenuItem*)panelMenuController:(PanelMenuViewController*)panelMenuController menuItemAt:(int)index;
@end

@protocol PanelMenuControllerDelegate <NSObject>
-(void)panelMenuController:(PanelMenuViewController*)panelMenuController itemSelected:(PanelMenuItem*)item;
@end

@interface PanelMenuViewController : UIViewController

@property (nonatomic) int selectedMenuItem;
@property (nonatomic) PanelMenuViewControllerStyle style;
@property (nonatomic,strong) UIViewController *contentViewController;

-(void)setMenuVisible:(BOOL)visible animated:(BOOL)animated;
-(void)setMenuVisible:(BOOL)visible animated:(BOOL)animated completition:(void (^) (void))block;

@property (nonatomic) float panelSize;
@property (nonatomic) float itemsInterval;
@property (nonatomic) CGSize itemSize;

@property (nonatomic,weak) id<PanelMenuControllerDataSource> dataSource;
@property (nonatomic,weak) id<PanelMenuControllerDelegate> delegate;

@end

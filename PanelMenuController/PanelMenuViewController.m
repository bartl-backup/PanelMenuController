//
//  PanelMenuViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 18.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "PanelMenuViewController.h"

@interface PanelMenuViewController ()

@end

@implementation PanelMenuViewController
{
    UIScrollView *_menuScrollView;
    
    NSMutableArray *itemsArray;
    
    BOOL _menuVisible;
}

-(void)initialize
{
    _selectedMenuItem = 0;
    _panelSize = 100;
    _itemsInterval = 4.0;
    _itemSize = CGSizeMake(88.0, 88.0);
    _style = PanelMenuViewControllerStyleBottom;
    _menuVisible = YES;
    
    itemsArray = [NSMutableArray array];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

-(id)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    return self;
}

-(CGRect)menuBarRect
{
    float visibilityOffset = _menuVisible?0:self.panelSize;
    
    switch (self.style)
    {
        case PanelMenuViewControllerStyleBottom:
            return CGRectMake(0,
                              self.view.bounds.size.height-self.panelSize + visibilityOffset,
                              self.view.bounds.size.width,
                              self.panelSize);
        case PanelMenuViewControllerStyleTop:
            return CGRectMake(0,
                              -visibilityOffset,
                              self.view.bounds.size.width,
                              self.panelSize);
        case PanelMenuViewControllerStyleLeft:
            return CGRectMake(-visibilityOffset,
                              0,
                              self.panelSize,
                              self.view.bounds.size.height);
        case PanelMenuViewControllerStyleRight:
            return CGRectMake(self.view.bounds.size.width-self.panelSize+visibilityOffset,
                              0,
                              self.panelSize,
                              self.view.bounds.size.height);
    }
    
    return CGRectZero;
}

-(UIViewAutoresizing)menuBarAutoResizing
{
    switch (self.style)
    {
        case PanelMenuViewControllerStyleBottom:
            return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        case PanelMenuViewControllerStyleTop:
            return UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        case PanelMenuViewControllerStyleLeft:
            return UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        case PanelMenuViewControllerStyleRight:
            return UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    }
    
    return UIViewAutoresizingNone;
}

-(void)addMenuBar
{    
    _menuScrollView = [[UIScrollView alloc] initWithFrame:[self menuBarRect]];
    _menuScrollView.autoresizingMask = [self menuBarAutoResizing];
    _menuScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.panelSize);
    _menuScrollView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self.view addSubview:_menuScrollView];
}

-(void)rearangeItems
{
    float start = self.itemsInterval + self.itemSize.width*0.5;
    float offset = self.itemsInterval + self.itemSize.width;
    
    for (PanelMenuItem *menuItem in itemsArray)
    {
        CGPoint center;
        
        if (self.style<PanelMenuViewControllerStyleLeft)
            center = CGPointMake(start + menuItem.index*offset, self.panelSize*0.5);
        else
            center = CGPointMake(self.panelSize*0.5, start + menuItem.index*offset);
        
        menuItem.center = center;
    }
    
    int itemsCount = [self.dataSource menuItemsNumberInPanelMenuController:self];
    CGSize contentSize = CGSizeMake((self.itemsInterval+self.itemSize.width)*itemsCount+self.itemsInterval,
                                    self.panelSize);
    if (self.style>=PanelMenuViewControllerStyleLeft)
        contentSize = CGSizeMake(contentSize.height, contentSize.width);
    _menuScrollView.contentSize = contentSize;
}

-(void)updateMenuContents
{
    if (!self.dataSource) return;
    while (_menuScrollView.subviews.count)
    {
        [_menuScrollView.subviews.lastObject removeFromSuperview];
    }
    [itemsArray removeAllObjects];
    
    int itemsCount = [self.dataSource menuItemsNumberInPanelMenuController:self];
    
    CGRect menuItemFrame = CGRectMake(0,
                                      0,
                                      self.itemSize.width,
                                      self.itemSize.height);
    for (int i=0; i<itemsCount; i++)
    {
        PanelMenuItem *menuItem = [self.dataSource panelMenuController:self menuItemAt:i];
        menuItem.index = i;
        menuItem.menuController = self;
        
        [_menuScrollView addSubview:menuItem];
        [itemsArray addObject:menuItem];
        
        menuItem.frame = menuItemFrame;
    }
    
    [self rearangeItems];
}

-(void)updateContentViewController
{
    if (!self.contentViewController || !_menuScrollView) return;
    
    CGRect finalRect = self.view.bounds;
    CGRect menuRect  = [self menuBarRect];
    CGRect intersection = CGRectIntersection(finalRect, menuRect);
    
    if (intersection.size.width>0 && intersection.size.height>0)
    {
        if (menuRect.size.width<finalRect.size.width)
        {
            finalRect.size.width-=menuRect.size.width;
            if (menuRect.origin.x==0)
                finalRect.origin.x = menuRect.size.width;
        }
        else
        {
            finalRect.size.height-=menuRect.size.height;
            if (menuRect.origin.y==0)
                finalRect.origin.y = menuRect.size.height;
        }
    }
    
    self.contentViewController.view.frame = finalRect;
}

-(void)loadController
{
    [self addMenuBar];
    [self updateMenuContents];
    
    if (self.contentViewController)
        [self.view addSubview:self.contentViewController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self loadController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateContentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menuItemSelected:(PanelMenuItem*)item
{
    [self.delegate panelMenuController:self itemSelected:item];
}

#pragma mark - Rotations

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.contentViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self updateContentViewController];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contentViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.contentViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - Properties

-(void)setContentViewController:(UIViewController *)contentViewController
{
    if (self.contentViewController)
    {
        [self.contentViewController.view removeFromSuperview];
    }
    
    _contentViewController = contentViewController;
    
    [self updateContentViewController];
}

-(void)setSelectedMenuItem:(int)selectedMenuItem
{
    _selectedMenuItem = selectedMenuItem;
}

-(void)setStyle:(PanelMenuViewControllerStyle)style
{
    _style = style;
    
    if (_menuScrollView)
    {
        _menuScrollView.frame = [self menuBarRect];
        _menuScrollView.autoresizingMask = [self menuBarAutoResizing];
        [self rearangeItems];
        [self updateContentViewController];
    }
}

-(void)setMenuVisible:(BOOL)visible animated:(BOOL)animated completition:(void (^) (void))block
{
    if (_menuVisible == visible) return;
    
    _menuVisible = visible;
    _menuScrollView.scrollEnabled = _menuVisible;
    
    if (_menuVisible)
        _menuScrollView.alpha = 1.0;
    
    float duration = animated?0.3:0.0;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         _menuScrollView.frame = [self menuBarRect];
                         [self updateContentViewController];
                     } completion:^(BOOL finished) {
                             if (!_menuVisible)
                                 _menuScrollView.alpha = 0.0;
                             
                             if (block)
                                 block();
                     }];
}

-(void)setMenuVisible:(BOOL)visible animated:(BOOL)animated
{
    [self setMenuVisible:visible animated:animated completition:nil];
}

@end

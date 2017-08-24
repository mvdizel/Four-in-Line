//
//  DropBehavior.m
//  Four in Line
//
//  Created by Василий Муравьев on 26.09.15.
//  Copyright © 2015 Vasilii Muravev. All rights reserved.
//

#import "DropBehavior.h"

@interface DropBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
@end

@implementation DropBehavior

-(UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 9;
    }
    return _gravity;
}

-(UICollisionBehavior *)collision
{
    if (!_collision) {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collision;
}

-(UIDynamicItemBehavior *)itemBehavior
{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
        _itemBehavior.allowsRotation = NO;
    }
    return _itemBehavior;
}

-(void)addItem:(id <UIDynamicItem>) item
{
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.itemBehavior addItem:item];
}

-(void)removeItem:(id <UIDynamicItem>) item
{
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.itemBehavior removeItem:item];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collision];
        [self addChildBehavior:self.itemBehavior];
    }
    return self;
}
@end

//
//  GameBoardView.m
//  FourInLine
//
//  Created by Василий Муравьев on 06.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//
/*
#import "GameBoardView1.h"
#import "GameView.h"
#import "BlockView.h"
#import "DropBehavior.h"

@interface GameBoardView1 () <UIDynamicAnimatorDelegate>
@property (nonatomic, readonly) CGFloat numOfColumns;
@property (nonatomic, readonly) CGFloat numOfLines;
@property (strong, nonatomic) BlockView *tempBlock;
@property (weak, nonatomic, readonly) UIView *gameOverView;
@property (strong, nonatomic, readonly) NSArray *blockStack;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropBehavior *dropBehavior;
@property (strong, nonatomic) UIView *dropView;
@end

@implementation GameBoardView1

#pragma mark - Initialization

- (void)drawRect:(CGRect)rect
{
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = .1;
//    
//    for (CGFloat x = 0; x <= self.numOfColumns; x++)
//    {
//        [path moveToPoint:CGPointMake(x * self.cellSize, 0)];
//        [path addLineToPoint:CGPointMake(x * self.cellSize, self.cellSize * (self.numOfLines + 1))];
//    }
//    
//    for (CGFloat y = 0; y <= (self.numOfLines + 1); y++)
//    {
//        [path moveToPoint:CGPointMake(0, y * self.cellSize)];
//        [path addLineToPoint:CGPointMake(self.cellSize * self.numOfColumns, y * self.cellSize)];
//    }
//
//    [path closePath];
//    [[UIColor blackColor] setStroke];
//    [path stroke];
    
//    // удалить
//    CGRect textFrame = CGRectMake(0, self.cellSize * self.numOfLines, self.cellSize * self.numOfColumns, self.bounds.size.height - self.cellSize * self.numOfLines);
//    self.moves.frame = textFrame;
//    [self.moves setHidden:YES];
    
    // Creating gameboard
    for (id subview in self.subviews) {
        if ([subview isKindOfClass:[BlockView class]]) {
            BlockView *block = (BlockView *)subview;
            block.frame = [self blockFrameForLocation:block.location];
            [block setNeedsDisplay];
        }
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    self.gameOverView.frame = CGRectMake(rect.size.width / 8,
                                         rect.size.height / 4,
                                         rect.size.width * 6 / 8,
                                         rect.size.height / 2);
    
    for (CGFloat x = 0; x < self.numOfColumns; x++)
    {
        for (CGFloat y = 0; y < self.numOfLines; y++)
        {
            CGRect cellRect = CGRectMake(x * self.cellSize,
                                         y * self.cellSize,
                                         self.cellSize,
                                         self.cellSize);
            UIImageView *cell = [[UIImageView alloc] initWithFrame:cellRect];
            cell.image = [UIImage imageNamed:@"CellTest"];
            //[self addSubview:cell];
            [self insertSubview:cell atIndex:0];
        }
    }
}

#pragma mark - Properties

-(UIView *)gameOverView { return ((GameView *)self.superview).gameOverView; }
-(CGFloat)cellSize { return ((GameView *)self.superview).cellSize; }
-(CGFloat)borderSize { return ((GameView *)self.superview).borderSize; }
-(CGFloat)numOfColumns { return ((GameView *)self.superview).numOfColumns; }
-(CGFloat)numOfLines { return ((GameView *)self.superview).numOfLines; }
-(NSArray *)blockStack { return ((GameView *)self.superview).blockStack; }

-(void)setTempLocation:(CGPoint)newLocation
{
    _tempLocation = newLocation;
    [self drawTemporaryBlock];
}

-(BlockView *)tempBlock
{
    if (!_tempBlock) {
        _tempBlock = [[BlockView alloc] init];
        _tempBlock.temp = YES;
        _tempBlock.player = Human;
        _tempBlock.location = CGPointZero;
        _tempBlock.backgroundColor = [UIColor clearColor];
    }
    return _tempBlock;
}

-(UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.dropView];
        _animator.delegate = self;
    }
    return _animator;
}

-(UIView *)dropView
{
    if (!_dropView) {
        _dropView = [[UIView alloc] init];
        _dropView.backgroundColor = [UIColor clearColor];
        [self addSubview:_dropView];
    }
    return _dropView;
}

-(DropBehavior *)dropBehavior
{
    if (!_dropBehavior) {
        _dropBehavior = [[DropBehavior alloc] init];
        [self.animator addBehavior:_dropBehavior];
    }
    return _dropBehavior;
}

#pragma mark - Intarface metods

-(void)drawBlockAtPoint:(CGPoint)location forPlayer:(int)player
{
    CGRect startFrame = [self blockFrameForLocation:location];
    startFrame.origin.y = 0;
    
    BlockView *newBlock = [[BlockView alloc] initWithFrame:startFrame];
    newBlock.location = location;
    newBlock.player = player;
    newBlock.backgroundColor = [UIColor clearColor];
    
    self.dropView.frame = CGRectMake(0, 0, self.bounds.size.width, startFrame.size.width * (self.numOfLines - location.y + 1));
    [self.dropView addSubview:newBlock];
    [self sendSubviewToBack:self.dropView];
    
    [self.dropBehavior addItem:newBlock];
    [NSTimer scheduledTimerWithTimeInterval:DROP_ANIM_DURATION
                                     target:self
                                   selector:@selector(blockDropped:)
                                   userInfo:newBlock repeats:NO];
    
    self.moves.text = [self.moves.text stringByAppendingFormat:@" %@%d", player == Human ? @"h" : @"c", (int)location.x];
}

-(void)blockDropped:(NSTimer *)timer
{
    BlockView *newBlock = timer.userInfo;
    
    [self.dropBehavior removeItem:newBlock];
    [newBlock removeFromSuperview];
    
    self.tempLocation = CGPointZero;
    newBlock.frame = [self blockFrameForLocation:newBlock.location];
    [self addSubview:newBlock];
    
//    [self startFlashingbuttonForView:newBlock];

    [self.delegate blockDidFinishMotion];
}

-(int)blockColumnForLocation:(CGPoint)location
{
    return [self pointInside:location withEvent:nil] ? location.x / self.cellSize + 1 : 0;
}

#pragma mark - Pryvate metods

-(void)drawTemporaryBlock
{
    CGFloat x = self.tempLocation.x;
    BOOL remove = YES;
    
    if (!CGPointEqualToPoint(self.tempLocation, CGPointZero) && [self pointInside:self.tempLocation withEvent:nil])
    {
        int xPosition = MAX(1, MIN(self.numOfColumns, x / self.cellSize + 1));
        int yPosition = self.blockStack == nil ? 1 : 1 + [[self.blockStack objectAtIndex:xPosition - 1] intValue];
        
        if (yPosition <= self.numOfLines)
        {
            self.tempBlock.frame = [self blockFrameForLocation:CGPointMake(xPosition, yPosition)];
            [self addSubview:self.tempBlock];
            remove = NO;
        }
    }
    
    if (remove) {
        [self.tempBlock removeFromSuperview];
        self.tempBlock = nil;
    }
}

-(CGRect)blockFrameForLocation:(CGPoint)location
{
    CGFloat x = (location.x - 1) * self.cellSize;
    CGFloat y = (self.numOfLines - location.y) * self.cellSize;
    
    return CGRectMake(x, y, self.cellSize, self.cellSize);
}

-(void)blinkWinnerMoves:(NSArray *)winnerMoves;
{
    NSMutableArray *winnerBlocks = [NSMutableArray array];
    for (NSValue *obj in winnerMoves)
    {
        CGPoint move = [obj CGPointValue];
        for (id subview in self.subviews)
        {
            if ([subview isKindOfClass:[BlockView class]])
            {
                BlockView *block = (BlockView *)subview;
                if (CGPointEqualToPoint(move, block.location))
                {
                    [winnerBlocks addObject:block];
                }
            }
        }
    }
    [self startFlashingbuttonForViews:winnerBlocks];
}

-(void)startFlashingbuttonForViews:(NSArray *)views
{
    CGFloat i = 0.0f;
    for (UIView *view in views) {
        CGRect frame = view.frame;
        frame.origin.x -= 1;
        frame.origin.y -= 1;
        view.frame = frame;
//        view.transform = CGAffineTransformMakeRotation(-M_PI * 0.2);
        [UIView animateWithDuration:0.3
                              delay:(0.1 * i++)
                            options:UIViewAnimationOptionCurveEaseInOut |
         UIViewAnimationOptionRepeat |
         UIViewAnimationOptionAutoreverse |
         UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             view.alpha = 0.5f;
                             CGRect frame = view.frame;
                             frame.origin.x += 2;
                             frame.origin.y += 2;
                             view.frame = frame;
//                             view.transform = CGAffineTransformMakeRotation(M_PI * 0.2);
                         }
                         completion:^(BOOL finished){
                             view.alpha = 1.f;
                             CGRect frame = view.frame;
                             frame.origin.x -= 1;
                             frame.origin.y -= 1;
                             view.frame = frame;
                         }];
    }
}
@end
*/

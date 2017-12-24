//
//  GameBoard.m
//  FourInLine
//
//  Created by Василий Муравьев on 05.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//
/*
#import "GameView.h"
#import "GameBoardView.h"
#import "BlockView.h"

@interface GameView ()

@property (nonatomic, readwrite) CGFloat cellSize;
@property (nonatomic, readwrite) CGFloat borderSize;

@property (nonatomic, strong) UIImageView *upperBorder;
@property (nonatomic, strong) UIImageView *downBorder;
@property (nonatomic, strong) UIImageView *leftBorder;
@property (nonatomic, strong) UIImageView *rightBorder;

@property (nonatomic, strong) UIImageView *ulConer;
@property (nonatomic, strong) UIImageView *urConer;
@property (nonatomic, strong) UIImageView *dlConer;
@property (nonatomic, strong) UIImageView *drConer;

@end

@implementation GameView

#pragma mark - Initialization

- (void)drawRect:(CGRect)rect
{
    CGFloat upMainBorder = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGFloat borderMain = MIN(rect.size.height, rect.size.width) / 20;
    CGFloat iconsSize = (MIN(rect.size.height, rect.size.width) - borderMain * 2) / 5;
   
    self.player1Icon.frame = CGRectMake(borderMain, upMainBorder + borderMain, iconsSize, iconsSize);
    self.player1Icon.backgroundColor = [UIColor blueColor];
    
    self.player2Icon.frame = CGRectMake(rect.size.width - borderMain - iconsSize, upMainBorder + borderMain, iconsSize, iconsSize);
    self.player2Icon.backgroundColor = [UIColor greenColor];
    
    self.settingsButton.frame = CGRectMake(rect.size.width - borderMain - iconsSize, upMainBorder + borderMain, iconsSize, iconsSize);
//    self.settingsButton.backgroundColor = [UIColor redColor];
    [self.settingsButton setTitle: @"Settings" forState: UIControlStateNormal];
    
    self.startButton.frame = CGRectMake(rect.size.width - borderMain - iconsSize, rect.size.height - borderMain - iconsSize, iconsSize, iconsSize);
    self.startButtonPC.frame = CGRectMake(borderMain, rect.size.height - borderMain - iconsSize, iconsSize, iconsSize);
    
    self.startButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.startButton setTitle: @"Restart\n(player\nmove)" forState: UIControlStateNormal];
    [self.startButton setTitle: @"New\ngame" forState: UIControlStateNormal];
    
    self.startButtonPC.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.startButtonPC.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.startButtonPC setTitle: @"Restart\n(phone\nmove)" forState: UIControlStateNormal];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGRect boardFrame = CGRectZero;
    
    CGFloat border = 0.4;
    CGFloat extendLine = 1;
    
    if (orientation == UIDeviceOrientationPortrait)
    {
        CGFloat maxWidth = rect.size.width - borderMain * 2;
        CGFloat boardHeight = maxWidth;
        
        self.cellSize = MIN(maxWidth / (self.numOfColumns + border * 2),
                            boardHeight / (self.numOfLines + border * 2 + extendLine));
        self.borderSize = self.cellSize * border;
        
        CGFloat boardWidth = MIN(maxWidth, self.cellSize * self.numOfColumns);

        boardFrame = CGRectMake((maxWidth - boardWidth) / 2 + borderMain,
                                self.borderSize + borderMain * 2 + iconsSize + upMainBorder,
                                boardWidth,
                                boardHeight);
    }
    else
    {
        CGFloat maxWidth = rect.size.width - borderMain * 4 - iconsSize * 2;
        CGFloat boardHeight = rect.size.height - borderMain * 2;
        
        self.cellSize = MIN(maxWidth / (self.numOfColumns + border * 2),
                            boardHeight / (self.numOfLines + extendLine + border * 2));
        self.borderSize = self.cellSize * border;
        
        CGFloat boardWidth = MIN(maxWidth, self.cellSize * self.numOfColumns);
        
        boardFrame = CGRectMake((maxWidth - boardWidth) / 2 + borderMain * 2 + iconsSize,
                                self.borderSize + borderMain + upMainBorder,
                                boardWidth,
                                boardHeight);
    }
    
    self.gameBoard.frame = boardFrame;
    
    // creating wood borders
    // UPPER
    CGRect borderFrame = CGRectMake(boardFrame.origin.x,
                                    boardFrame.origin.y - self.borderSize,
                                    boardFrame.size.width,
                                    self.borderSize);
    self.upperBorder.frame = borderFrame;
    
    // DOWN
    borderFrame = CGRectMake(boardFrame.origin.x,
                             boardFrame.origin.y + self.cellSize * self.numOfLines,
                             boardFrame.size.width,
                             self.borderSize);
    self.downBorder.frame = borderFrame;
    
    // LEFT
    borderFrame = CGRectMake(boardFrame.origin.x - self.borderSize,
                             boardFrame.origin.y,
                             self.borderSize,
                             self.cellSize * self.numOfLines);
    self.leftBorder.frame = borderFrame;
    
    // RIGHT
    borderFrame = CGRectMake(boardFrame.origin.x + self.cellSize * self.numOfColumns,
                             boardFrame.origin.y,
                             self.borderSize,
                             self.cellSize * self.numOfLines);
    self.rightBorder.frame = borderFrame;
    
    // Coners
    // UpLeft
    borderFrame = CGRectMake(boardFrame.origin.x - self.borderSize,
                             boardFrame.origin.y - self.borderSize,
                             self.borderSize,
                             self.borderSize);
    self.ulConer.frame = borderFrame;
    
    // DownLeft
    borderFrame = CGRectMake(boardFrame.origin.x - self.borderSize,
                             boardFrame.origin.y + self.cellSize * self.numOfLines,
                             self.borderSize,
                             self.borderSize);
    self.dlConer.frame = borderFrame;
    
    // UpRight
    borderFrame = CGRectMake(boardFrame.origin.x + self.cellSize * self.numOfColumns,
                             boardFrame.origin.y - self.borderSize,
                             self.borderSize,
                             self.borderSize);
    self.urConer.frame = borderFrame;
    
    // DownRight
    borderFrame = CGRectMake(boardFrame.origin.x + self.cellSize * self.numOfColumns,
                             boardFrame.origin.y + self.cellSize * self.numOfLines,
                             self.borderSize,
                             self.borderSize);
    self.drConer.frame = borderFrame;

    [self.gameBoard setNeedsDisplay];
    [self.gameBoard setNeedsLayout];
}

#pragma mark - Properties

-(void)setTempLocation:(CGPoint)location
{
    self.gameBoard.tempLocation = [self convertPoint:location toView:self.gameBoard];
}

-(UIImageView *)upperBorder
{
    if (!_upperBorder) {
        _upperBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Border"]];
        _upperBorder.alpha = 0;
        [self addSubview:_upperBorder];
    }
    return _upperBorder;
}

-(UIImageView *)downBorder
{
    if (!_downBorder) {
        _downBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderTest"]];
//        _downBorder.alpha = 0;
        [self addSubview:_downBorder];
    }
    return _downBorder;
}

-(UIImageView *)leftBorder
{
    if (!_leftBorder) {
        _leftBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderVert"]];
        _leftBorder.alpha = 0;
        [self addSubview:_leftBorder];
    }
    return _leftBorder;
}

-(UIImageView *)rightBorder
{
    if (!_rightBorder) {
        _rightBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BorderVert"]];
        _rightBorder.alpha = 0;
        [self addSubview:_rightBorder];
    }
    return _rightBorder;
}

-(UIImageView *)ulConer
{
    if (!_ulConer) {
        _ulConer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ULConer"]];
        _ulConer.alpha = 0;
        [self addSubview:_ulConer];
    }
    return _ulConer;
}

-(UIImageView *)urConer
{
    if (!_urConer) {
        _urConer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"URConer"]];
        _urConer.alpha = 0;
        [self addSubview:_urConer];
    }
    return _urConer;
}

-(UIImageView *)dlConer
{
    if (!_dlConer) {
        _dlConer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DLConerTest"]];
        [self addSubview:_dlConer];
    }
    return _dlConer;
}

-(UIImageView *)drConer
{
    if (!_drConer) {
        _drConer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DRConerTest"]];
        [self addSubview:_drConer];
    }
    return _drConer;
}

#pragma mark - UIViews delegate

-(void)startNewGame:(UIButton *)button
{
    [self.delegate startNewGame];
}


#pragma mark - Intarface metods

-(void)drawBlockAtPoint:(CGPoint)location forPlayer:(int)player
{
    [self.gameBoard drawBlockAtPoint:location forPlayer:player];
}

-(int)blockColumnForLocation:(CGPoint)location
{
    return [self.gameBoard blockColumnForLocation:[self convertPoint:location toView:self.gameBoard]];
}

-(void)newGame
{
    for (id subview in self.gameBoard.subviews) {
        if ([subview isKindOfClass:[BlockView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    self.tempLocation = CGPointZero;
    self.blockStack = nil;
    self.gameBoard.moves.text = @"";
    
    [self.gameOverView setHidden:YES];
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

@end
*/

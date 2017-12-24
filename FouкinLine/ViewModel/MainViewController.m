//
//  ViewController.m
//  FourInLine
//
//  Created by Василий Муравьев on 05.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//
/*
#import "MainViewController.h"
#import "GameView.h"
#import "GameBoardView.h"
#import "Game.h"
#import "SettingsTableViewController.h"

typedef struct {
    CGPoint location;
    enum players player;
} NewMove;

@interface MainViewController () <GameDelegate, GameBoardViewDelegate>

@property (weak, nonatomic) IBOutlet GameView *gameView;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (strong, nonatomic) Game *game;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *startButtonPC;
@property (weak, nonatomic) IBOutlet UIView *player1Icon;
@property (weak, nonatomic) IBOutlet UIView *player2Icon;
@property (weak, nonatomic) IBOutlet GameBoardView *gameBoardView;
@property (weak, nonatomic) IBOutlet UIView *gameOverView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (assign, nonatomic) BOOL blockInMotion;
@property (assign, nonatomic) NewMove drawMove;
@property (assign, nonatomic) NewMove addMove;
@property (assign, nonatomic) BOOL newGameStarted;

@end

@implementation MainViewController

- (IBAction)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (self.blockInMotion) {
        // do nothing
    }
    else if (self.game.gameOver) {
        self.gameView.tempLocation = CGPointMake(0, 0);
    }
    else if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [gesture locationInView:self.gameView];
        self.gameView.tempLocation = location;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint location = [gesture locationInView:self.gameView];
        self.gameView.tempLocation = location;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [gesture locationInView:self.gameView];
//        NewMove move;
//        move.location = location;
//        self.addMove = move;
//        [self addNewBlock];
        
        int blockColumn = [self.gameView blockColumnForLocation:location];
        if (blockColumn != 0) {
            [self.game addBlockInColumn:(NSUInteger)blockColumn];
        }
    }
    else
    {
        self.gameView.tempLocation = CGPointMake(0, 0);
    }
}

-(BOOL)blockInMotion
{
    return _blockInMotion || self.game.blocked;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.game = [[Game alloc] init];
    self.game.delegate = self;
    
    self.newGameStarted = NO;
    
    self.gameView.contentMode = UIViewContentModeRedraw;
    self.gameBoardView.contentMode = UIViewContentModeRedraw;
    self.gameBoardView.delegate = self;

    self.gameView.gameBoard = self.gameBoardView;
    self.gameView.player1Icon = self.player1Icon;
    self.gameView.player2Icon = self.player2Icon;
    self.gameView.settingsButton = self.settingsButton;
    self.gameView.startButton = self.startButton;
    self.gameView.startButtonPC = self.startButtonPC;
    self.gameView.gameOverView = self.gameOverView;
    
    self.gameOverView.backgroundColor = [UIColor clearColor];
    
    [self.gameOverView setHidden:YES];
    self.gameBoardView.moves = [[UITextView alloc] init];
    [self.gameBoardView addSubview:self.gameBoardView.moves];
    
    [self.game startNewGame];
    
    self.gameView.numOfColumns = self.game.numOfColumns;
    self.gameView.numOfLines = self.game.numOfLines;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    if (self.game.gameOver) {
        [self gameOverWithWinner:self.game.winner];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - GameView delegate

-(IBAction)startNewGame:(id)sender
{
    if (!self.blockInMotion) {
        self.newGameStarted = NO;
        [self.game startNewGame];
        self.gameView.numOfColumns = self.game.numOfColumns;
        self.gameView.numOfLines = self.game.numOfLines;
        
        [self.gameView newGame];
    } else if (!self.newGameStarted) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startNewGame:) userInfo:nil repeats:NO];
        self.newGameStarted = YES;
    }

//    [self.game newGameWithPlayer:Human];
}

-(IBAction)startNewGamePC:(id)sender
{
//    self.blockInMotion = NO;
//    [self.gameView newGame];
//    [self.game newGameWithPlayer:Computer];
}

-(void)blockDidFinishMotion
{
    self.blockInMotion = NO;
}

#pragma mark - Game delegate

-(void)blockAddedAtPoint:(CGPoint)point forPlayer:(int)player
{
    NewMove move;
    move.location = point;
    move.player = player;
    self.drawMove = move;
    
    [self drawNewBlock];
}

-(void)drawNewBlock
{
    if (!self.blockInMotion) {
        self.blockInMotion = YES;
//        NSLog(@"Player %d move to point: %@", self.drawMove.player, NSStringFromCGPoint(self.drawMove.location));
        self.gameView.blockStack = self.game.blockStack;
        [self.gameView drawBlockAtPoint:self.drawMove.location forPlayer:self.drawMove.player];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(drawNewBlock) userInfo:nil repeats:NO];
    }
    
}

-(void)addNewBlock
{
    if (!self.blockInMotion) {
        int blockColumn = [self.gameView blockColumnForLocation:self.addMove.location];
        if (blockColumn != 0) {
            [self.game addBlockInColumn:(NSUInteger)blockColumn];
        }
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addNewBlock) userInfo:nil repeats:NO];
    }
    
}

-(void)gameOverWithWinner:(int)winner
{
    if (winner != nobody) {
        // чествуем победителя
        [self showGameOver];
    } else {
        // ничья(
    }
}

-(void)showGameOver
{
    if (!self.blockInMotion) {
        [self.gameBoardView blinkWinnerMoves:self.game.winnerMoves];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showGameOver) userInfo:nil repeats:NO];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SettingsTableViewController *setController = [segue destinationViewController];
    setController.game = self.game;
}

@end
*/

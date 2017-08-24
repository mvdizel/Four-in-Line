//
//  Game.m
//  Four in Line
//
//  Created by Василий Муравьев on 05.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//

#import "Game.h"
#import "GameAI.h"
//#import "GameMove.h"

@interface Game ()
//@property (strong, nonatomic, readwrite) NSMutableDictionary *gameBoard;
@property (strong, nonatomic, readwrite) NSMutableArray *blockStack;
@property (nonatomic) int curPlayer;
@property (nonatomic, readwrite) BOOL gameOver;
@property (strong, nonatomic) GameAI *gameAI;
//@property (strong, nonatomic, readwrite) GameBoard *gameBoard;
@property (assign, nonatomic) BOOL blocked;
@property (strong, nonatomic, readwrite) NSMutableArray *winnerMoves;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation Game

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.gameAI = [[GameAI alloc] init];
        self.gameAI.game = self;
        self.curPlayer = nobody;
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = app.managedObjectContext;
        [self initializeSettings];
    }
    return self;
}

-(void)setGameOver:(BOOL)gameEnded
{
    _gameOver = gameEnded;
    if (_gameOver) {
        [self.delegate gameOverWithWinner:(int)self.winner];
//        NSLog(@"Game ended, WINNER IS: %d", self.winner);
    }
    
}

- (void)initializeSettings
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SettingsData"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([fetchedObjects count] == 0) {
        [self setDefaultSettings];
    }
    
    _settings = fetchedObjects[0];
}

-(void)setDefaultSettings
{
    _settings = [NSEntityDescription
                 insertNewObjectForEntityForName:@"SettingsData"
                 inManagedObjectContext:_managedObjectContext];
    
    _settings.difficult = 0;
    _settings.numOfLines = minNumOfLines;
    _settings.numOfColumns = minNumOfColumns;
    _settings.firstMoveHuman = YES;
    
    if (![_managedObjectContext save:nil])
    {
        NSLog(@"Save did not complete successfully. Error: %@", @"");
    }
}

-(void)setCurPlayer:(int)curPlayer
{
    _curPlayer = curPlayer;
    if (_curPlayer == Computer && !self.gameOver)
    {
        self.blocked = YES;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            CGPoint nextMove = [self.gameAI nextMove];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.blocked = NO;
                if (CGPointEqualToPoint(nextMove, CGPointZero)) {
                    self.gameOver = YES;
                }
                else
                {
                    [self addBlockInColumn:nextMove.x];
                }
            });
        });
    }
}

-(NSMutableArray *)blockStack
{
    if (!_blockStack) {
        _blockStack = [NSMutableArray array];
        [self initBlockStack];
    }
    return _blockStack;
}

-(void)initBlockStack
{
    [self.blockStack removeAllObjects];
    for (NSInteger x = 0; x < self.numOfColumns; x++) {
        [self.blockStack addObject:@(0)];
    }
}
//
//-(void)newGame
//{
//    [self newGameWithPlayer:(self.curPlayer == nobody ? Human : 3 - self.curPlayer)];
//}

-(void)newGameWithPlayer:(enum players)player
{
    self.numOfColumns = self.settings.numOfColumns;
    self.numOfLines = self.settings.numOfLines;
    self.difficult = self.settings.difficult;
    
    self.blockStack = nil;
    self.gameOver = NO;
    self.winner = nobody;
    
    [self.gameAI clearBoard];

    self.curPlayer = player;
}

-(void)startNewGame
{
    [self newGameWithPlayer:(_settings.firstMoveHuman) ? Human : Computer];
}

-(void)addBlockInColumn:(NSUInteger)column
{
    if (self.blocked) {
        return;
    }
    
    NSUInteger blockIndex = column - 1;
    
    NSUInteger line = [[self.blockStack objectAtIndex:blockIndex] floatValue] + 1;

    if (line <= self.numOfLines && !self.gameOver)
    {
        self.blockStack[blockIndex] = @(line);
        CGPoint newMove = CGPointMake(column, line);
        
        BOOL win = [self.gameAI makeMoveAtPointX:(int)column y:(int)line forPlayer:self.curPlayer] == maxWinScore;
        [self.delegate blockAddedAtPoint:newMove forPlayer:self.curPlayer];
        
        if (win)
        {
            self.winnerMoves = [self.gameAI winnerMovesAtPointX:(int)column y:(int)line forPlayer:self.curPlayer];
//            NSLog(@"%@", self.winnerMoves);
            self.winner = self.curPlayer;
            self.gameOver = YES;
        }
        else
        {
            BOOL gameOver = YES;
            for (id obj in self.blockStack) {
                if ([obj floatValue] < self.numOfLines) {
                    gameOver = NO;
                    break;
                }
            }
            if (gameOver) { self.gameOver = YES; }
        }
        
        self.curPlayer = 3 - self.curPlayer;
    }
}

-(NSMutableArray *)winnerMoves
{
    if (!_winnerMoves) {
        _winnerMoves = [NSMutableArray array];
    }
    return _winnerMoves;
}

@end

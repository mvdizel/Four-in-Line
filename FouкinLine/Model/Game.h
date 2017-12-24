//
//  Game.h
//  FourInLine
//
//  Created by Василий Муравьев on 05.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//

/*
#import <Foundation/Foundation.h>
#import "GameSettings.h"
#import "SettingsData.h"
#import "AppDelegate.h"

@protocol GameDelegate <NSObject>
@required
-(void)gameOverWithWinner:(int)winner;
-(void)blockAddedAtPoint:(CGPoint)point forPlayer:(int)player;
@end

@interface Game : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *blockStack;
@property (weak, nonatomic) id<GameDelegate> delegate;
@property (nonatomic, readonly) BOOL gameOver;
@property (strong, nonatomic, readonly) NSMutableArray *winnerMoves;
@property (strong, nonatomic) SettingsData *settings;
@property (assign, nonatomic) BOOL blocked;
@property (nonatomic) CGFloat numOfLines;
@property (nonatomic) CGFloat numOfColumns;
@property (assign, nonatomic) int difficult;
@property (nonatomic) int winner;

-(void)addBlockInColumn:(NSUInteger)column;
//-(void)newGame;
//-(void)newGameWithPlayer:(enum players)player;
//-(void)setDefaultSettings;
-(void)startNewGame;

@end
*/

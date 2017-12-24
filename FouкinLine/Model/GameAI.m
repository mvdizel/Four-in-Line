//
//  GameAI.m
//  FourInLine
//
//  Created by Василий Муравьев on 06.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//
/*
#import "GameAI.h"

typedef struct {
    int line_LU_RD_pos;
    int line_L_R_pos;
    int line_LD_RU_pos;
    int line_U_D_pos;
} linesValues;

// *LINES MAP*
//
// LU | U | RU
// ---|---|---
// L  | + |  R
// ---|---|---
// LD | D | RD

typedef long long unsigned int ll;

@interface GameAI ()

@property (assign, nonatomic) int maxDepth;
@property (assign, nonatomic) ll moveStack;

@property (assign, nonatomic) NSInteger testArray;

@property (assign, nonatomic) int maxNumOfBlocks;
@property (assign, nonatomic) int maxNumOfChecks;
@property (assign, nonatomic) ll testHexValue1;
@property (assign, nonatomic) ll testHexValue1Fork;
//@property (assign, nonatomic) ll testHexValue1SmallFork;
//@property (assign, nonatomic) ll testHexValue1Prefork;
//@property (assign, nonatomic) ll testHexValue1SmallPrefork;
@property (assign, nonatomic) ll testHexValue2;
@property (assign, nonatomic) ll testHexValue2Fork;
//@property (assign, nonatomic) ll testHexValue2SmallFork;
//@property (assign, nonatomic) ll testHexValue2Prefork;
//@property (assign, nonatomic) ll testHexValue2SmallPrefork;

//@property (assign, nonatomic) int **linesArrayHuman;
//@property (assign, nonatomic) int **linesArrayComputer;
@property (assign, nonatomic) ll **linesArray;
//@property (assign, nonatomic) int maxDepth;

@end

@implementation GameAI

-(void)dealloc
{
    for (int i = 0; i < 4; i++) {
//        free(_linesArrayComputer[i]);
//        free(_linesArrayHuman[i]);
        free(_linesArray[i]);
    }
//    free(_linesArrayComputer);
//    free(_linesArrayHuman);
    free(_linesArray);
}

-(CGPoint)nextMove
{
    CGPoint bestMove = CGPointZero;
    
    long long unsigned int moves = self.moveStack;
    CGFloat center = self.game.numOfColumns / 2. + 0.5;
    
    CGFloat beta = INFINITY;
    CGFloat alpha = -INFINITY;
    int depth = 1;
    
    for (int x = 1; x <= self.game.numOfColumns; x++)
    {
        int y = ((moves >> (4 * (int)(x - 1))) & 0xf) + 1;

        if (y > self.game.numOfLines) {
            continue;
        }
        
        CGPoint move = CGPointMake(x, y);
        
        int i1 = 0;
        CGFloat sc = [self makeMoveAtPointX:x y:y forPlayer:Computer];
        if (sc == maxWinScore) {
            bestMove = move;
            [self cancelMoveAtPointX:x y:y forPlayer:Computer];
            break;
        } else {
            sc = [self testPositionForPlayer:Human i:&i1 alpha:-beta beta:-alpha andDepth:&depth forFork:NO];
        }
        [self cancelMoveAtPointX:x y:y forPlayer:Computer];
        
        CGFloat centerK = 1 - (sc < 0 ? -1. : 1.) * POSITIVE(move.x - center) / center / 10000;
        CGFloat randomK = 1 - (sc < 0 ? -1. : 1.) * arc4random_uniform(100) / 1000000;
        NSLog(@"Move %@ score %f for player %d center k %f i %d", NSStringFromCGPoint(move), sc, Computer, centerK, i1);
        sc = sc * centerK * randomK;
//        sc = sc * centerK;
        
        if (sc > alpha) {
            alpha = sc;
            bestMove = move;
        } else if (CGPointEqualToPoint(bestMove, CGPointZero)) {
            bestMove = move;
        }
    }
    
    return bestMove;
}

-(CGFloat)testPositionForPlayer:(int)player i:(int*)i alpha:(CGFloat)alpha beta:(CGFloat)beta andDepth:(int*)depth forFork:(BOOL)isFork
{
    *i += 1;
    
    ll moves = self.moveStack;
    
    ll forkMoves = 0;
    BOOL willBeFork = NO;

    // first check win moves
    for (int x = 1; x <= self.game.numOfColumns; x++)
    {
        int y = ((moves >> (4 * (x - 1))) & 0xF) + 1;
        
        if (y > self.game.numOfLines) {
            continue;
        }
        
        CGFloat sc = [self makeMoveAtPointX:x y:y forPlayer:player];
        [self cancelMoveAtPointX:x y:y forPlayer:player];
        
        if (sc == maxWinScore) {
            return -sc * WIN_K;
        } else if (sc == forkWinScore) {
            forkMoves |= (0xf << 4 * (x - 1)) & moves;
            willBeFork = YES;
        } else {
            forkMoves |= (ll)self.game.numOfLines << 4 * (x - 1);
        }
    }
    
    if (isFork) {
        return forkWinScore;
    }
    
    moves = !willBeFork ? self.moveStack : forkMoves;
    
    for (int x = 1; x <= self.game.numOfColumns; x++)
    {
        int y = ((moves >> (4 * (x - 1))) & 0xF) + 1;
        
        if (y > self.game.numOfLines) {
            continue;
        }

        CGFloat sc = [self makeMoveAtPointX:x y:y forPlayer:player];
        
        if (sc <= forkWinScore && *depth < self.maxDepth) {
            *depth += 1;
            sc = [self testPositionForPlayer:3 - player i:i alpha:-beta beta:-alpha andDepth:depth forFork:willBeFork];
            *depth -= 1;
        } else {
            sc = sc * WIN_K;
        }

        [self cancelMoveAtPointX:x y:y forPlayer:player];
        
        if (sc > alpha) {
            alpha = sc;
        }
        
        if (alpha >= beta) {
            return -alpha;
        }
    }
    
    return -alpha;
}

-(void)clearBoard
{
    self.maxDepth = (self.game.difficult == EasyD) ? MAX_DEPTH_EASY : MAX_DEPTH;

    self.maxNumOfBlocks = MAX(self.game.numOfColumns, self.game.numOfLines);
    self.maxNumOfChecks = self.maxNumOfBlocks + 1 - LINE_SIZE;

    self.testHexValue1 = 0x0;
    self.testHexValue2 = 0x0;
    
    for (int i = 0; i < LINE_SIZE; i++)
    {
        self.testHexValue1 = self.testHexValue1 | ((ll)0x1 << (i * 4));
        self.testHexValue2 = self.testHexValue2 | ((ll)0x2 << (i * 4));
    }
    
    self.testHexValue1Fork         = (((self.testHexValue1 >> 4) << 4) | (ll)0x4) | ((ll)0x4 << (LINE_SIZE * 4));
//    self.testHexValue1SmallFork    = (((self.testHexValue1 >> 8) << 8) | (ll)0x40) | ((ll)0x4 << (LINE_SIZE * 4));
//    self.testHexValue1Prefork      = ((self.testHexValue1 >> 4) << 4);
//    self.testHexValue1SmallPrefork = ((self.testHexValue1 >> 8) << 8);
    
    self.testHexValue2Fork         = (((self.testHexValue2 >> 4) << 4) | (ll)0x4) | ((ll)0x4 << (LINE_SIZE * 4));
//    self.testHexValue2SmallFork    = (((self.testHexValue2 >> 8) << 8) | (ll)0x40) | ((ll)0x4 << (LINE_SIZE * 4));
//    self.testHexValue2Prefork      = ((self.testHexValue2 >> 4) << 4);
//    self.testHexValue2SmallPrefork = ((self.testHexValue2 >> 8) << 8);
    
    self.moveStack = 0x0;
    
    for (int i = 0; i < 4; i++) {
        if (_linesArray) free(_linesArray[i]);
    }
    if (_linesArray) free(_linesArray);

    self.linesArray = (ll **)malloc(sizeof(ll *) * 4);
    
    for (int i = 0; i < 4; i++)
    {
        int count = (i == 0 ? self.game.numOfColumns : (i == 1 ? self.game.numOfLines : (self.game.numOfColumns + self.game.numOfLines - 1)));
        self.linesArray[i] = (ll *)malloc(sizeof(ll) * count);
       
        for (int ii = 0; ii < count; ii++)
        {
            if (i == 0 || (i == 2 && ii >= count - self.game.numOfColumns) || (i == 3 && ii < self.game.numOfColumns))
            {
                self.linesArray[i][ii] = (ll)4;
            }
            else if (i == 1 && ii == 0)
            {
                ll fullLine = (ll)0x4;
                int iii = 1;
                do { fullLine = (fullLine << 4) | (ll)4; } while (++iii < self.game.numOfColumns);
                self.linesArray[i][ii] = fullLine;
            }
            else
            {
                self.linesArray[i][ii] = (ll)0;
            }
        }
    }
}

-(CGFloat)makeMoveAtPointX:(int)x y:(int)y forPlayer:(enum players)player
{
    linesValues values;
    
    int xMinus1 = x - 1;
    int yMinus1 = y - 1;
    
    ll xHexMove = (ll)(player == Human ? 5 : 6) << (4 * xMinus1);
    ll yHexMove = (ll)(player == Human ? 5 : 6) << (4 * yMinus1);
    
    self.moveStack += ((ll)1 << (4 * xMinus1));
    
    values.line_U_D_pos   = xMinus1;
    values.line_L_R_pos   = yMinus1;
    values.line_LD_RU_pos = xMinus1 + (int)self.game.numOfLines - y;
    values.line_LU_RD_pos = xMinus1 + yMinus1;
    
    self.linesArray[0][values.line_U_D_pos]   ^= yHexMove;// ^ self.linesArray[0][values.line_U_D_pos];
    self.linesArray[1][values.line_L_R_pos]   ^= xHexMove;// ^ self.linesArray[1][values.line_L_R_pos];
    self.linesArray[2][values.line_LD_RU_pos] ^= yHexMove;// ^ self.linesArray[2][values.line_LD_RU_pos];
    self.linesArray[3][values.line_LU_RD_pos] ^= yHexMove;// ^ self.linesArray[3][values.line_LU_RD_pos];
    
    if (y < self.game.numOfLines) {
        ll xHexMovePoss = (ll)4 << (4 * xMinus1);
        ll yHexMovePoss = (ll)4 << (4 * y);
        self.linesArray[0][values.line_U_D_pos]       |= yHexMovePoss;// | self.linesArray[0][values.line_U_D_pos];
        self.linesArray[1][values.line_L_R_pos + 1]   |= xHexMovePoss;// | self.linesArray[1][values.line_L_R_pos + 1];
        self.linesArray[2][values.line_LD_RU_pos - 1] |= yHexMovePoss;// | self.linesArray[2][values.line_LD_RU_pos - 1];
        self.linesArray[3][values.line_LU_RD_pos + 1] |= yHexMovePoss;// | self.linesArray[3][values.line_LU_RD_pos + 1];
    }
    
    // Score of current position
    
    BOOL win = NO;
    BOOL fork = NO;
//    BOOL smallFork = NO;
    
    ll testHexValue = (player == Human ? self.testHexValue1 : self.testHexValue2);
    ll testHexValueFork = (player == Human ? self.testHexValue1Fork : self.testHexValue2Fork);
    
    ll line_U_D = self.linesArray[0][values.line_U_D_pos];
    ll line_L_R = self.linesArray[1][values.line_L_R_pos];
    ll line_LD_RU = self.linesArray[2][values.line_LD_RU_pos];
    ll line_LU_RD = self.linesArray[3][values.line_LU_RD_pos];
    
    line_U_D <<= 0x4;
    line_L_R <<= 0x4;
    line_LD_RU <<= 0x4;
    line_LU_RD <<= 0x4;
    
    for (int i = 0; i < self.maxNumOfChecks; i++)
    {
        line_U_D >>= 0x4;
        line_L_R >>= 0x4;
        line_LD_RU >>= 0x4;
        line_LU_RD >>= 0x4;
        
        if ((line_U_D & testHexValue) == testHexValue) { win = YES; break; }
        if ((line_L_R & testHexValue) == testHexValue) { win = YES; break; }
        if ((line_LD_RU & testHexValue) == testHexValue) { win = YES; break; }
        if ((line_LU_RD & testHexValue) == testHexValue) { win = YES; break; }

        if (!fork && self.game.difficult != EasyD)
        {
            if ((line_U_D & testHexValueFork) == testHexValueFork) { fork = YES; continue; }
            if ((line_L_R & testHexValueFork) == testHexValueFork) { fork = YES; continue; }
            if ((line_LD_RU & testHexValueFork) == testHexValueFork) { fork = YES; continue; }
            if ((line_LU_RD & testHexValueFork) == testHexValueFork) { fork = YES; continue; }
        }
    }
    
    return (win ? maxWinScore : (fork ? forkWinScore : minWinScore));    
}

-(void)cancelMoveAtPointX:(int)x y:(int)y forPlayer:(enum players)player
{
    linesValues values;
    
    int xMinus1 = x - 1;
    int yMinus1 = y - 1;
    
    ll xHexMove = (ll)(player == Human ? 5 : 6) << (4 * xMinus1);
    ll yHexMove = (ll)(player == Human ? 5 : 6) << (4 * yMinus1);
    
    values.line_U_D_pos   = xMinus1;
    values.line_L_R_pos   = yMinus1;
    values.line_LD_RU_pos = xMinus1 + (int)self.game.numOfLines - y;
    values.line_LU_RD_pos = xMinus1 + yMinus1;

    self.moveStack -= ((ll)1 << (4 * xMinus1));
    
    self.linesArray[0][values.line_U_D_pos]   ^= yHexMove;// ^ self.linesArray[0][values.line_U_D_pos];
    self.linesArray[1][values.line_L_R_pos]   ^= xHexMove;// ^ self.linesArray[1][values.line_L_R_pos];
    self.linesArray[2][values.line_LD_RU_pos] ^= yHexMove;// ^ self.linesArray[2][values.line_LD_RU_pos];
    self.linesArray[3][values.line_LU_RD_pos] ^= yHexMove;// ^ self.linesArray[3][values.line_LU_RD_pos];
    
    if (y < self.game.numOfLines) {
        ll xHexMovePoss = (ll)4 << (4 * xMinus1);
        ll yHexMovePoss = (ll)4 << (4 * y);
        self.linesArray[0][values.line_U_D_pos]       ^= yHexMovePoss;// ^ self.linesArray[0][values.line_U_D_pos];
        self.linesArray[1][values.line_L_R_pos + 1]   ^= xHexMovePoss;// ^ self.linesArray[1][values.line_L_R_pos + 1];
        self.linesArray[2][values.line_LD_RU_pos - 1] ^= yHexMovePoss;// ^ self.linesArray[2][values.line_LD_RU_pos - 1];
        self.linesArray[3][values.line_LU_RD_pos + 1] ^= yHexMovePoss;// ^ self.linesArray[3][values.line_LU_RD_pos + 1];
    }
}

-(NSMutableArray *)winnerMovesAtPointX:(int)x y:(int)y forPlayer:(enum players)player
{
    linesValues values;
    
    int xMinus1 = x - 1;
    int yMinus1 = y - 1;
    
    values.line_U_D_pos   = xMinus1;
    values.line_L_R_pos   = yMinus1;
    values.line_LD_RU_pos = xMinus1 + (int)self.game.numOfLines - y;
    values.line_LU_RD_pos = xMinus1 + yMinus1;
    
    ll testHexValue = (player == Human ? self.testHexValue1 : self.testHexValue2);
    
    NSMutableArray *winnerMoves = [NSMutableArray array];
    
    for (int i = 0; i < self.maxNumOfChecks; i++)
    {
        if ((self.linesArray[0][values.line_U_D_pos]   & testHexValue) == testHexValue)
        {
            [self addWinMovesInArray:winnerMoves atLine:0 forValue:testHexValue andPlayer:player x:x y:y];
        }
        if ((self.linesArray[1][values.line_L_R_pos]   & testHexValue) == testHexValue)
        {
            [self addWinMovesInArray:winnerMoves atLine:1 forValue:testHexValue andPlayer:player x:x y:y];
        }
        if ((self.linesArray[2][values.line_LD_RU_pos] & testHexValue) == testHexValue)
        {
            [self addWinMovesInArray:winnerMoves atLine:2 forValue:testHexValue andPlayer:player x:x y:y];
        }
        if ((self.linesArray[3][values.line_LU_RD_pos] & testHexValue) == testHexValue)
        {
            [self addWinMovesInArray:winnerMoves atLine:3 forValue:testHexValue andPlayer:player x:x y:y];
        }
        testHexValue = testHexValue << 4;
    }
    
    return winnerMoves;
}

-(void)addWinMovesInArray:(NSMutableArray *)array atLine:(int)line forValue:(ll)value andPlayer:(enum players)player x:(int)x y:(int)y
{
    linesValues values;
    
    int xMinus1 = x - 1;
    int yMinus1 = y - 1;
    
    values.line_U_D_pos   = xMinus1;
    values.line_L_R_pos   = yMinus1;
    values.line_LD_RU_pos = xMinus1 + (int)self.game.numOfLines - y;
    values.line_LU_RD_pos = xMinus1 + yMinus1;
    
    ll winValue = (player == Human ? 0x1 : 0x2);
    
    for (int i = 1; i <= self.maxNumOfBlocks; i++)
    {
        if ((value & winValue) == winValue)
        {
            NSValue *location = nil;
            switch (line) {
                case 0:
                    location = [NSValue valueWithCGPoint:CGPointMake(x, i)];
                    break;
                case 1:
                    location = [NSValue valueWithCGPoint:CGPointMake(i, y)];
                    break;
                case 2:
                    location = [NSValue valueWithCGPoint:CGPointMake(i + x - y, i)];
                    break;
                case 3:
                    location = [NSValue valueWithCGPoint:CGPointMake(x + y - i, i)];
                    break;
            }
            if (location != nil && ![array containsObject:location]) {
                [array addObject:location];
            }
        }
        value >>= 4;
    }
}

@end
*/

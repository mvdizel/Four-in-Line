//
//  GameBoardView.h
//  Four in Line
//
//  Created by Василий Муравьев on 06.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameBoardViewDelegate <NSObject>

-(void)blockDidFinishMotion;

@end

@interface GameBoardView : UIView

@property (nonatomic, readonly) CGFloat cellSize;
@property (nonatomic, readonly) CGFloat borderSize;
@property (nonatomic) CGPoint tempLocation;
@property (strong, nonatomic) UITextView *moves;
@property (weak, nonatomic) id<GameBoardViewDelegate> delegate;

-(int)blockColumnForLocation:(CGPoint)location;
-(void)drawBlockAtPoint:(CGPoint)point forPlayer:(int)player;
-(void)blinkWinnerMoves:(NSArray *)winnerMoves;

@end

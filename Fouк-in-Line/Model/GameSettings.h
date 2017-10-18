//
//  GameSettings.h
//  Four-in-Line
//
//  Created by Василий Муравьев on 06.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef Four_in_Line_GameSettings_h
#define Four_in_Line_GameSettings_h

#define POSITIVE(n) ((n) < 0 ? -1 * (n) : (n))
#define LINE_SIZE 4
#define MAX_DEPTH 8
#define MAX_DEPTH_EASY 4

#define DROP_ANIM_DURATION 0.4
//#define MIN_DEPTH 4
//#define MAX_ITERATION 50000
#define WIN_K (1. - *depth / (CGFloat)MAX_DEPTH / 10.)
//#define VARIANT 2

enum players { nobody, Human, Computer };
enum difficulties { EasyD, NormalD };

static const int maxNumOfLines = 8;
static const int maxNumOfColumns = 9;

static const int minNumOfLines = 6;
static const int minNumOfColumns = 7;

static const CGFloat maxWinScore = 10.;
static const CGFloat forkWinScore = 9.0;

//static const CGFloat smallForkWinScore = 7.0;
//static const CGFloat preforkWinScore = 5.0;
//static const CGFloat smallPreforkWinScore = 3.0;
static const CGFloat minWinScore = 0.1;

#endif

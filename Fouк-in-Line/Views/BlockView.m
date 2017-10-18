//
//  BlockView.m
//  Four-in-Line
//
//  Created by Василий Муравьев on 05.09.15.
//  Copyright (c) 2015 Vasilii Muravev. All rights reserved.
//
/*
#import "BlockView.h"

@interface BlockView ()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation BlockView

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(self.player == Human ? @"Red" : @"Blue")]];
        if (self.temp) {
            [_imageView setAlpha:.5];
        }
        [self addSubview:_imageView];
    }
    return _imageView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat move = rect.size.width * 16.0 / 100.0;
    self.imageView.frame = CGRectMake(move / 2.0, move / 2.0, rect.size.width - move, rect.size.width - move);
}

@end
*/

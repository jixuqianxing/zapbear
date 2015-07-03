//
//  Menu.m
//  FlashBear
//
//  Created by quantum on 27/06/2015.
//  Copyright (c) 2015 Paul Muren. All rights reserved.
//

#import "Menu.h"
#import <QuartzCore/QuartzCore.h>

@implementation Menu

- (id)initWithFrame:(CGRect)frame points:(NSInteger)points {
    self = [super initWithFrame:frame];

    self.backgroundColor = [UIColor clearColor];
    
    //float w = frame.size.width * .25;
    
    float h = frame.size.height * .20;
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width * .15, frame.size.height * .5 - h, frame.size.width * .70, h)];
    panel.backgroundColor = [UIColor whiteColor];
    [self addSubview:panel];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(panel.frame.size.width - 85, 0, 70, 25)];
    score.font = [UIFont boldSystemFontOfSize:14];
    score.text = @"SCORE";
    score.textAlignment = NSTextAlignmentRight;
    [panel addSubview:score];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(panel.frame.size.width - 65, 20, 50, 25)];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", points];
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.textColor = [UIColor redColor];
    self.scoreLabel.font = [UIFont systemFontOfSize:24];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;

    [panel addSubview:self.scoreLabel];
    
    UILabel *best = [[UILabel alloc] initWithFrame:CGRectMake(panel.frame.size.width - 85, self.scoreLabel.frame.size.height + self.scoreLabel.frame.origin.y + 20, 70, 25)];
    best.font = [UIFont boldSystemFontOfSize:14];
    best.text = @"BEST";
    best.textAlignment = NSTextAlignmentRight;
    [panel addSubview:best];
    
    self.highscoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(panel.frame.size.width - 65, best.frame.size.height + best.frame.origin.y + 20, 50, 25)];
    NSInteger highscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"best"];
    self.highscoreLabel.text = [NSString stringWithFormat:@"%ld", highscore];
    self.highscoreLabel.backgroundColor = [UIColor clearColor];
    self.highscoreLabel.textColor = [UIColor redColor];
    self.highscoreLabel.font = [UIFont systemFontOfSize:24];
    
    panel.layer.cornerRadius = 2.0f;
    panel.clipsToBounds = YES;
    self.highscoreLabel.textAlignment = NSTextAlignmentRight;
    
    [panel addSubview:self.highscoreLabel];
    
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [retryButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    [retryButton addTarget:self action:@selector(retryTapped) forControlEvents:UIControlEventTouchUpInside];
    retryButton.center = CGPointMake(frame.size.width / 2, frame.size.height * .95);
    [self addSubview:retryButton];

    return self;
}

- (void)retryTapped {
    [self.delegate retryTapped];
}

@end

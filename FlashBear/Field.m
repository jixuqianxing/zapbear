//
//  Field.m
//  FlashBear
//
//  Created by quantum on 24/08/2015.
//  Copyright (c) 2015 Quantum Productions. All rights reserved.
//

#import "Field.h"
#import "FlashStage.h"
#import "RedFlashStage.h"
#import "StormStage.h"
#import "ZapStage.h"
#import "RedZapStage.h"
#import "ThunderStruck.h"
#import "RedThunderStruck.h"
#import "Colors.h"

@implementation Field

- (void)start {
    [self showStorm];
    self.timer = [NSTimer timerWithTimeInterval:.016 target:self selector:@selector(loop) userInfo:nil repeats:true] ;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (id)initWithVC:(UIViewController *)vc {
    self = [super init];
    self.vc = vc;
    self.bear = [[Bear alloc] initWithFrame:CGRectMake(0, 0, 200, 332)];
    size = [[UIScreen mainScreen] bounds].size;
    [self.bear setSize:size];
    [self.bear plantBearOnGround];
    [self.view addSubview:self.bear];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
    self.label.textColor = [Colors bg];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:self.label];
    self.scorer = [[Scorer alloc] init];

    self.soundPlayer = [[SoundPlayer alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showScores) name:@"showscores" object:nil];
    
    return self;
}

- (void)scoreLoop {
    self.label.text = [self.scorer description];
}

- (void)loop {
    [self.stage loop];
    [self scoreLoop];
}

- (void)showLightning {
    if ([self.scorer advanced]) {
        int r = arc4random() % 2;
        if (r == 0) {
            self.stage = [[FlashStage alloc] initWithField:self];
        } else {
            self.stage = [[RedFlashStage alloc] initWithField:self];
        }
    } else {
        self.stage = [[FlashStage alloc] initWithField:self];
    }
}

- (void)showStorm {
    if (self.stage.class == [ZapStage class] || self.stage.class == [RedZapStage class]) {
        ZapStage *z = (ZapStage *)self.stage;
        [z.lightning removeFromSuperview];
        z.lightning = nil;
    }
    self.stage = [[StormStage alloc] initWithField:self];
}

- (void)showZap {
    if ([self.stage class] == [FlashStage class]) {
        self.stage = [[ZapStage alloc] initWithField:self];
    } else {
        self.stage = [[RedZapStage alloc] initWithField:self];
    }
   
}

- (void)touchBegan {
    [self.soundPlayer playJump];
    [self.stage touchBegan];
}

- (UIView *)view {
    return self.vc.view;
}

- (bool)shouldStrikeBear:(Lightning *)l {
    bool bearOnLeft = self.bear.center.x < size.width / 2;
    bool lightningLeft = l.latest.x < size.width / 2;
    
    if (lightningLeft && bearOnLeft) {
        return true;
    } else if (!lightningLeft && !bearOnLeft) {
        return true;
    }
    return false;
}

- (void)thunderStruck:(Lightning *)l {
    if ([l advanced]) {
        self.stage = [[RedThunderStruck alloc] initWithField:self lightning:l];
    } else {
        self.stage = [[ThunderStruck alloc] initWithField:self lightning:l];
    }
    
}

- (void)scoreTapped {
    
    
}

- (NSArray *)scores {
    GKScore *pts = [[GKScore alloc] initWithLeaderboardIdentifier:@"flashbear_storm_survival"];
    pts.value = [self.scorer points];
    NSLog([NSString stringWithFormat:@"%lld", pts.value]);
    return @[pts];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self.vc dismissViewControllerAnimated:false completion:^{
        
    }];
    
}

- (void)authenticateLocalPlayer {
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
    };
}

- (void)reportScores {
    self.scoresToReport = [self scores];
    for (GKScore *s in self.scoresToReport) {
        NSLog(@"score: %lld", s.value);
    }
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated) {
        [GKScore reportScores:self.scoresToReport withCompletionHandler:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];

    } else {
        [self authenticateLocalPlayer];
    }
}

- (void)showScores {
    [self showGameCenter];
}

- (void)showGameCenter {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        [self.vc presentViewController:gameCenterController animated:false completion:^{
            
        }];
    } else {
        
    }
}

@end

//
//  Menu.h
//  FlashBear
//
//  Created by quantum on 27/06/2015.
//  CopyrighT (c) 2015 Quantum Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuDelegate <NSObject>

- (void)scoreTapped;

@end

@interface Menu : UIView {
    NSInteger points;
    int best;
    int scored;
    NSInteger score;
}

@property (strong, nonatomic) UILabel *lightningLabel;
@property (strong, nonatomic) UILabel *deadBearLabel;
@property (strong, nonatomic) UILabel *highscoreLabel;
@property (strong, nonatomic) UILabel *scoreLabel;

@property (nonatomic, assign) id <MenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame points:(NSInteger)pts;

@end

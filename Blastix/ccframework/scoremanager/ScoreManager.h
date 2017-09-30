//
//  ScoreManager.h
//  fruitGame
//
//  Created by KCU on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLDatabase.h"

@interface ScoreManager : NSObject {
	SQLDatabase*	m_sqlManager;
}

+ (ScoreManager*) sharedScoreManager;
+ (void) releaseScoreManager;

- (id) init;
- (NSArray*) loadAllSpeedScore;
- (NSArray*) loadAllQuickScore;
- (NSArray*) loadAllTimeScore;

- (void) submitSpeedScore: (NSString*) scoreName score: (int) score;
- (void) submitQuickScore: (NSString*) scoreName score: (int) score;
- (void) submitTimeScore: (NSString*) scoreName score: (int) score;

- (BOOL) isTop5ForSpeedScore: (int) score;
- (BOOL) isTop5ForQuickScore: (int) score;
- (BOOL) isTop5ForTimeScore: (int) score;

- (void) resetScore;
- (int) topScoreValue;
@end

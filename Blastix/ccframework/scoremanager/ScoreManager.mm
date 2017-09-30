//
//  ScoreManager.m
//  fruitGame
//
//  Created by KCU on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreManager.h"

#define kDataBaseName	@"score.SQLite"

@implementation ScoreManager

static ScoreManager *_sharedScore = nil;

+ (ScoreManager*) sharedScoreManager 
{
	if (!_sharedScore) 
	{
		_sharedScore = [[ScoreManager alloc] init];
	}
	
	return _sharedScore;
}

+ (void) releaseScoreManager 
{
	if (_sharedScore) 
	{
		[_sharedScore release];
		_sharedScore = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
		m_sqlManager = [[SQLDatabase alloc] init];
		[m_sqlManager initWithDynamicFile: kDataBaseName];
	}
	
	return self;
}

- (NSArray*) loadAllSpeedScore
{
	return [m_sqlManager lookupAllForSQL: @"select * from tbl_speedscore order by score desc limit 10"];
}

- (NSArray*) loadAllQuickScore
{
	return [m_sqlManager lookupAllForSQL: @"select * from tbl_quickscore order by score desc limit 10"];
}

- (NSArray*) loadAllTimeScore
{
	return [m_sqlManager lookupAllForSQL: @"select * from tbl_timescore order by score desc limit 10"];
}

- (void) resetScore
{
	[m_sqlManager runDynamicSQL: @"delete from tbl_speedscore" forTable: @"tbl_speedscore"];	
	[m_sqlManager runDynamicSQL: @"delete from tbl_quickscore" forTable: @"tbl_quickscore"];	
	[m_sqlManager runDynamicSQL: @"delete from tbl_timescore" forTable: @"tbl_timescore"];	
}

- (int) topScoreValue
{
	NSArray* scoreArray = [[self loadAllQuickScore] retain];
	if ([scoreArray count] <= 0)
		return 0;
	
	NSDictionary* item = [scoreArray objectAtIndex:0];
	NSString* score = [item objectForKey: @"score"];
	return [score intValue];
}

- (void) submitSpeedScore: (NSString*) scoreName score: (int) score  
{
	NSMutableString* strSQL = [[NSMutableString alloc] init];	
	[strSQL appendFormat: @"insert into '%@'('name', 'score', 'add_date') values(", @"tbl_speedscore"];
	[strSQL appendFormat: @"'%@',", scoreName];
	[strSQL appendFormat: @"%d,", score];
	[strSQL appendFormat: @"'%@')", @""];
	
	[m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_speedscore"];	
	[strSQL release];
}

- (void) submitQuickScore: (NSString*) scoreName score: (int) score
{
	NSMutableString* strSQL = [[NSMutableString alloc] init];	
	[strSQL appendFormat: @"insert into '%@'('name', 'score', 'add_date') values(", @"tbl_quickscore"];
	[strSQL appendFormat: @"'%@',", scoreName];
	[strSQL appendFormat: @"%d,", score];
	[strSQL appendFormat: @"'%@')", @""];
	
	[m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_quickscore"];	
	[strSQL release];
}

- (void) submitTimeScore: (NSString*) scoreName score: (int) score
{
	NSMutableString* strSQL = [[NSMutableString alloc] init];	
	[strSQL appendFormat: @"insert into '%@'('name', 'score', 'add_date') values(", @"tbl_timescore"];
	[strSQL appendFormat: @"'%@',", scoreName];
	[strSQL appendFormat: @"%d,", score];
	[strSQL appendFormat: @"'%@')", @""];
	
	[m_sqlManager runDynamicSQL: strSQL forTable: @"tbl_timescore"];	
	[strSQL release];
}

- (BOOL) isTop5ForSpeedScore: (int) score
{
	NSArray* scoreArray = [m_sqlManager lookupAllForSQL: [NSString stringWithFormat: @"select * from tbl_speedscore where score>%d", score]];
	if ([scoreArray count] >= 10)
		return NO;
	return YES;
}

- (BOOL) isTop5ForQuickScore: (int) score
{
	NSArray* scoreArray = [m_sqlManager lookupAllForSQL: [NSString stringWithFormat: @"select * from tbl_quickscore where score>%d", score]];
	if ([scoreArray count] >= 10)
		return NO;
	return YES;
}

- (BOOL) isTop5ForTimeScore: (int) score
{
	NSArray* scoreArray = [m_sqlManager lookupAllForSQL: [NSString stringWithFormat: @"select * from tbl_timescore where score>%d", score]];
	if ([scoreArray count] >= 10)
		return NO;
	return YES;
}

- (void) dealloc
{
	[m_sqlManager release];
	[super dealloc];
}
@end

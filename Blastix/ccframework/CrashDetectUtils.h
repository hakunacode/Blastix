//
//  CrashDetectUtils.h
//  crashGame
//
//  Created by KCU on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CRASH_WAY
{
	CRASH_NO = -1,
	CRASH_LEFT,
	CRASH_RIGHT,
	CRASH_TOP,
	CRASH_BOTTOM,
	CRASH_YES
} ;

class CrashDetectUtils 
{
public:
	static float CalcLapRectAndRect(CGRect rtOrg, CGRect rtDest);
	static float CalcDistanceWithLinePoint(float x1, float y1, float x2, float y2, float x3, float y3);
	static int DetectRectAndRect(CGRect rtOrg, CGRect rtDest);
	static int DetectCircleAndRect(CGPoint ptOrg, float r, CGRect rtDest);
	static int DetectCircleAndCircle(CGPoint ptOrg, float nOrgR, CGRect ptDest, float nDestR);
	static BOOL DetectRectAndXY(CGRect rect, float x, float y);	
};

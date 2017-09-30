//
//  CrashDetectUtils.m
//  crashGame
//
//  Created by KCU on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "CrashDetectUtils.h"


/**
 * rtOrg:	rect of source object
 * rtDest:	rect of destination object
 */
int CrashDetectUtils::DetectRectAndRect(CGRect rtOrg, CGRect rtDest) 
{
	float fSX = rtOrg.origin.x + CGRectGetWidth(rtOrg)/2;
	float fSY = rtOrg.origin.y + CGRectGetHeight(rtOrg)/2;
	float fSXD = CGRectGetWidth(rtOrg)/2;
	float fSYD = CGRectGetHeight(rtOrg)/2;

	float fTX = rtDest.origin.x + CGRectGetWidth(rtDest)/2;
	float fTY = rtDest.origin.y + CGRectGetHeight(rtDest)/2;
	float fTXD = CGRectGetWidth(rtDest)/2;
	float fTYD = CGRectGetHeight(rtDest)/2;
	
	if ( (fabs(fSX-fTX)-fSXD-fTXD) < 0 &&
		 (fabs(fSY-fTY)-fSYD-fTYD) < 0 )
		return CRASH_YES;
	
	return CRASH_NO;
}

/**
 * rtOrg:	rect of source object
 * rtDest:	rect of destination object
 */
float CrashDetectUtils::CalcLapRectAndRect(CGRect rtOrg, CGRect rtDest) 
{
	float fSX = rtOrg.origin.x + CGRectGetWidth(rtOrg)/2;
	float fSY = rtOrg.origin.y + CGRectGetHeight(rtOrg)/2;
	float fSXD = CGRectGetWidth(rtOrg)/2;
	float fSYD = CGRectGetHeight(rtOrg)/2;
	
	float fTX = rtDest.origin.x + CGRectGetWidth(rtDest)/2;
	float fTY = rtDest.origin.y + CGRectGetHeight(rtDest)/2;
	float fTXD = CGRectGetWidth(rtDest)/2;
	float fTYD = CGRectGetHeight(rtDest)/2;
	
	if ( (fabs(fSX-fTX)-fSXD-fTXD) < 0 &&
		(fabs(fSY-fTY)-fSYD-fTYD) < 0 )
		return (fSX - fTX);
	
	return 1000.0f;
}

BOOL CrashDetectUtils::DetectRectAndXY(CGRect rect, float x, float y)
{
	float left = rect.origin.x;
	float top = rect.origin.y;
	float right = rect.origin.x + CGRectGetWidth(rect);
	float bottom = rect.origin.y + CGRectGetHeight(rect);
	
	if (x > left && x < right &&
		y < top && y > bottom)
		return YES;
	
	return NO;
}

float CrashDetectUtils::CalcDistanceWithLinePoint(float x1, float y1, float x2, float y2, float x3, float y3)
{
	float px = x2-x1;
    float py = y2-y1;
	
    float something = px*px + py*py;
	
    float u =  ((x3 - x1) * px + (y3 - y1) * py) / something;
	
    if ( u > 1 )
        u = 1;
	else if (u < 0)
        u = 0;
		
	float x = x1 + u * px;
	float y = y1 + u * py;
		
	float dx = x - x3;
	float dy = y - y3;
		
	return sqrt(dx*dx + dy*dy);
}

int CrashDetectUtils::DetectCircleAndRect(CGPoint ptOrg, float r, CGRect rtDest)
{
	float left = rtDest.origin.x;
	float top = rtDest.origin.y;
	float right = rtDest.origin.x + rtDest.size.width;
	float bottom = rtDest.origin.y + rtDest.size.height;
	
	float x = ptOrg.x;
	float y = ptOrg.y;
	
	//TOP LINE DETECT
	float fDistance = CalcDistanceWithLinePoint(left, top, right, top, x, y);
	if (fDistance <= r)
		return CRASH_TOP;
		
	//LEFT LINE DETECT
	fDistance = CalcDistanceWithLinePoint(left, top, left, bottom, x, y);
	if (fDistance <= r)
		return CRASH_LEFT;

	//BOTTOM LINE DETECT
	fDistance = CalcDistanceWithLinePoint(left, bottom, right, bottom, x, y);
	if (fDistance <= r)
		return CRASH_BOTTOM;
	
	//RIGHT LINE DETECT
	fDistance = CalcDistanceWithLinePoint(right, top, right, bottom, x, y);
	if (fDistance <= r)
		return CRASH_RIGHT;
	
	return CRASH_NO;
}

int CrashDetectUtils::DetectCircleAndCircle(CGPoint ptOrg, float nOrgR,  CGRect ptDest, float nDestR)
{
	return CRASH_NO;
}



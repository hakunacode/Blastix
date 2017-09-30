//
//  ResourceManager.h
//  glideGame
//
//  Created by KCU on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#ifndef RESOURCEMANAGER_H
#define RESOURCEMANAGER_H

enum TEXTURE_ID
{
	TEXTURE_COUNT
};

@interface ResourceManager2 : NSObject 
{
	CCSprite* textures[TEXTURE_COUNT];
}

+ (ResourceManager2*) sharedResourceManager;
+ (void) releaseResourceManager;

- (id) init;

- (void) loadLoadingData ;

- (void) loadData: (NSString*) strName;

- (void) unloadData: (NSString*) strName;

- (CCSprite*) getTextureWithName: (NSString*) textureName;
- (CCSprite*) getSpriteWithName: (NSString*) strSpriteName;
- (CCSpriteFrame*) getSpriteFrameWithName:(NSString*) frameName;

- (CCSprite*) getTextureWithId: (int) textureId;
- (NSString*) makeFileName: (NSString*)name ext: (NSString*) ext;
@end

#endif

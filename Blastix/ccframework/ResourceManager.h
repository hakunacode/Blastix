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

@interface ResourceManager : NSObject {
	CCSprite* textures[TEXTURE_COUNT];
	
	CCLabelBMFont* font;
	CCLabelBMFont* font30;
	CCLabelBMFont* shadowFont;
}

@property (nonatomic, retain) CCLabelBMFont* font;
@property (nonatomic, retain) CCLabelBMFont* font30;
@property (nonatomic, retain) CCLabelBMFont* shadowFont;

+ (ResourceManager*) sharedResourceManager;
+ (void) releaseResourceManager;

- (id) init;
- (void) loadLoadingData ;
- (void) loadData;

- (CCSprite*) getTextureWithId: (int) textureId;
- (CCSprite*) getTextureWithName: (NSString*) textureName;

@end

#endif

//
//  ZCMeiziRealm.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/13.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Realm/Realm.h>
#import "ZCMeiziDetailStringRealm.h"

@interface ZCMeiziRealm : RLMObject

@property NSString *meiziTitle;
@property NSString *meiziUrl;
@property NSString *meiziImageUrl;

@property RLMArray<ZCMeiziDetailStringRealm> *allMeiziImgUrl;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ZCMeiziRealm>
RLM_ARRAY_TYPE(ZCMeiziRealm)

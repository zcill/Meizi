//
//  ZCMeiziDetailStringRealm.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/16.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Realm/Realm.h>

@interface ZCMeiziDetailStringRealm : RLMObject

@property NSString *imgUrlString;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ZCMeiziDetailStringRealm>
RLM_ARRAY_TYPE(ZCMeiziDetailStringRealm)

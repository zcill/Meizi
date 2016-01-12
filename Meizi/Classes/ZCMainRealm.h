//
//  ZCMainRealm.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/12.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Realm/Realm.h>

@interface ZCMainRealm : RLMObject



@end

// This protocol enables typed collections. i.e.:
// RLMArray<ZCMainRealm>
RLM_ARRAY_TYPE(ZCMainRealm)

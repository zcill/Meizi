//
//  ZCMeiziPageTagRealm.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/14.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Realm/Realm.h>

@interface ZCMeiziPageTagRealm : RLMObject

@property NSString *tagDate;
@property NSInteger page;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ZCMeiziPageTagRealm>
RLM_ARRAY_TYPE(ZCMeiziPageTagRealm)

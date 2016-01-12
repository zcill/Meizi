//
//  ZCMeiziRealm.h
//  Meizi
//
//  Created by 朱立焜 on 16/1/13.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Realm/Realm.h>

@interface ZCMeiziRealm : RLMObject

@property (nonatomic, copy) NSString *meiziTitle;
@property (nonatomic, copy) NSString *meiziUrl;
@property (nonatomic, copy) NSString *meiziImageUrl;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ZCMeiziRealm>
RLM_ARRAY_TYPE(ZCMeiziRealm)

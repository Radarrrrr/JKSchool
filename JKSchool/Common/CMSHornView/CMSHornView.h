//
//  CMSHornView.h
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DDTimer.h"

@interface CMSHornView : UIView <DDTimerDelegate> {
    
}

@property (nonatomic, copy) NSArray *hornDatas;     //轮播图数据源，结构为 [{"link_word":"xxx", "link_url":"xxx"},...]


@end

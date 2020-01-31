//
//  ScrollCell.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "ScrollCell.h"

@interface ScrollCell ()

@property (nonatomic, strong) DDImagePageScrollView *circleView;
@property (nonatomic, copy) NSArray *dataArray;

@end


@implementation ScrollCell

- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //add _circleView
    float w = SCR_WIDTH-20;
    float h = (120.0/335.0)*w;
    
    self.circleView = [[DDImagePageScrollView alloc] initWithFrame:CGRectMake(10, 0, w, h)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.delegate = self;
    _circleView.roundRectEnabled = YES;
    _circleView.cacheEnabled = YES;
    _circleView.tapEnabled = YES;
    _circleView.zoomEnabled = NO;
    _circleView.pageCtrlEnabled = YES;
    _circleView.ignoreMemory = YES;
    _circleView.circleEnabled = YES;
    _circleView.autoPlayTimeInterval = 3;
    _circleView.pageCtrl.pageIndicatorTintColor = COLOR(@"#00B9AA");
    _circleView.pageCtrl.currentPageIndicatorTintColor = COLOR(@"#005E56");
    [self.contentView addSubview:_circleView];
    
}
- (NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
//[
//    {
//        id = 26;
//        img = "https://www.cdhhrs.com/uploads/Advertise/20190218220408.jpg";
//        "small_img" = "https://www.cdhhrs.com/uploads/Advertise/thumb/20190218220408.jpg";
//        title = "\U5f00\U5b66\U90a3\U70b9\U4e8b\Uff1a\U4ece\U9884\U9632\U4f20\U67d3\U75c5\U5f00\U59cb";
//        weight = 96;
//    },
//    {
//        id = 22;
//        img = "https://www.cdhhrs.com/uploads/Advertise/20181207185438.png";
//        "small_img" = "https://www.cdhhrs.com/uploads/Advertise/thumb/20181207185438.png";
//        title = "\U627f\U5fb7\U5e02\U5b66\U6821\U548c\U6258\U5e7c\U673a\U6784\U4f20\U67d3\U75c5\U548c\U7a81\U53d1\U516c\U5171\U536b\U751f\U4e8b\U4ef6\U9632\U63a7\U5de5\U4f5c\U6307\U5357";
//        weight = 97;
//    },
//    ...
//]
    
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    if(ARRAYVALID(data))
    {
        self.dataArray = (NSArray*)data;
        
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in _dataArray)
        {
            if(DICTIONARYVALID(dic))
            {
                NSString *img_url = [dic objectForKey:@"img"];
                if(STRVALID(img_url))
                {
                    [urls addObject:img_url];
                }
            }
        }
        
        [_circleView refreshPagesForImageURLs:urls startIndex:0];
    }
    
    float w = SCR_WIDTH-20;
    float h = (120.0/335.0)*w;
    
    return [NSNumber numberWithFloat:h];
}


//DDImagePageScrollViewDelegate
- (void)ddImagePageScrollViewDidTapInPage:(DDImagePageScrollView*)pageScrollView pageIndex:(NSInteger)index atPoint:(CGPoint)atPoint pageImage:(UIImage*)image pageImageURL:(NSString*)imageURL
{
    NSDictionary *dict = [_dataArray objectAtIndex:index]; 
    NSNumber *circleID = [dict objectForKey:@"id"];
    
    NSString *circle_id = [circleID stringValue];
    
    //对接JKCenter直接跳转
    NSString *linkUrl = [NSString stringWithFormat:@"topic://id=%@", circle_id];
    [DDCenter actionForLinkURL:linkUrl];
}


@end

// The MIT License (MIT)
//
// Copyright (c) 2015-2016 RamWire ( https://github.com/RamWire )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "NinaBaseView.h"
#import "UIParameter.h"

@implementation NinaBaseView
{
    UIView *lineBottom;
    UIView *topTabBottomLine;
    
    NSMutableArray *topTabArray;
    NSMutableArray *bottomLineWidthArray;
    NSInteger topTabType;
    UIView *ninaMaskView;
}
@synthesize btnArray;

- (instancetype)initWithFrame:(CGRect)frame WithTopTabType:(NSInteger)topTabNum
{
    self = [super initWithFrame:frame];
    topTabType = topTabNum;
    return self;
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self baseViewLoadData];
}

- (void)setTopTabHiddenEnable:(BOOL)topTabHiddenEnable {
    _topTabHiddenEnable = topTabHiddenEnable;
    CGFloat minusDistance = _topTabHiddenEnable?_topHeight:0;
    [UIView animateWithDuration:0.3 animations:^{
        self.topTab.frame = CGRectMake(0, 0 - minusDistance, FUll_VIEW_WIDTH, self.topHeight);
        self.scrollView.frame = CGRectMake(0, self.topHeight - minusDistance, FUll_VIEW_WIDTH, self.frame.size.height - (self.topHeight - minusDistance));
    }];
}

- (void)reloadTabItems:(NSArray *)newTitles {
    self.titleArray = newTitles;
    for (UIView *subView in self.topTab.subviews) {
        [subView removeFromSuperview];
    }
    _scrollView.contentOffset = CGPointMake(0, 0);
    _topTab.contentOffset = CGPointMake(0, 0);
    [self updateScrollViewUI];
    [self updateTopTabUI];
    [self initUI];
}

- (void)reloadTabTItles:(NSArray *)items
{
    
}

#pragma mark - LazyLoad
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.tag = 318;
//        _scrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        [self updateScrollViewUI];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        _topTab.delegate = self;
        if (_topTabColor) {
            _topTab.backgroundColor = _topTabColor;
        }else {
            _topTab.backgroundColor = [UIColor whiteColor];
        }
        _topTab.tag = 917;
        _topTab.scrollEnabled = YES;
        _topTab.alwaysBounceHorizontal = YES;
        _topTab.showsHorizontalScrollIndicator = NO;
        _topTab.showsVerticalScrollIndicator = NO;
        _topTab.bounces = NO;
        _topTab.scrollsToTop = NO;
        _topTab.layer.masksToBounds = NO;
        [self updateTopTabUI];
        if (@available(iOS 11.0, *)) {
            _topTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _topTab;
}

#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(FUll_VIEW_WIDTH * button.tag, 0) animated:YES];
    self.currentPage = (FUll_VIEW_WIDTH * button.tag + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        self.currentPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        NSInteger yourPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
//        CGFloat yourCount = 1.0 / _titleArray.count;
//        if (_titleArray.count > 5) {
//            yourCount = 1.0 / 5.0;
//        }
//        if (yourPage > 0) {
//               lineBottom.frame = CGRectMake(<#CGFloat x#>, lineBottom.frame.origin.y, lineBottom.frame.size.width, lineBottom.frame.size.height);
//        }
        float progress =  (scrollView.contentOffset.x - yourPage  * FUll_VIEW_WIDTH)/FUll_VIEW_WIDTH;
        if (progress <= 0 && yourPage == 0) {
          
        }else {
//            NSLog(@"%f",progress);
            if (progress >= 0) {
                if (yourPage + 1 < btnArray.count ) {
                    UIButton * first = btnArray[yourPage];
                    UIButton * second = btnArray[yourPage + 1];
                    lineBottom.center = CGPointMake(first.center.x  + (second.center.x - first.center.x) * progress, lineBottom.center.y)  ;
                }
               
                
            }else {
                UIButton * first = btnArray[yourPage - 1];
                UIButton * second = btnArray[yourPage];
                lineBottom.center = CGPointMake(second.center.x  + (second.center.x - first.center.x) * progress , lineBottom.center.y)  ;
            }
        }
        
        
//        UIButton * lastButton =  btnArray[yourPage];
//
//        yourPage
//
//
        
//        NSLog(@"yourPage %d",yourPage);
        
//        if (_autoFitTitleLine) {
//            _bottomLinePer = [bottomLineWidthArray[yourPage] floatValue] / (FUll_VIEW_WIDTH * yourCount);
//        }
//        CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -_bottomLinePer) / 2;
//        if (topTabType == 1) {
//            CGPoint maskCenter = ninaMaskView.center;
//            if (_titleArray.count >= 5) {
//                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * 0.2);
//            }else {
//                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * yourCount);
//            }
//            ninaMaskView.center = maskCenter;
//        }
//        if (_titleArray.count > 5) {
//            switch (topTabType) {
//                case 0:
//                    if (_bottomLineHeight >= 3) {
//                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, _topHeight - 3, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, 3);
//                        break;
//                    }
//                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, _topHeight - _bottomLineHeight, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, _bottomLineHeight);
//                    break;
//                case 1:
//                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, (_topHeight - _blockHeight) / 2.0, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, _blockHeight);
//                    break;
//                default:
//                    break;
//            }
//        }else {
//            switch (topTabType) {
//                case 0:
//                    if (_bottomLineHeight >= 3) {
//                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / _titleArray.count + lineBottomDis, _topHeight - 3, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, 3);
//                    }else {
//                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / _titleArray.count + lineBottomDis, _topHeight - _bottomLineHeight, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, _bottomLineHeight);
//                    }
//                    break;
//                case 1:
//                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / _titleArray.count + lineBottomDis, (_topHeight - _blockHeight) / 2.0, yourCount * FUll_VIEW_WIDTH * _bottomLinePer, _blockHeight);
//                    break;
//                default:
//                    break;
//            }
//        }
        for (NSInteger i = 0;  i < btnArray.count; i++) {
            if (topTabType == 0 || topTabType == 2) {
                if (_btnUnSelectColor) {
                    [btnArray[i] setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
                }else {
                    [btnArray[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
                if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count && (topTabType == 0 || topTabType == 2)) {
                    UIView *customTopView = _topArray[i];
                    UIButton *customTopButton = btnArray[i];
                    for (NSInteger i = [customTopButton.subviews count] - 1; i>=0; i--) {
                        if ([[customTopButton.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
                            [[customTopButton.subviews objectAtIndex:i] removeFromSuperview];
                        }
                    }
                    customTopView.frame = customTopButton.bounds;
                    customTopView.userInteractionEnabled = NO;
                    customTopView.exclusiveTouch = NO;
                    [customTopButton addSubview:customTopView];
                }
            }
            UIButton *changeButton = btnArray[i];
            [UIView animateWithDuration:0.3 animations:^{
                changeButton.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
        if (topTabType == 0 || topTabType == 2) {
            if (_btnSelectColor) {
                [btnArray[yourPage] setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            }else {
                [btnArray[yourPage] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count) {
                UIButton *customTopButton = btnArray[yourPage];
                for (NSInteger i = [customTopButton.subviews count] - 1; i>=0; i--) {
                    if ([[customTopButton.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
                        [[customTopButton.subviews objectAtIndex:i] removeFromSuperview];
                    }
                }
                if (![customTopButton.subviews isKindOfClass:[UIView class]]) {
                    UIView *whites = _changeTopArray[yourPage];
                    whites.frame = customTopButton.bounds;
                    whites.userInteractionEnabled = NO;
                    whites.exclusiveTouch = NO;
                    [btnArray[yourPage] addSubview:whites];
                }
            }
            UIButton *changeButton = btnArray[yourPage];
            if (_titleScale > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(self.titleScale, self.titleScale);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                }];
            }
            
        }
    }
}

#pragma mark - Load scrollview and toptab
- (void)updateScrollViewUI {
    _scrollView.contentSize = CGSizeMake(FUll_VIEW_WIDTH * _titleArray.count, 0);
    if (!_slideEnabled) {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)updateTopTabUI {
    CGFloat additionCount = 0;
    if (_titleArray.count > 5) {
        additionCount = (_titleArray.count - 5.0) / 5.0;
    }
  
    btnArray = [NSMutableArray array];
    bottomLineWidthArray = [NSMutableArray array];
    topTabArray = [NSMutableArray array];
    UIButton * lastButton = nil;
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.layer.anchorPoint = CGPointMake(0.5, 0.8);
        if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count && (topTabType == 0 || topTabType == 2)) {
            UIView *customTopView = _topArray[i];
            if (i == 0) {
                button.frame = CGRectMake(self.leftMargin, 0, customTopView.frame.size.width, _topHeight);
            }else {
                button.frame = CGRectMake(lastButton.frame.origin.x + lastButton.frame.size.width + self.itemInterval, 0, customTopView.frame.size.width, _topHeight);
            }

          
            customTopView.frame = button.bounds;
            customTopView.userInteractionEnabled = NO;
            customTopView.exclusiveTouch = NO;
            [topTabArray addObject:customTopView];
            [button addSubview:customTopView];
            lastButton = button;
        }else {
            button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
            if ([_titleArray[i] isKindOfClass:[NSString class]]) {
                [bottomLineWidthArray addObject:[NSString stringWithFormat:@"%f",[_titleArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_titlesFont]}].width]];
                [button setTitle:_titleArray[i] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 0;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
            }else {
                NSLog(@"Your title%li not fit for topTab,please correct it to NSString!",(long)i + 1);
            }
        }
        [_topTab addSubview:button];
        [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:button];
        if (i == 0 && (topTabType == 0 || topTabType == 2)) {
            if (_btnSelectColor) {
                [button setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            }else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            if (_titleScale > 0) {
                button.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
            }
            if (_topArray.count == _titleArray.count && _changeTopArray.count == _titleArray.count) {
                for (NSInteger i = [button.subviews count] - 1; i >= 0; i--) {
                    if ([[button.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
                        [[button.subviews objectAtIndex:i] removeFromSuperview];
                    }
                }
                if (![button.subviews isKindOfClass:[UIView class]]) {
                    UIView *whites = _changeTopArray[0];
                    whites.frame = button.bounds;
                    whites.userInteractionEnabled = NO;
                    whites.exclusiveTouch = NO;
                    [btnArray[0] addSubview:whites];
                }
            }
        } else {
            if (_btnUnSelectColor) {
                [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
            }else {
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    if (btnArray.count > 0) {
       UIButton * selectbutton =  [btnArray objectAtIndex:self.currentPage];
        if (_titleScale > 0) {
                selectbutton.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
        }
    }
    
    //Create Toptab underline.
    if (!_topTabUnderLineHidden) {
        topTabBottomLine = [UIView new];
        topTabBottomLine.backgroundColor = UIColorFromRGB(0x5f6379);
        [_topTab addSubview:topTabBottomLine];
    }
    //Create Toptab bottomline.
    lineBottom = [UIView new];
    if (_underlineBlockColor) {
        lineBottom.backgroundColor = _underlineBlockColor;
    }else {
        lineBottom.backgroundColor = UIColorFromRGB(0xff6262);
    }
    lineBottom.clipsToBounds = YES;
    lineBottom.userInteractionEnabled = YES;
    lineBottom.layer.cornerRadius = 2;
    [_topTab addSubview:lineBottom];
    
    
    if (btnArray.count > 0) {
        UIButton * lastButton = btnArray.lastObject;
        _topTab.contentSize = CGSizeMake(lastButton.frame.origin.x + lastButton.frame.size.width + self.leftMargin,0);
    }
    if (btnArray.count > 0) {
        UIButton * defaultButton = btnArray[_baseDefaultPage];
        if (defaultButton.frame.origin.x > FUll_VIEW_WIDTH/2) {
            _topTab.contentOffset = CGPointMake(defaultButton.center.x, 0);
        }
    }
    
    

    
//    //Create ninaMaskView.
//    if (topTabType == 1) {
//        ninaMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (1 + additionCount) * FUll_VIEW_WIDTH, _blockHeight)];
//        UIView * topOneView = topTabArray[0];
//        if (topOneView) {
//            ninaMaskView.center = CGPointMake(topOneView.center.x, ninaMaskView.center.y);
//        }
//
//        ninaMaskView.backgroundColor = [UIColor clearColor];
//        for (NSInteger j = 0; j < _titleArray.count; j++) {
//            UILabel *maskLabel = [UILabel new];
//            if (_titleArray.count > 5) {
//                maskLabel.frame = CGRectMake(More5LineWidth * j - More5LineWidth * (1 - _bottomLinePer) / 2, 0, More5LineWidth, _blockHeight);
//            }else {
//                maskLabel.frame = CGRectMake(FUll_VIEW_WIDTH / _titleArray.count * j - FUll_VIEW_WIDTH / _titleArray.count * (1 - _bottomLinePer) / 2, 0, FUll_VIEW_WIDTH / _titleArray.count, _blockHeight);
//            }
//            maskLabel.text = _titleArray[j];
//            maskLabel.textColor = _btnSelectColor?_btnSelectColor:[UIColor whiteColor];
//            maskLabel.numberOfLines = 0;
//            maskLabel.textAlignment = NSTextAlignmentCenter;
//            maskLabel.font = [UIFont systemFontOfSize:_titlesFont];
//            [ninaMaskView addSubview:maskLabel];
//        }
//        [lineBottom addSubview:ninaMaskView];
//    }
    if (topTabType == 2) {
        lineBottom.hidden = YES;
    }
}

#pragma mark - LoadData
- (void)baseViewLoadData {
    self.topTab.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, _topHeight);
    self.scrollView.frame = CGRectMake(0, _topHeight, FUll_VIEW_WIDTH, self.frame.size.height - _topHeight);
     [self addSubview:self.scrollView];
    [self addSubview:self.topTab];
   
    [self initUI];
}

- (void)initUI {
    CGFloat yourCount = 1.0 / _titleArray.count;
    CGFloat additionCount = 0;
    if (_titleArray.count > 5) {
        additionCount = (_titleArray.count - 5.0) / 5.0;
        yourCount = 1.0 / 5.0;
    }
//    if (_autoFitTitleLine) {
//        _bottomLinePer = [bottomLineWidthArray[0] floatValue] / (FUll_VIEW_WIDTH * yourCount);
//    }

   
//    CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -_bottomLinePer) / 2;
    NSInteger defaultPage = (_baseDefaultPage > 0 && _baseDefaultPage < _titleArray.count)?_baseDefaultPage:0;
    
    // 设置滑块高度和宽度
    CGFloat width = 30;
    if (_lineBottomWidth > 0) {
        width = _lineBottomWidth;
    }
    CGFloat height = 2;
    if (_blockHeight > 0) {
        height = _blockHeight;
    }
    
    switch (topTabType) {
        case 0:{
            lineBottom.frame = CGRectMake(0, _topHeight - height, width, height);
            if (defaultPage < btnArray.count) {
                UIButton * oneBtn =btnArray[defaultPage];
                if (oneBtn) {
                    lineBottom.center = CGPointMake(oneBtn.center.x,lineBottom.center.y);
                }
            }
            break;
        }
        case 1: {
            lineBottom.frame = CGRectMake(0,_topHeight - height, width, height);
            if (_cornerRadiusRatio > 0) {
                lineBottom.layer.cornerRadius = 1;
            }
            if (defaultPage < btnArray.count) {
                UIButton * oneBtn =btnArray[defaultPage];
                if (oneBtn) {
                     lineBottom.center = CGPointMake(oneBtn.center.x,lineBottom.center.y);
                }
            }
        }
            break;
        default:
            break;
    }
    if (!_topTabUnderLineHidden) {
        if (_topTabUnderLineWidth > 10) {
            CGFloat originX = (FUll_VIEW_WIDTH - _topTabUnderLineWidth) / 2;
            topTabBottomLine.frame = CGRectMake(originX,  _topHeight - 1, _topTabUnderLineWidth, 1);
        } else {
            topTabBottomLine.frame = CGRectMake(0, _topHeight - 1, (1 + additionCount) * FUll_VIEW_WIDTH, 1);
        }
    }
}

@end

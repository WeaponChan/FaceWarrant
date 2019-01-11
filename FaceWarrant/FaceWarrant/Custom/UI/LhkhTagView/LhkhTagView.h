//
//  LhkhTagView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LhkhTag;
@interface LhkhTagView : UIView
@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index, NSString *indexText);

- (void)addTag: (nonnull LhkhTag *)tag;
- (void)insertTag: (nonnull LhkhTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull LhkhTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;
@end

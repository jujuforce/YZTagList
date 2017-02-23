//
//  YZTag.h
//  Pods
//
//  Created by jujuforce on 06/12/16.
//
//

@import Foundation;
@import UIKit;

@interface YZTag : NSObject

@property (nonatomic) id _Nonnull item;
@property (nonatomic, strong) UIColor* _Nullable color;

- (instancetype _Nonnull)initWithItem:(id _Nonnull)item color:(UIColor* _Nullable)color;

@end

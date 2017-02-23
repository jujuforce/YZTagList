//
//  YZTag.h
//  Pods
//
//  Created by Julien CAMPY on 06/12/16.
//
//

@import Foundation;
@import UIKit;

@interface YZTag : NSObject

@property (nonatomic, strong) NSObject* _Nonnull item;
@property (nonatomic, strong) UIColor* _Nullable color;

- (instancetype _Nonnull)initWithItem:(NSObject * _Nonnull) item color: (UIColor * _Nullable) color;

@end

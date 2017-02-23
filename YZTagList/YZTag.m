//
//  YZTag.m
//  Pods
//
//  Created by Julien CAMPY on 06/12/16.
//
//

#import "YZTag.h"

@implementation YZTag

- (instancetype _Nonnull)initWithItem:(id _Nonnull)item color:(UIColor *_Nullable)color
{
    self = [super init];
    if (self)
    {
        self.item = item;
        self.color = color;
    }
    return self;
}

- (NSString *)description
{
    return [self.item description];
}

@end

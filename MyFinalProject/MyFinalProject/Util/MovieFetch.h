//
//  MovieFetch.h
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieFetch : NSObject
- (NSArray*) startFetching;
- (NSArray *)fetchingWithFilterByMovieID:(NSString*) movieID;
@end

NS_ASSUME_NONNULL_END

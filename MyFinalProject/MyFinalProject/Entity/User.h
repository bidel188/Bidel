//
//  User.h
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/17/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* email;
@property (strong,nonatomic) NSString* gender;
@property (strong,nonatomic) NSString* dateOfBirth;
@property (strong,nonatomic) NSData* image;
- (instancetype)initWithName:(NSString*) name andEmail:(NSString*) email andGender:(NSString*) gender andDateOfBirth:(NSString*) dateOfBirth andImage:(NSData*) image;
@end

NS_ASSUME_NONNULL_END

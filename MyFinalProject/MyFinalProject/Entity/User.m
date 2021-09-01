//
//  User.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/17/21.
//

#import "User.h"

@implementation User
@synthesize name,dateOfBirth,email,image,gender;
- (instancetype)initWithName:(NSString *)name andEmail:(NSString *)email andGender:(NSString *)gender andDateOfBirth:(NSString*) dateOfBirth andImage:(NSData *)image{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.dateOfBirth = dateOfBirth;
        self.email = email;
        self.image = image;
        self.gender = gender;
        
    }
    return  self;
    
}
@end

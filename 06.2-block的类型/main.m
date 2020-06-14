//
//  main.m
//  06.2-block的类型
//
//  Created by 刘光强 on 2020/2/5.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

void (^block)(void);

void test() {
    int a = 10;
    
    block = [^{
        NSLog(@"%d", a); // 10
    } copy];
    
    NSLog(@"%@", [block class]); // __NSMallocBlock__
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        test();
        block();
    }
    return 0;
}

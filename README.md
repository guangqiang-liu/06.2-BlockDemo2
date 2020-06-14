# 06.2-block的类型

我们创建一个新工程，然后在`main`函数中创建几个block，在`ARC`环境下运行，代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        void (^block1)(void) = ^{
            NSLog(@"111");
        };
        
        NSLog(@"%@",[block1 class]); // __NSGlobalBlock__
        NSLog(@"%@",[[block1 class] superclass]); // __NSGlobalBlock
        NSLog(@"%@",[[[block1 class] superclass] superclass]); // NSBlock
        NSLog(@"%@",[[[[block1 class] superclass] superclass] superclass]); // NSObject
        
        继承关系：__NSGlobalBlock__ ：__NSGlobalBlock ：NSBlock ：NSObject
        
        int a = 10;
        void (^block2)(void) = ^{
            NSLog(@"%d", a);
        };
        
        NSLog(@"%@", [block1 class]); // __NSGlobalBlock__
        
        NSLog(@"%@", [block2 class]); // __NSMallocBlock__
        
        NSLog(@"%@", [^{
            NSLog(@"%d", a);
        } class]); // __NSStackBlock__
    }
    return 0;
}
```

从上面的代码打印我们可以看出，`block`最终继承自`NSObject`对象，并且我们可以看出打印出的block有三种类型：

* __NSGlobalBlock__
* __NSMallocBlock__
* __NSStackBlock__

接下来我们看这三种block有何区别，后面的代码运行环境我们切换至`MRC`模式

我们修改`main`函数内的代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // block1内部没有访问auto变量
         void (^block1)(void) = ^{
             NSLog(@"111");
         };
         
         NSLog(@"%@", [block1 class]); // __NSGlobalBlock__
        
         int a = 10;
         
         // block2内部访问了auto变量
         void (^block2)(void) = ^{
             NSLog(@"%d", a);
         };
         
         NSLog(@"%@", [block2 class]); // __NSStackBlock__
    }
    return 0;
}
```

从上面的代码我们可以得出结论：

* block1内部没有访问auto变量类型为:__NSGlobalBlock__
* block2内部访问auto变量类型为: __NSStackBlock__

接下来我们继续改造`main`函数中的代码如下：

```
void (^block)(void);

void test() {
    int a = 10;
    
    // block内部访问了auto变量，所以block的内存地址分布在栈上，栈上内存的特点是出了作用域就会销毁
    block = ^{
        NSLog(@"%d", a); // -272632888
    };
    
    NSLog(@"%@", [block class]); // __NSStackBlock__
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // 当执行完test函数后，栈上分配的内存就会销毁
        test();
        
        // 执行block，栈上的内存已经销毁
        block();
    }
    return 0;
}
```

对于block内部有访问到auto变量，最好将block放到堆内存中，因为堆内存是开发者来管理，就不存在提前销毁的情况了

那么如何将栈内存上的block放到堆内存？我们可以对栈上的block进行`copy`操作将其拷贝到堆内存中，上面的代码修改如下：

```
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
```

block的类型总结如下图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200205-162444@2x.png)

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200205-162509@2x.png)


讲解示例Demo地址：[https://github.com/guangqiang-liu/06.2-BlockDemo2]()


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* iOS组件化开发实战项目(500+star)：**[https://github.com/guangqiang-liu/iOS-Component-Pro]()**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习
Java-Config
===========

在前一节的内容当中，我们把 Bean 本身和 Bean 的依赖关系都通过 Annotation 来表达了，然后还是没有彻底去掉 `service.xml` 文件。在这一节我们学习如何彻底去掉对于 XML 文件的依赖，完全使用 Java 代码进行配置。

>Java-Config 最初是用 Spring 的一个扩展，用于支持使用 Java 代码进行 Spring 的配置，后来 Java-Config 得到了官方的支持，被引入到 Spring 当中，成为了 Spring 的一部分。

首先我们需要创建一个配置类，取名为 `AppConfig`：

```java
package com.skyline;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan("com.skyline")
public class AppConfig {
}
```

其中注意 `@Configuration` 这个 Annotation，它是标记配置类的关键。下面的 `@ComponentScan` 和 XML 中 `<context:component-scan>` 是对应的。

然后修改我们使用的 Context：

```java
package com.skyline;

import com.skyline.service.MyServiceImpl;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class MySpringContainer {
    public static void main(String[] args) {
        ApplicationContext context =
                new AnnotationConfigApplicationContext(AppConfig.class);
        MyServiceImpl service = context.getBean("myService", MyServiceImpl.class);
        System.out.println(service.sayHello());
    }
}
```

注意我们使用 `AnnotationConfigApplicationContext` 代替了之前的 `ClassPathXmlApplicationContext`，然后把 `AppConfig.class` 作为参数传给了 Context。

运行程序，得到的结果和之前是一样的，当然现在 `service.xml` 这个文件也可以完全删除掉了。
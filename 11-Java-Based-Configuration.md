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

其中注意 `@Configuration` 是指示该类为 Bean 配置的源头，作用上类似于之前使用的 `service.xml`。只有标记了 `@Configuration` 的类当中才能出现类似 XML 中的 Bean 之间互相依赖关系。这个 Annotation，它也继承自 `@Component`，因此也可以用于自动扫描。下面的 `@ComponentScan` 和 XML 中 `<context:component-scan>` 是对应的。

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

另外，我们也可以直接在 `AppConfig` 当中加入 `@Bean`，不需要再使用 `@Component`，例如我们把 `MyPersonComponent` 中的内容挪到 `AppConfig` 当中：

```java
@Configuration
@ComponentScan("com.skyline")
public class AppConfig {

    @Bean
    public Person aPerson() {
        Person aPerson = new Person();
        aPerson.setName("Chester");
        return aPerson;
    }

    @Bean
    public MyServiceImpl myService() {
        MyServiceImpl service = new MyServiceImpl();
        service.setGreeting("Hello");
        return service;
    }

}
```

注意我们使用了简化的 `@Bean` 定义，Spring 会直接把函数名称 `aPerson` 和 `myService` 作为 Bean 的名称。运行代码，依然可以得到同样的结果。

### Code vs XML

到现在我们已经实现了彻底不依赖 XML 来进行 Spring Container 和 Bean 的配置，用代码配置和用 XML 配置各有什么优缺点呢？这里简单分析一下：

* 使用 XML 的好处在于更新 Bean 之后不需要重新编译代码，同时有利于将若干 Bean 组织在一个文件里，方便集中管理。缺点在于 XML 语法的“噪声”太大，没有工具帮助的情况下书写很繁琐，同时 XML 本身没有很好的类型检查和语法检查机制，使得 XML 也很容易写错。
* 使用代码的好处在于更加简洁清晰，同时不容易出错，缺点在于 Bean 的配置会分散在各个文件当中，以及需要重新编译代码才能更新配置。

从 Spring 本身的发展来看，使用代码（即 Annotation）进行配置逐渐取代了 XML 成为主流的配置方式，到最新的 SpringBoot 框架，XML 已经基本不见踪影。因此本教程后面的内容也将以 Annotation 配置为主，不再使用 XML。
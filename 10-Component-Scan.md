## Component-Scan

在前一节的内容中，我们可以通过 Annotation 来指导 Bean 的依赖关系，然而 Bean 本身的定义还是写在 XML 当中，下面我们介绍一种方法，允许我们直接在代码中创建出 Bean。这种方法被称为 Component-Scan。

首先我们修改 XML 配置，打开 Component-Scan 功能：

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">
    
    <context:component-scan base-package="com.skyline"/>

</beans>
```

>注意我们去掉了所有的 Bean 定义，也同时去掉了 `<context:annotation-config>`，因为 `<context:component-scan>` 默认就会打开 `<context:annotation-config>`，因此不需要再手动设置 `<context:annotation-config>`。

### Component

Spring 中定义了若干用于注册 Bean 的 Annotation，包括 `@Component` 以及继承自 `@Component` 的 `@Service` 和 `@Repository`。所谓的 component-scan 也就是告诉 Spring 去扫描标示了这些 Annotation 的类，将它们用于 Bean 的注册。 Spring 中推荐使用 `@Service` 和 `@Component` 标示逻辑和服务层的组件，使用 `@Repository` 标示持久层的组件。

>`@Service` 和 `@Repository` 都继承自 `@Component`，因此在 Bean 注册的层面，它们没有本质上的区别，不过 `@Repository` 在持久层会有一个 exception 转换的作用，这里先略去不讲。

创建一个新类 MyPersonComponent：

```java
package com.skyline.service;

import com.skyline.model.Person;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
public class MyPersonComponent {

    @Bean("aPerson")
    public Person testPerson() {
        Person aPerson = new Person();
        aPerson.setName("Chester");
        return aPerson;
    }

    @Bean("myService")
    public MyServiceImpl testService() {
        MyServiceImpl service = new MyServiceImpl();
        service.setGreeting("Hello");
        return service;
    }
}
```

可以看到，我们基本就是把原先在 XML 当中的配置，挪到了 Java 代码当中。运行代码，得到和之前一样的结果

>注意到我们的 `MyServiceImpl` 仅仅设置了 greeting，为什么这样就能够正常工作呢？还记得上一节的 `@Autowired` 吗，它依然在发挥自己的作用，帮我们找到了 Person 的实例，并且赋给了 `MyServiceImpl`。



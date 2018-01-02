## 初识 Spring IoC

前面的内容中提到，Spring 是一个非常庞大的框架，SpringMVC 只是其中的一部分。整个 Spring 框架最基础的部分是它的 IoC Container。SpringMVC 本身就是构建在 Spring IoC 之上的。因此要学习 SpringMVC，对于 Spring IoC 的学习也是很重要的一部分。作为上一章内容的延续，这一章的内容可以让我们对于 SpringMVC 的工作原理有着更加深刻的理解。

注：关于 IoC 概念本身的内容，这里不再赘述。如果觉得本章的内容理解起来有难度，可以查询 IoC 和 DI 的有关资料。

### 准备工作

之前的代码中，我们整个工程里是没有 main 函数的。我们所有的代码都是放到 Tomcat 中执行的。这一次为了更加方便快捷的学习 Spring IoC，我们在工程中加入一个 main class，使之直接可以执行。

新建一个类，名为 MySpringContainer，其中加入 main 函数：

```java
package com.skyline;

public class MySpringContainer {
    public static void main(String[] args) {
        System.out.println("Hello");
    }
}
```

在 IDEA 的 Run/Debug Configuration 中新建一个 Application 配置，指定 main class 为刚创建好的 MySpringContainer：

![application](https://raw.githubusercontent.com/skyline75489/Heart-First-JavaWeb/master/img/7-application-config.png)

配置完成之后，可以用 IDEA 启动这个 Java 工程，可以看到对应输出。

另外，为了执行带有 Spring 依赖的应用，我们需要在工程的依赖列表当中引入前面提到的 Apache common-logging 库。

### Spring IoC 初步

前面我们在使用 SpringMVC 时其实已经用到了 Spring IoC 当中的一些内容，例如我们通过在 xml 文件当中进行配置，把 Controller 加入 beans 列表当中，这样 SpringMVC 才找到了我们的 Controller。下面我们进一步从 Spring IoC 的角度看一下它具体的实现过程。

Spring IoC 当中有若干基本概念需要了解一下：

1. Spring 当中的 IoC Container 被称为 **Context**，代码上体现为 `ApplicationContext` 接口。Spring 自带了若干实现，例如 `ClassPathXmlApplicationContext` 和 `FileSystemXmlApplicationContext` 等。
2. Spring 的 Container 依赖于 **Configuration metadata**（配置元数据）去初始化对象。
3. Spring 中把由 Container 管理的对象，称为 **Bean**。

>在 《Java 核心技术(卷2)》中，作者引用了 Sun 公司文档的定义，把可重用的 Java 组件称为 Bean，注意不要和本文的 Bean 定义混淆。

因此 Spring IoC Container 的主要工作就是使用对象的定义，加上 Configuration，生成 Bean。下面用一个例子说明一下。

传统上，也就是早期 Spring 开发的时候，都是使用 XML 配置文件的，这里我们也使用它做例子，后面我们会看到更多非 XML 配置的方法。

首先创建一个接口：

```java
package com.skyline;

public interface MyService {
    String sayHello();
}
```

然后创建一个对应的实现：

```java
package com.skyline;

public class MyServiceImpl implements MyService {

    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String sayHello() {
        return "Hello " + name;
    }
}
```

我们的实现类就是一个简单的 JavaBean，为了初始化它，我们需要 configuration，这个例子里我们使用的是 XML 配置文件。 在 IDEA 的输出文件夹，也就是 `com` 这个文件夹的隔壁，创建一个 `services.xml`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="myService" class="com.skyline.MyServiceImpl">
      <property name="name" value="Chester"/>
    </bean>

</beans>
```

文件夹的结构看起来应该是下面这样：

```plaintext
- com
  - skyline
    - ...
- services.xml
```

在这个 XML 文件中，我们配置了初始化 `MyServiceImpl` 的参数。我们有了对象的定义，和初始化的配置，下面修改我们的 main 函数，让 Container 把它们结合起来，完成最终对象的创建：

```java
package com.skyline;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MySpringContainer {
    public static void main(String[] args) {
        ApplicationContext context =
                new ClassPathXmlApplicationContext("services.xml");
        MyServiceImpl service = context.getBean("myService", MyServiceImpl.class);
        System.out.println(service.sayHello());
    }
}
```

执行程序，可以看到正确的打印输出。



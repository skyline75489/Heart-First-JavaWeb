## SpringBoot Configuration

SpringBoot 在 SpringMVC 的基础之上，进一步强化了配置有关的功能。下面介绍一下 SpringBoot 配置有关的功能。

### 配置外部化

所谓配置外部化，指的是不通过代码，而通过外部环境（文件）来进行配置，将配置和代码隔离开来，有助于降低配置的耦合性。

SpringBoot 支持从命令行参数，系统环境变量，配置文件等诸多位置读取配置信息。在工程的 resources 目录下加入一个配置文件 `application.yml`，将前面章节中 SQLite 有关的数据库的配置放到配置文件中：

```yaml
spring:
  datasource:
    driver-class-name: org.sqlite.JDBC
    url: jdbc:sqlite:D:\\test.db
```

配置文件会随着代码打到 Jar 包当中，进而被 Spring 读取。可以看到这种配置写法可读性也很高。Spring 对配置文件的支持很强大，这里我们统一使用 yaml 配置的写法。

除了 Spring 内置的配置项之外，我们也可以定义自己的配置项，并且很方便的在代码中使用。例如我们有一个 MyProperties 的 Bean 类：

```java
public class MyProperties {
    public MyProperties() {
    }

    private String username;
    private String password;
    // Getters & Setters
}
```

在配置文件中进行配置：

```yaml
customProperty:
  username: hello
  password: world
```

在代码中使用：

```java
package com.skyline;

import com.skyline.model.MyProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    @ConfigurationProperties(prefix="customProperty")
    public MyProperties myProperties() {
        return new MyProperties();
    }
}
```

对于单独的值来说，也可以在配置文件中存储，例如我们在配置文件中添加这样一个值：

```yaml
another.custom.property: hello-again
```

在代码中需要用的地方，可以这样使用：

```java
package com.skyline;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/person")
public class PersonController {

    @Value("${another.custom.property}")
    String property;
}
```

>这里使用的 "${...}" 写法，是 Spring 独有的 SpEL（Spring Expression Language）语法。熟悉 JSP 的同学应该都在 JSP 中使用过 EL 表达式。SpEL 的思想是类似的。SpEL 的功能很强大，这里不再赘述，有兴趣的同学可以查阅有关资料。

### Profile

SpringBoot 支持将配置文件分成多个部分，其中每个部分对应不同的环境，也就是 Profile。例如我们在测试环境和线上环境中，要使用不同的数据库等配置，这种需求是非常常见的。在 Spring 配置文件中我们可以这样做：

```yaml
spring.profiles.active = test

---
spring:
  profiles: test
customProperty:
  username: hello
  password: world

---
spring:
  profiles: online
customProperty:
  username: hello2
  password: world2
```

可以看到我们把配置文件分成了 test 和 online 两个部分，并且激活了 test 这个 Profile，通过这种方式，可以很方便地进行配置的切换。

> Profile 还可以通过 SpringBoot 启动时传入命令行参数来激活。

*注意*: 下面的内容介绍不全面，暂时不推荐阅读。

### Auto-Configuration

SpringBoot 对于跨组件配置的场景，提供了 Auto-Configuration 进行支持。Auto-Configuration 允许我们根据运行时环境进行判断，执行不同的配置操作。例如，我们可以判断一个外界的 Bean 是否存在：

```java
@Bean
@ConditionalOnBean(name = "dataSource")
public MyBean thisBean() {
    //...
}
```

通过这样配置，当已经存在一个名为 dataSource 的 Bean 时，thisBean 才会生效。

除此之外，还有 `@ConditionalOnMissingBean`，`@ConditionalOnClass` 等等一系列很方便的 annotation 来帮助我们实现自动配置。

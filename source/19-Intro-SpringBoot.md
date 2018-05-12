## SpringBoot 初步

SpringBoot 是构建在 SpringMVC 基础上的新一代 Web 开发框架。相比 SpringMVC，SpringBoot 的配置更简单，上手更容易，因此受到了开发者们的欢迎。下面我们将在前面内容的基础上，学习使用 SpringBoot。

首先我们在 pom 中加入对于 SpringBoot 的依赖：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.5.3.RELEASE</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!-- ... -->
</dependencies>
```

然后创建一个新的 SpringBoot 应用：

```java
@SpringBootApplication
public class MySpringBootApplication {
    public static void main(String[] args) {
        SpringApplication.run(applicationClass, args);
    }

    private static Class<MySpringBootApplication> applicationClass = MySpringBootApplication.class;
}
```

在 IDEA 中加入 MySpringBootApplication 的启动配置。如果之前的工程代码还在，这时候运行程序，我们会发现可以通过 `http://localhost:8080/hello` 访问到我们的网页了，同时前面写 Rest 服务也可以正常工作！

这是怎么回事呢？原来 SpringBoot 内置了一个 Tomcat 服务器，也就是内嵌了一个 Servlet Container，因此直接运行工程就可以看到效果，不需要再进行额外的部署，也无需进行 Servlet 的有关配置。同时 SpringBoot 还会帮我们做许多配置工作。通过 `@SpringBootApplication` 这个 Annotation，它会帮我们打开 @`EnableWebMvc`，以及 `@ComponentScan` 功能，这意味着 SpringBoot 会和 SpringMvc  找到同一个 package 下的 `@Controller`，`@Configuration` 等类，进行自动配置。

如果我们想使用例如 Tomcat 之类的 Servlet 容器呢？SpringBoot 也可以很方便地做到这一点，只需要继承 `SpringBootServletInitializer`，整个应用就具备了部署到 Servlet Container 的能力：

```java
@SpringBootApplication
public class MySpringBootApplication extends SpringBootServletInitializer {
    public static void main(String[] args) {
        SpringApplication.run(applicationClass, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(applicationClass);
    }

    private static Class<MySpringBootApplication> applicationClass = MySpringBootApplication.class;
}
```
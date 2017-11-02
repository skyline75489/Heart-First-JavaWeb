纯 Java SpringMVC 配置
=====================

在上一节中我们去掉了 `web.xml`，通过 Java 代码实现了 Servlet 的配置，然而 SpringMVC 本身的配置文件 `MyFirstServletName-servlet.xml` 依然存在，下面我们看一下如何进一步将它也去掉。

首先我们需要使用 `AnnotationConfigWebApplicationContext` 去初始化 `DispatcherServlet`：

```java
public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext container) {
        AnnotationConfigWebApplicationContext context
                = new AnnotationConfigWebApplicationContext();
        context.setConfigLocation("com.skyline.AppConfig");

        ServletRegistration.Dynamic registration = container.addServlet("MyFirstServletName", new DispatcherServlet(context));
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```

>还记得 SpringIoC 中的 `Context` 概念吗？`AnnotationConfigWebApplicationContext` 也是一个 Context 的例子，只不过这里的 Context 加入了和 Web 有关的内容。

注意上面我们设置了配置为 `com.skyline.AppConfig`，下面修改 `AppConfig`：

```java
@Configuration
public class AppConfig {
    @Bean
    public Object myFirstSpringController() {
        return new MyFirstSpringController();
    }
}
```

这时候我们删除 Tomcat 目录下的 `MyFirstServletName-servlet.xml`，运行程序，依然可以通过浏览器访问看到 "Hello, SpringMVC." 的结果。

`@Controller` 也是继承自 `@Component`，因此我们可以使用 Component Scan 功能来简化代码：

```java
@Configuration
@ComponentScan("com.skyline")
public class AppConfig {
}
```

为了进一步简化 Java 配置的过程，Spring 还提供了一个名为 `AbstractAnnotationConfigDispatcherServletInitializer` 的类。修改我们的 `MyWebApplicationInitializer`：

```java
public class MyWebApplicationInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] { };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[] { AppConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/*" };
    }

}
```

可以看到这种方法更加直接和明了。

>注意上面有一个 `getRootConfigClasses` 我们返回了空数组。`getServletConfigClasses` 用于创建当前 DispatcherServlet 的 WebApplicationContext，在此基础上，Spring 还允许若干 DispatcherServlet 共享一个 Root WebApplicationContext。Root WebApplicationContext 中可以配置跨 Servlet 共享的业务逻辑等，`getRootConfigClasses` 就是用来提供创建 Root WebApplicationContext 的
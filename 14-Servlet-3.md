Servlet 3
=========

在有了前面 Spring IoC 有关知识的基础上，我们可以进一步地了解 SpringMVC 的工作机制了。不过在此之前，为了形式上的统一，我们先介绍一下基于 Annotation 的 Servlet API。

前面的内容提到过，Spring 本身逐渐从 XML 转向了基于 Annotation 的配置，与之类似的，Servlet API 从 3.0 开始也支持了基于 Annotation 的配置。

在 Servlet 3 中，我们可以继承 `ServletContainerInitializer` 来实现替代 `web.xml` 的作用。Servlet 3 要求在 deploy 目录中加入 `META-INF/services/javax.servlet.ServletContainerInitializer` 文件，来指示 `ServletContainerInitializer` 的实现者，用于 Servlet 的初始化。

SpringMVC 已经帮我们做了这件事情，在 `spring-web-4.3.9.RELEASE` 这个 jar 里我们可以找到 `javax.servlet.ServletContainerInitializer` 这个文件，里面的内容是：

```plaintext
org.springframework.web.SpringServletContainerInitializer
```

同时 SpringMVC 暴露出了自己的接口，名为 `WebApplicationInitializer`，通过这个接口我们可以进行类似 `web.xml` 的配置。

>注意这一层封装，实际上是想把 Servlet API 和 Spring API 隔离开，在 SpringBoot 框架中我们会有更加深刻的体会。

创建一个新类 `MyWebApplicationInitializer`：

```java
package com.skyline;

import javax.servlet.*;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.servlet.DispatcherServlet;

public class MyWebApplicationInitializer implements WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext container) {
        ServletRegistration.Dynamic registration = container.addServlet("MyFirstServletName", new DispatcherServlet());
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```

注意我们配置的内容，实际上和之前用过的 `web.xml` 是可以对应的：

```xml
<servlet>
    <servlet-name>MyFirstServletName</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>MyFirstServletName</servlet-name>
    <url-pattern>/*</url-pattern>
</servlet-mapping>
```

把 `MyWebApplicationInitializer.class` 部署到 Tomcat 目录，运行 Tomcat，可以得到和之前相同的结果。

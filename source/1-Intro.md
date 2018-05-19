## 基本概念

国内的大部分资料对于 Java Web，JavaEE，J2EE 以及 Spring 和 SpringMVC 等概念的使用，是完全混乱的。这对于新手来说可以说是非常不友好，容易让新手迷失在诸多概念当中不知从何处入手。下面笔者会试着用人话介绍一下 Java Web 开发当中的一些名词和概念，力争清楚明白。

### JavaEE

J2EE, JavaEE 以及 JEE 现在可以认为指的都是同一个东西，只不过由于历史原因出现了若干名称。为了大家理解方便，我们统一用拼写和理解比较方便的 JavaEE 这个名称。

JavaEE 全称 Java Platform, Enterprise Edition，它是对 JavaSE(Java Platform, Standard Edition) 的扩展，加入了面向企业开发（实际上就是网络和 Web 有关开发）的支持，包括 Servlet，WebSocket，EL，EJB 等。简单理解，JavaEE 就是 JavaSE + 更多的 jar 包，这些 jar 包命名以 javax 开头，例如 `javax.servlet`, `javax.websocket` 等。

注意 JavaEE 平台提供了 API 标准，但是不一定提供了实现。因此单纯靠 JavaEE 平台本身，是无法进行完整的 Web 开发的，下面会具体讲到。

### Servlet 和 Servlet Container

在 JavaEE 的诸多组件中，做 Web 开发一定躲不开的是 Servlet。Servlet 是一套用于处理 HTTP 请求的 API 标准。我们可以基于 Servlet 实现 HTTP 请求的处理。但是 JavaEE 当中只提供了 Servlet 的标准，要真正运行 Servlet，需要使用 Servlet Container。

如果 Servlet 是电器，Servlet Container 就是电源插座。如果你之前接触过 Python 的 WSGI 或者其它语言的 Web 框架，这样的设计就很容易理解。这层抽象让 Servlet 可以跑在任何一个 Container 当中，隔绝了对 Runtime 环境的依赖。

JavaEE 本身没有提供 Servlet Container，比较常用支持 Servlet Container 的 Server 软件有 Apache Tomcat，Glassfish，JBoss，Jetty 等等。

> Servlet 是 Java Web 开发的事实标准，不过也不代表所有 Java Web 框架都一定要使用或者兼容 Servlet。不使用 Servlet 也可以进行 Java Web 开发，例如 Play Framework，就是完全自立门户的一个框架。


### EJB 和 EJB Container

EJB 全称 Enterprise JavaBean，和 Servlet 一样，也是 JavaEE 当中的一个组件，面向更加复杂的企业业务开发。对于 Web 开发来说，EJB 不是必须的。本教程不打算涉及有关 EJB 开发的内容，读者如果感兴趣可以查阅有关资料。

有一个概念需要明确，和 Servlet 类似，运行 EJB 也需要专门的 EJB Container。并不是所有的 Server 软件都支持 EJB。例如，Apache Tomcat 不支持 EJB，而 JBoss 提供了对 EJB 的支持。

### Spring

Spring 是一个非常庞大的框架，其中包括 SpringMVC，SpringBoot 以及 SpringCloud 等用于 Web 开发的工具。

Spring 某种程度上可以认为是 EJB 的替代品。Spring 不需要完整的 JavaEE 内容，仅仅依赖了最基础的 Servlet，也不需要 EJB Container，只用普通的 Servlet Container 就可以运行。在 Servlet 之上 Spring 提供了诸多方便好用的工具，极大地降低了 Java Web 开发入门门槛。

注意一些中文资料把 JavaEE 以及 JavaWeb 和 Spring 混淆在一起，是十分不妥的。经过前面的介绍可以看到，Spring 和 JavaEE 不是一个层面上的东西。Spring 仅依赖了 JavaEE 的 API 标准，最新版的 Spring 甚至进一步隔绝了 JavaEE 的 API。开发者可以完全不关心 Servlet 或者 JavaEE 等概念，也可以进行 Java Web 开发。同时 Spring 也不是唯一的 Java Web 框架，其竞争对手有 Structs，Spark 等。

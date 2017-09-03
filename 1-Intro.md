Heart First JavaWeb
===================

这是一个走心的 JavaWeb 入门开发教程。面向新手友好，容易上手，同时没有废话。

阅读这本教程之前，希望你能够具备以下技能：

* Java 语言基础
* Web 开发基础
* 基本的工具使用能力
* 良好的搜索能力
* 不怕麻烦，有耐心

本教程定位是一个**入门**教程，面向的是有 Web 开发经验，但是没有接触过 JavaWeb 的新手。当然如果你完全没有 Web 开发经验，但是对自己的学习能力很有信心，也可以试着学习本教程。

#### 基本概念

国内的大部分资料对于 JavaWeb，JavaEE，J2EE 以及 Spring 和 SpringMVC 等概念的使用，是完全混乱的。这对于新手来说可以说是非常不友好，容易让新手迷失在诸多概念当中不知从何处入手。下面笔者会试着用人话介绍一下 JavaWeb 开发当中的一些名词和概念，力争清楚明白。

##### JavaEE

J2EE, JavaEE 以及 JEE 现在可以认为指的都是同一个东西，只不过由于历史原因出现了若干名称。为了大家理解方便，我们统一用拼写和理解比较方便的 JavaEE 这个名称。

JavaEE 全称 Java Platform, Enterprise Edition，它是对 JavaSE(Java Platform, Standard Edition) 的扩展，加入了面向企业开发（实际上就是网络和 Web 有关开发）的支持，包括 Servlet，WebSocket，EL，EJB 等。简单理解，JavaEE 就是 JavaSE + 更多的 jar 包，这些 jar 包命名以 javax 开头，例如 `javax.servlet`, `javax.websocket` 等。

注意 JavaEE 平台提供了 API 标准，但是不一定提供了实现。因此单纯靠 JavaEE 平台本身，是无法进行完整的 Web 开发的，下面会具体讲到。

##### Servlet 和 Servlet Container

在 JavaEE 的诸多组件中，做 Web 开发一定躲不开的是 Servlet。Servlet 是一套用于处理 HTTP 请求的 API 标准。我们可以基于 Servlet 实现 HTTP 请求的处理。但是 JavaEE 当中只提供了 Servlet 的标准，要真正运行 Servlet，需要使用 Servlet Container。

如果 Servlet 是电器，Servlet Container 就是电源插座。如果你之前接触过 Python 的 WSGI 或者其它语言的 Web 框架，这样的设计就很容易理解。这层抽象让 Servlet 可以跑在任何一个 Container 当中，隔绝了对 Runtime 环境的依赖。

JavaEE 本身没有提供 Servlet Container，比较常用支持 Servlet Container 的 Server 软件有 Apache Tomcat，Glassfish，JBoss，Jetty 等等。

##### EJB 和 EJB Container

EJB 全称 Enterprise JavaBean，和 Servlet 一样，也是 JavaEE 当中的一个组件，面向更加复杂的企业业务开发。对于 Web 开发来说，EJB 不是必须的。本教程不打算涉及有关 EJB 开发的内容，读者如果感兴趣可以查阅有关资料。

有一个概念需要明确，和 Servlet 类似，运行 EJB 也需要专门的 EJB Container。并不是所有的 Server 软件都支持 EJB。例如，Apache Tomcat 不支持 EJB，而 JBoss 提供了对 EJB 的支持。

##### Spring

Spring 是一个非常庞大的框架，其中
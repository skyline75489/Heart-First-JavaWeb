## 初识 SpringMVC

可以看到，使用 SpringMVC 框架，实现一个 Controller，并且能够在浏览器中访问，实在是简单了太多，背后 SpringMVC 帮我们做了很多的工作，这里简要地介绍一下，以让读者对 SpringMVC 工作原理有一个初步的认识。

### Annotation

在前面的代码中，我们使用了诸如 `@Controller` 等 Annotation。要理解前面的代码，首先要对 Java 的 Annotation 语法有一定了解。考虑到并不是所有读者对于 Annotation 语法都很熟悉，这里简单做一下介绍。

Annotation，可以翻译成注解，可以看成对源代码的一种标注。注解本身不会对源代码产生任何影响，不过我们可以通过在编译器或者运行期检查代码中的注解，通过注解给代码引入更多的功能。

Java 语言本身就自带了一些注解，例如最常见的 `@Override`，用来标记方法是一个重载方法。以及 `@Deprecated` 用于标记代码为废弃。

为了编写自定义注解，需要使用 Java 提供的若干用于生成注解的注解，即所谓的元注解（Meta Annotations）。这里可能有一点绕，简单理解就是，这些注解存在的作用，就是为了让我们可以编写自己的注解。用一个例子来说明：

```java
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyAnnotation {
}
```

在上面这个例子中，我们使用了若干个注解，来编写我们自己的 `@MyAnnotation` 注解，下面分别介绍一下它们的作用：

1. `@Target`：指明这个注解可以用在哪些语言元素上，例如方法，类型，函数参数等。
2. `@Retention`：指明注解的存储方式，分别是 SOURCE（只存在于代码中，编译完成后被丢弃），CLASS（存储在生成的 class 文件中，但是会被 VM 在运行期丢弃），RUNTIME（存储在 class 文件中，并且 VM 在运行期间也会保留，因此可以使用反射获得），默认的存储方式是 CLASS。
3. `@Documented`：指明使用了这个注解的代码，其生成的 Javadoc 中会把此注解展示出来
4. `@Inherited`：这里没有使用，它是用于标记 Target 是 Class 的 Annotation 的，在其他类型的 Annotation 上使用不起作用。它标记对于父类的注解，会被子类做继承，默认行为是不继承。

### POJO

Java 语言中引入了很多乍一看奇奇怪怪的概念，POJO 应该算是其中的一个。POJO 全称是 Plain Old Java Object，即普通的 Java 对象。单看全称的话，POJO 实在是没什么意义，我们随便写一个 Java 对象都可以被称为 POJO，而事实也正是如此，大部分 Java 对象都可以被称为 POJO。那么 POJO 这个概念实际上存在有什么意义呢？

想了解这个，首先要知道 POJO 想要对比的是什么。我们之前提到的 EJB 以及类似的 Java 框架当中，开发者为了使用框架的功能，需要继承特定的类，实现特定的接口，这样产生的依赖相对重的类，就不能被称为 POJO。例如在使用 JMS 框架时，为了实现一个 MessageListener，需要实现特定的接口：

```java
public class ExampleListener implements MessageListener {
    public void onMessage(Message message) {
        // ...
    }
}
```

再例如，在使用 RMI 时，我们自己的业务接口，也需要继承自特定的接口：

```java
public interface IHello extends Remote {
    public String helloWorld() throws RemoteException;
}
```

这样的设计实际上把业务和框架本身紧紧的耦合在了一起，POJO 的提出就是反对这种设计，鼓励大家减少这种很重的框架依赖。

SpringMVC 框架是鼓励使用 POJO 的，例如我们前面编写的 Controller 类，如果把所有的 Annotation 都去掉，就成了这个样子：

```java
public class MyFirstSpringController {
    public String Hello() {
        return "Hello, SpringMVC.";
    }
}
```

可以看到这是一个再简单不过的 Java 类了，没有对任何东西产生依赖。而我们前面提到，Annotation 实际上对代码本身没有任何影响，因此哪怕加入了诸多 Annotation，这个类本身零依赖的这种轻量性依然不会发生变化。而依赖越轻量的代码，越容易解耦，在架构上也越清晰，越灵活。这也是 POJO 这个概念想要表达的。

### JavaBean

又是一个听起来很可爱，但是好像又什么都没说的 Java 概念。JavaBean 实际上是对于用 Java 编写数据 Model 时的一种编程惯例，具体的要求是：

1. 有无参的构造器
2. 所有的成员都是 private，对外暴露 getter 和 setter
3. 实现 `Serializable`

后面 JavaBean 这个概念也逐渐的泛化，不再局限于 Model 类，出现了所谓的业务 Bean 等，对于 `Serializable` 的要求也显得可有可无。还是拿我们的 Controller 类举例子，它不仅仅是一个 POJO，也是一个 JavaBean。

后面我们会看到，Spring 把很多东西包括自己的一些组件也都称为 Bean，这个称呼可以看成是对 JavaBean 的进一步泛化。

### SpringMVC Magic

首先 SpringMVC 需要知道我们的 Controller 是什么。前面我们在配置文件里标明了我们的 Controller 类是什么。

在 Controller 类中，对于请求的分发处理，`@RequestMapping` 的作用很明显。在初始化 Controller 的时候，SpringMVC 把 `@RequestMapping` 注解当中的信息进行处理，之后就可以根据这些信息，把请求分发到对应的 Controller 当中的对应方法里。

`@ResponseBody` 表明函数的返回值应该被用作 HTTP 返回的 body 处理。SpringMVC 用我们返回的字符串生成 HTTP 响应，返回给了客户端。

这就是 SpringMVC 大体的工作流程，可以看到 SpringMVC 通过 Annotation 以一种低侵入性的方式，提供了一套简洁好用的 Web 开发的 API。

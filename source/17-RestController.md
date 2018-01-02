RestController
==============

随着移动互联网的发展，RESTful 作为一种对移动端友好的技术也日趋火热，Spring 也提供了 RestController API 方便开发者使用。

创建一下新的类，取名为 PersonController：

```java
@RestController
@RequestMapping("/person")
public class PersonController {
    @RequestMapping(method = RequestMethod.GET)
    public List<Person> getAllPerson() {
        List<Person> l = new ArrayList<>();
        l.add(new Person(1, "Chester"));
        return l;
    }

    @RequestMapping(value = "/{id:[\\d]+}", method = RequestMethod.GET)
    public Person getPerson(
            @PathVariable(value = "id") int id
    )
    {
        return new Person(id, "Chester");
    }
}
```

这里一个简单的 RestController 示例。可以看到我们用到 `@RestController` 这个 Annotation，如果我们点开它看，会发现它不过是很简单的一个组合：

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
public @interface RestController {
}
```

`@RestController` 实际上就是在 `@Controller` 的基础上，给所有的函数返回值增加了 `@ResponseBody`。因此我们在函数里不需要再指明 `@ResponseBody`，可以直接将 Java 对象（如 Person）返回，简化了代码的编写。

Spring 本身是不带 JSON 功能的，不过它提供了对于第三方 JSON 库的良好支持。我们通过 Maven 引入一个很常用的 JSON 库 Jackson。在 pom.xml 中的依赖部分加入下面的内容：

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.7.3</version>
</dependency>
```

另外我们还需要修改我们的配置，加入 `@EnableWebMvc`：

```java
@Configuration
@EnableWebMvc
@ComponentScan("com.skyline")
public class AppConfig {
}
```

`@EnableWebMvc` 是 Spring MVC 新版本所推荐的用法，它会帮我们做很多配置工作。`@EnableWebMvc` 具体做的事情可以参考 [Spring 官方文档](https://docs.spring.io/spring/docs/4.2.1.RELEASE/javadoc-api/org/springframework/web/servlet/config/annotation/WebMvcConfigurationSupport.html)。这里我们需要知道的是，`@EnableWebMvc` 会帮我们配置好 JSON 有关的响应 Handler。如果没有，是不能返回 JSON 响应的。

编译代码之后，将生成的代码拷贝到 Tomcat 的工作目录，同时不要忘记将 Jackson 的 jar 包也拷贝到 lib 目录下面，这样在运行时 Tomcat 才能找到正确的依赖。运行 Tomcat 在浏览器中可以看到输出：

![rest-result](https://raw.githubusercontent.com/skyline75489/Heart-First-JavaWeb/master/img/17-rest-result.png)


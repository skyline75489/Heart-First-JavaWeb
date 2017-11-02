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
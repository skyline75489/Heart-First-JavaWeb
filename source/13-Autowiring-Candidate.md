Autowiring Candidate
====================

前面有关 Autowired 的内容当中，有一个问题我们没有涉及到，就是我们的 `@Autowired` 类型都是基于类型的，如果同时有两个同样类型的 Bean 呢？例如我们有两个 Person Bean：

```java
@Component
public class MyPersonComponent {

    @Bean
    public Person aPerson() {
        Person aPerson = new Person();
        aPerson.setName("Chester");
        return aPerson;
    }

    @Bean
    public Person bPerson() {
        Person aPerson = new Person();
        aPerson.setName("Mike");
        return aPerson;
    }

    @Bean("myService")
    public MyServiceImpl testService() {
        MyServiceImpl service = new MyServiceImpl();
        service.setGreeting("Hello");
        return service;
    }
}
```

这时候运行程序，会导致异常，Srping 提示的信息是：

>No qualifying bean of type 'com.skyline.model.Person' available: expected single matching bean but found 2: aPerson,bPerson

这个错误已经把问题说明的很清楚了，Spring 并不知道我们想使用哪个 Person，因此抛出了异常。

为了解决这个问题，Spring 提供了另外的机制，允许我们将额外的信息提供给 Spring，好让它可以正确地找到对应的 Bean。

第一种方法是使用 `@Primary`：

```java
@Bean
@Primary
public Person aPerson() {
    Person aPerson = new Person();
    aPerson.setName("Chester");
    return aPerson;
}

@Bean
public Person bPerson() {
    Person aPerson = new Person();
    aPerson.setName("Mike");
    return aPerson;
}
```

在有多个 candidate 可以选择的时候，Spring 会使用标注了 `@Primary` 的那一个。

如果我们需要更加细致的管理，可以使用 `@Qualifier`：

```java
@Bean
@Qualifier("Chester")
public Person aPerson() {
    Person aPerson = new Person();
    aPerson.setName("Chester");
    return aPerson;
}

@Bean
@Qualifier("Mike")
public Person bPerson() {
    Person aPerson = new Person();
    aPerson.setName("Mike");
    return aPerson;
}
```

在需要用到 Person 的地方进行标记：

```java
@Autowired
@Qualifier("Chester")
private Person person;
```

同时 `@Qualifier` 也可以用在函数参数上：

```java
public void IWantMike(@Qualifier("Mike") Person person) {
    //...
}
```

>细心的同学可能观察到了，`@Autowired` 和在 XML 里进行 Bean 的 ref 还有有一些差别。在 XML 中我们是基于 id/name 去引用依赖的，而 `@Autowired` 从本质上就是一种基于类型的依赖机制，qualifier 是一种额外的特殊情况。
Bean 生命周期和作用域
==================

前面的内容中我们看到，Bean 的创建是完全由 Spring Container 进行控制的，我们不需要手动进行创建对象的操作。进一步的，Bean 在 Container 的控制下，有自己的生命周期和作用域，本部分将简单介绍有关内容。

### Singleton

Bean 默认的作用域是 Singleton：

```java
@Bean
@Scope("singleton") // 默认，可以去掉
//@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON) 另一种写法
public Person aPerson() {
    Person aPerson = new Person();
    aPerson.setName("Chester");
    return aPerson;
}
```

Singleton 的含义是，在 Container 内该 Bean 只会被创建一次，后续的所有对于该 Bean 的请求都会返回同一个对象。

### Prototype

另一种 Bean 的作用域是 Prototype：

```java
@Bean
@Scope("prototype")
public Person personPrototype() {
    return new Person();
}
```

ProtoType 的含义是，每次对于 Bean 的请求，都会创建一个新的对象。

### Lifecycle Callback

Spring 允许 Bean 在创建和销毁的时候注册回调：

```java
public class Foo {
    public void init() {
    // initialization logic
    }
}
public class Bar {
    public void cleanup() {
    // destruction logic
    }
}

@Configuration
public class AppConfig {
    @Bean(initMethod = "init")
    public Foo foo() {
        return new Foo();
    }
    @Bean(destroyMethod = "cleanup")
    public Bar bar() {
        return new Bar();
    }
}
```

## Annotation-Based 配置

除了之前提到的使用 XML 之外，Spring 还提供了使用 Annotation 的方式进行 Bean 配置的方法。首先我们修改 XML 配置文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context" <!-- 新增 -->
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd"> <!-- 新增 -->
    
    <context:annotation-config/> <!-- 打开 Annotation-Config -->

    <bean id="aPerson" class="com.skyline.model.Person">
      <property name="name" value="Chester"/>
    </bean>

    <bean id="myService" class="com.skyline.service.MyServiceImpl">
      <property name="greeting" value="Hello"/>
    </bean>

</beans>
```

注意我们新增了一些 namespace ，同时去掉了 `MyServiceImpl` 当中对于 `aPerson` 的 ref。

下面修改 MyServiceImpl 的实现：

```java
public class MyServiceImpl implements MyService {

    private Person person;

    private String greeting;

    public Person getPerson() {
        return person;
    }

    @Autowired // 新增
    public void setPerson(Person person) {
        this.person = person;
    }

    public String getGreeting() {
        return greeting;
    }

    public void setGreeting(String greeting) {
        this.greeting = greeting;
    }

    @Override
    public String sayHello() {
        return this.greeting + " " + this.person.getName();
    }
}
```

运行程序，输出的结果是相同的。

通过上面的内容可以看到，本质上 `@Autowired` 就是把原先在 XML 中对于对象的引用配置，转移到了 Java 代码当中。

`@Autowired` 也可以直接用于 Constructor：

```java
public class MyServiceImpl implements MyService {

    private Person person;

    @Autowired
    public MyServiceImpl(Person person)
    {
        this.person = person;
    }
    
    //...
}
```

甚至可以直接用在 field 上：

```java
public class MyServiceImpl implements MyService {

    @Autowired
    private Person person;
    
    // ...
}
```


## Spring Bean 初步
 
通过前一章内容我们看到，Bean 本质上就是我们通过配置文件，去指导 Spring 进行初始化产生的对象。实际上，Bean 在 Spring 中还有很多属性，在这一章我们主要关注和对象创建有关的内容，其中很重要的一点，就是对象的依赖。

在真正的业务中，对象之间会形成复杂的依赖关系。在 Spring 的 Bean 配置中，我们可以描述出这种依赖关系，Spring 会根据依赖关系，正确地进行 Bean 的初始化。

### Constructor 注入

首先第一种依赖注入的方式，就是通过 Constructor 进行注入。下面通过一个例子展示一下。我们将上一章的 Service 拆分出一个 model 类 Person：

```java
package com.skyline.model;

public class Person {

    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}

```

和一个依赖 Person 的 Service 类：

```java
package com.skyline.service;

import com.skyline.model.Person;

public class MyServiceImpl implements MyService {

    private Person person;

    public MyServiceImpl(Person person)
    {
        this.person = person;
    }

    @Override
    public String sayHello() {
        return "Hello " + this.person.getName();
    }
}
```

可以看到，Service 初始化时，在 Constructor 中需要一个 Person 的实例。为了让代码正常工作，我们需要更改 Bean 的配置：

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="aPerson" class="com.skyline.model.Person">
      <property name="name" value="Chester"/>
    </bean>

    <bean id="myService" class="com.skyline.service.MyServiceImpl">
      <constructor-arg ref="aPerson"/>
    </bean>

</beans>
```

通过这样的方式，Spring 会先初始化 aPerson，然后使用它初始化 myService。运行代码，结果和之前是一样的。

此外，对于不是自定义类的普通参数，也可以使用 XML 进行注入，例如我们更改 Serivce 类，加入 greeting 参数：

```java
public class MyServiceImpl implements MyService {

    private Person person;

    private String greeting;

    public MyServiceImpl(Person person, String greeting)
    {
        this.person = person;
        this.greeting = greeting;
    }

    @Override
    public String sayHello() {
        return this.greeting + " " + this.person.getName();
    }
}
```

修改 XML 配置如下：

```xml
<bean id="myService" class="com.skyline.service.MyServiceImpl">
  <constructor-arg ref="aPerson"/>
  <constructor-arg type="java.lang.String" value="Hello"/>
</bean>
```

运行程序，仍然可以打印出预期结果。

### Setter 注入

另一种依赖注入方式，是通过 Setter，这种方式类似于初始化 Bean 的参数。仍然用一个例子，我们把 Service 改成下面这样：

```java
public class MyServiceImpl implements MyService {

    private Person person;

    private String greeting;

    public Person getPerson() {
        return person;
    }

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

与之对应的，修改 XML 配置文件：

```xml
<bean id="aPerson" class="com.skyline.model.Person">
  <property name="name" value="Chester"/>
</bean>

<bean id="myService" class="com.skyline.service.MyServiceImpl">
  <property name="person" ref="aPerson"/>
  <property name="greeting" value="Hello"/>
</bean>
```

运行程序，结果保持不变。
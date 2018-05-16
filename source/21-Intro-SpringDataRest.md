## Spring Data REST 初步

在前面的 REST 实践当中，可以看到常用的 CRUD 操作，是有常见的写法和模式的。对于很多资源的 CRUD，要写很多类似的数据库操作代码，那么有没有办法简化代码呢？人们自然已经想到办法了，接下来我们将学习如何使用 Spring Data REST 来简化 REST 服务的开发。

### 基本概念

首先我们需要了解一些新的概念：

>如果你还不了解 ORM 以及相关概念，请先学习一下，这里不再赘述。

* JPA：JPA 全称 Java Persistence API，是 Sun 官方提出的一套 Java 持久化**规范**，也可以简单理解为 ORM 的规范。
* Hibernate：Hibernate 是一个知名 Java 持久化框架，它**实现**了 JPA 规范，可以被用作 JPA Provider。
* Spring Data JPA：Spring 的 JPA 组件，它提供了将 JPA 融入 Spring 框架的支持，它默认使用 Hibernate 作为 JPA Provider。

### 开始使用 Spring Data REST

以我们之前的 PersonDao 为例，下面我们使用 Spring Data REST 重写它。

首先在 pom 中加入相关依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-rest</artifactId>
</dependency>
```

然后我们需要配置一下数据库连接。为了方便，我们接下来使用 yaml 进行有关配置，将 AppConfig 当中的数据库配置删除。

由于 SQLite 没有提供 Hibernate 的接入支持（Dialect），我们需要手动引入一下，有关代码在这里可以找到 https://github.com/restart1025/Spring-Boot-SQLite/blob/master/src/main/java/com/restart1025/sqlite/SQLiteDialect.java

将这个文件引入工程之后，修改配置文件，让 Hibernate 找到这个驱动：

```yaml
spring:
  profiles:
    active: dev
  datasource:
    driver-class-name: org.sqlite.JDBC
    url: jdbc:sqlite:D:\\test.db
    username:
    password:
  jpa:
    database-platform: com.skyline.SQLiteDialect
    hibernate:
      ddl-auto: update
    show-sql: true
```

重写 Person，将 Person 定义成 JPA 兼容的 model：

```java
package com.skyline.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Person {

    @Id
    @GeneratedValue
    private int id;

    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
```

还记得之前提到的 @Repository 吗？Spring 当中数据持久化使用 Repository 这个概念进行抽象。首先创建一个新 package 名为 repository，然后创建我们的 Rest Repository：

```java
package com.skyline.repository;

import com.skyline.model.Person;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "person")
public interface PersonRepository extends PagingAndSortingRepository<Person, Integer> {
}
```

然后启动程序， 一个完整的 Person REST 接口就可以使用了，没错，就是这么简单！

使用 curl 测试一下 Person 的接口：

创建：

```plaintext
$ curl -X POST http://localhost:8080/person -d"{ \"name\": \"chester\"}" --header "Content-Type : application/json"
{
  "name" : "chester",
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/person/1"
    },
    "person" : {
      "href" : "http://localhost:8080/person/1"
    }
  }
}
```

获取：

```plaintext
$ curl -X GET http://localhost:8080/person/1
{
  "name" : "chester",
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/person/1"
    },
    "person" : {
      "href" : "http://localhost:8080/person/1"
    }
  }
}
```

同样修改和删除也是可用的。此外还可以通过 /person 拿到所有的 person 列表，以及一些其他接口，有兴趣可以自己尝试一下。

可能你注意到了，返回的 JSON 当中有 _links 这种属性。这种 JSON 格式被称为 HATEOAS 格式，即 hal-json，是一种更加规范的 REST 接口标准。如果我们不想使用 hal-json，可以修改配置文件：

```yaml
spring:
  //...
  data:
    rest:
      defaultMediaType: application/json
```


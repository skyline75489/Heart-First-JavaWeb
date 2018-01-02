Rest 实践
========

结合之前所学的内容，这篇教程将基于 SpringMVC 构建一个真正的 Rest 服务。

首先构建 Service 层，即逻辑层，创建接口 PersonService：

```java
public interface PersonService {

    List<Person> get();

    Person get(int id);

    void add(int id, String name);

    void delete(int id);
}
```

同时创建对应的 PersonServiceImpl 层，对应的实现可以留空。

然后在前面的 PersonController 基础上，加入更多的 API 支持：

```java
@ResponseStatus(value = HttpStatus.NOT_FOUND)
class ResourceNotFoundException extends RuntimeException {
}

@RestController
@RequestMapping("/person")
public class PersonController {

    @Autowired
    private PersonService personService;

    @RequestMapping(method = RequestMethod.GET)
    public List<Person> getAllPerson() {
        return personService.get();
    }

    @RequestMapping(value = "/{id:[\\d]+}", method = RequestMethod.GET)
    public Person getPerson(
            @PathVariable(value = "id") int id
    )
    {
        Person result = personService.get(id);
        if (result == null)
        {
            throw new ResourceNotFoundException();
        }
        return result;
    }

    @RequestMapping(value = "", method = RequestMethod.POST)
    public void addPerson(@RequestParam int id, @RequestParam String name)
    {
        personService.add(id, name);
    }

    @RequestMapping(value = "/{id:[\\d]+}", method = RequestMethod.DELETE)
    public void deletePerson(
            @PathVariable(value = "id") int id
    )
    {
        personService.delete(id);
    }
}
```

这样一个简单的 Rest 框架就搭建好了。

对于 PersonService 的实现部分，我们再抽取一个新的 PersonDao 接口：

```java
public interface PersonDao {

    List<Person> get();

    Person get(int id);

    void add(int id, String name);

    void delete(int id);
}
```

PersonService 的实现可以面向 PersonDao 编程：

```java
@Service
public class PersonServiceImpl implements PersonService {

    @Autowired
    private PersonDao personDao;

    @Override
    public List<Person> get() {
        return personDao.get();
    }

    @Override
    public Person get(int id) {
        return personDao.get(id);
    }

    @Override
    public void add(int id, String name) {
        personDao.add(id, name);
    }

    @Override
    public void delete(int id) {
        personDao.delete(id);
    }
}
```

这样的做的好处是，把 Service 层和 Dao 层做到了权责分离，Service 层可以引入更多的业务逻辑，而 Dao 层则只关心数据的存取。同时由于是面向接口编程，Dao 层的具体实现也可以很灵活。

下面我们基于 SQLite 和 Spring 本身的 Dao 支持实现一个简单的 Dao 层。

首先在 pom.xml 中加入有关依赖：

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>4.3.9.RELEASE</version>
</dependency>

<dependency>
    <groupId>org.xerial</groupId>
    <artifactId>sqlite-jdbc</artifactId>
    <version>3.8.11.2</version>
</dependency>
```

然后实现我们的 Dao 层：

```java
@Repository
public class PersonDaoImpl implements PersonDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public PersonDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    public List<Person> get() {
        String sql = "select * from person";
        return this.jdbcTemplate.query(sql, ROW_MAPPER);
    }

    @Override
    public Person get(int id) {
        String sql = "select * from person where id = ?";
        try {
            return this.jdbcTemplate.queryForObject(sql, new Object[]{id}, ROW_MAPPER);
        }
        catch (EmptyResultDataAccessException e)
        {
            return null;
        }
    }

    @Override
    public void add(int id, String name) {
        String sql = "insert into person values (?, ?)";
        this.jdbcTemplate.update(sql, id, name);
    }

    @Override
    public void delete(int id) {
        String sql = "delete from person where id = ?";
        this.jdbcTemplate.update(sql, id);
    }

    private static final RowMapper<Person> ROW_MAPPER = (rs, rowNum) -> new Person(
            rs.getInt("id"),
            rs.getString("name"));
}
```

在 AppConfig 中加入数据库的配置：

```java
@Configuration
@EnableWebMvc
@ComponentScan("com.skyline")
public class AppConfig {

    @Bean
    DataSource getDataSource()
    {
        SQLiteDataSource dataSource = new SQLiteDataSource();
        dataSource.setUrl("jdbc:sqlite:D:/mydata.db");
        return dataSource;
    }
}
```

当然这里要求数据库是提前建好的，使用了下面的 schema：

```sql
CREATE TABLE person(id INTEGER, name VARCHAR);
```

将编译生成的 class 文件和依赖 jar 包（spring-jdbc，spring-tx，sqlite-jdbc）拷贝到 Tomcat 目录下，运行 Tomcat。使用 Curl 或者浏览器就可以测试我们的 Rest 服务了。


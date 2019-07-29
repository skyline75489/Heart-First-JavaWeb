## 第一个 JSP 程序

使用 Servlet 我们就可以生成简单的网页了，例如：

```java
package com.skyline;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

public class MyFirstServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.getWriter().write("<html>");
        response.getWriter().write("<body>");
        response.getWriter().write("<h2>");
        response.getWriter().write(LocalDateTime.now().toString());
        response.getWriter().write("</h2>");
        response.getWriter().write("</body>");
        response.getWriter().write("</html>");
    }
}
```

注意我们使用了 `HttpServlet` 而不是前一个例子中的 `Servlet`，它是一个更高级的封装类。

可以看到，直接使用 Servlet 生成网页，不仅代码写起来困难，可维护性也不高。为了把 HTML 这些非逻辑的部分抽离出来，人们引入了 JSP 技术。

JSP，全称 JavaServer Pages。可以把 JSP 理解成一种高度抽象的 Servlet。事实上 JSP 在运行期间会被编译成 Servlet，因此 JSP 和 Servlet 可以认为没有本质上的差异，只不过写起来容易了很多。  

> 现在流行的 Web 服务架构往往采用前后端分离的设计，JSP 这种使用后端模板的技术也逐渐被淘汰了。感兴趣的同学可以查阅“前后端分离”有关资料，这里不再赘述。

前面提到的 Tomcat 不仅支持了 Servlet，也支持了 JSP 技术。下面我们使用 JSP 重写上面的程序。

通过前一个例子我们可以看到，现在工程目录下的 `WEB-INF` 没有实质上的作用，只是为了拷贝到 Tomcat 的部署目录下。因此如果你嫌麻烦，直接在 Tomcat 部署目录下操作也可以。

我们在 `WEB-INF` 隔壁创建一个 `date.jsp` 文件：

```jsp
<%@ page import="java.time.LocalDateTime" %>
<html>
<body>
<h2>
<%
out.write(LocalDateTime.now().toString());
%>
</h2>
</body>
</html>
```

通过浏览器访问：

![result](https://raw.githubusercontent.com/skyline75489/Heart-First-JavaWeb/master/img/3-jsp-result.png)

可以看到效果和使用纯 Servlet 是完全一样的。


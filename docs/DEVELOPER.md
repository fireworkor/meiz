# 美妆店智慧管理系统 - 开发指南

## 1. 开发环境搭建

### 1.1 开发工具推荐

| 工具 | 用途 | 官网 |
|------|------|------|
| IntelliJ IDEA | Java后端开发 | https://www.jetbrains.com/idea/ |
| VS Code | 前端开发 | https://code.visualstudio.com/ |
| DataGrip | 数据库客户端 | https://www.jetbrains.com/datagrip/ |
| Postman | API测试 | https://www.postman.com/ |
| Git | 版本控制 | https://git-scm.com/ |
| Navicat | 数据库管理 | https://www.navicat.com/ |

### 1.2 环境配置

**JDK配置：**
```bash
# 设置JAVA_HOME
export JAVA_HOME=/path/to/jdk1.8.0_311
export PATH=$JAVA_HOME/bin:$PATH

# 验证
java -version
```

**Maven配置（settings.xml）：**
```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <name>Aliyun Maven</name>
    <url>https://maven.aliyun.com/repository/central</url>
  </mirror>
</mirrors>
```

**Node.js配置：**
```bash
# 设置npm镜像
npm config set registry https://registry.npmmirror.com

# 验证
npm -v
node -v
```

### 1.3 导入项目

**IntelliJ IDEA导入后端项目：**
1. File → Open → 选择 `java-backend` 文件夹
2. 选择 Maven 项目类型
3. 等待依赖下载完成
4. 配置项目SDK为JDK 8

**VS Code导入前端项目：**
1. File → Open Folder → 选择 `uniapp-frontend` 文件夹
2. 安装推荐插件（Vue - Official, ESLint等）

---

## 2. 项目结构说明

### 2.1 后端项目结构

```
java-backend/
├── src/main/java/com/beautyshop/
│   ├── Application.java              # 启动类
│   ├── config/                       # 配置类
│   │   └── SecurityConfig.java      # 安全配置
│   ├── controller/                   # 控制器层
│   │   └── *Controller.java         # REST接口
│   ├── dto/                          # 数据传输对象
│   │   └── *Request/*Response.java  # 请求/响应DTO
│   ├── entity/                       # 实体类
│   │   └── *.java                    # JPA实体
│   ├── repository/                   # 数据访问层
│   │   └── *Repository.java         # JPA Repository
│   └── service/                      # 业务逻辑层
│       ├── *Service.java            # 服务接口
│       └── impl/*ServiceImpl.java   # 服务实现
├── src/main/resources/
│   └── application.properties        # 应用配置
└── pom.xml                           # Maven依赖
```

### 2.2 前端项目结构

```
uniapp-frontend/
├── src/
│   ├── api/                         # API接口封装
│   │   └── index.js                 # 请求工具
│   ├── pages/                       # 页面组件
│   │   ├── admin/                  # 管理端页面
│   │   ├── staff/                 # 员工端页面
│   │   ├── customer/              # 顾客端页面
│   │   └── login/                 # 登录页面
│   ├── router/                     # 路由配置
│   │   └── index.js
│   ├── utils/                      # 工具函数
│   │   └── request.js            # 请求封装
│   ├── App.vue                    # 根组件
│   └── main.js                    # 入口文件
├── pages.json                      # uniapp页面配置
├── vite.config.js                  # Vite配置
└── package.json                    # NPM依赖
```

---

## 3. 代码开发规范

### 3.1 后端开发规范

**命名规范：**

| 类型 | 规范 | 示例 |
|------|------|------|
| 类名 | UpperCamelCase | `UserController` |
| 方法名 | lowerCamelCase | `getUserById` |
| 变量名 | lowerCamelCase | `userName` |
| 常量 | UPPER_SNAKE_CASE | `MAX_COUNT` |
| 包名 | lowercase | `com.beautyshop.service` |
| 数据库表名 | snake_case | `sys_user` |
| 数据库字段 | snake_case | `user_name` |

**Controller规范：**
```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        return Result.success(userService.getUserById(id));
    }

    @PostMapping
    public Result<Void> createUser(@RequestBody @Valid UserRequest request) {
        userService.createUser(request);
        return Result.success();
    }
}
```

**Service规范：**
```java
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public User createUser(UserRequest request) {
        // 参数校验
        if (StringUtils.isBlank(request.getUsername())) {
            throw new BusinessException("用户名不能为空");
        }

        // 业务逻辑
        User user = new User();
        user.setUsername(request.getUsername());
        // ... 其他字段

        return userRepository.save(user);
    }
}
```

**Repository规范：**
```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    boolean existsByPhone(String phone);

    List<User> findByRoleAndStatus(String role, String status);
}
```

### 3.2 前端开发规范

**组件命名：**
- 组件文件：PascalCase，如 `UserList.vue`
- 组件引用：kebab-case，如 `<user-list>`

**代码格式：**
```javascript
// 变量声明
const name = ref('')
const list = reactive([])
const loading = computed(() => list.value.length === 0)

// 方法定义
const handleSubmit = async () => {
  loading.value = true
  try {
    const res = await request.post('/api/users', formData)
    uni.showToast({ title: '提交成功' })
  } catch (error) {
    uni.showToast({ title: error.message, icon: 'none' })
  } finally {
    loading.value = false
  }
}
```

**API封装：**
```javascript
// api/index.js
export const userApi = {
  login: (data) => request.post('/users/login', data),
  getUserById: (id) => request.get(`/users/${id}`),
  createUser: (data) => request.post('/users', data),
  updateUser: (id, data) => request.put(`/users/${id}`, data),
  deleteUser: (id) => request.delete(`/users/${id}`)
}
```

---

## 4. 常用开发命令

### 4.1 后端命令

```bash
# 清理并构建
mvn clean package

# 运行（跳过测试）
mvn clean package -DskipTests

# 运行测试
mvn test

# 跳过测试运行
mvn spring-boot:run -DskipTests

# 查看依赖树
mvn dependency:tree

# 升级依赖版本
mvn versions:display-dependency-updates
```

### 4.2 前端命令

```bash
# 安装依赖
npm install

# 开发模式运行
npm run dev

# 生产构建
npm run build

# 代码检查
npm run lint

# 修复代码格式
npm run lint -- --fix
```

---

## 5. 调试技巧

### 5.1 后端调试

**日志调试：**
```java
// 使用Lombok的@Slf4j
@Slf4j
public class UserService {

    public void createUser(UserRequest request) {
        log.info("创建用户请求：{}", request);
        // 业务逻辑
        log.info("创建用户成功：{}", user.getId());
    }
}
```

**配置文件启用日志：**
```properties
logging.level.com.beautyshop=DEBUG
logging.level.org.springframework.web=INFO
```

### 5.2 前端调试

**Console调试：**
```javascript
console.log('变量值:', value)
console.error('错误:', error)

// 格式化输出
console.table(dataList)
```

**网络请求调试：**
```javascript
// 在request.js中添加拦截器
uni.addInterceptor('request', {
  invoke(config) {
    console.log('请求地址:', config.url)
    console.log('请求参数:', config.data)
    return config
  },
  success(result) {
    console.log('响应结果:', result)
    return result
  }
})
```

---

## 6. 数据库操作

### 6.1 常用SQL

```sql
-- 查询用户及其关联信息
SELECT u.*, e.* FROM users u
LEFT JOIN employees e ON u.id = e.user_id
WHERE u.role = 'staff';

-- 统计每日订单
SELECT DATE(order_date) as date, COUNT(*), SUM(total_amount)
FROM orders
GROUP BY DATE(order_date)
ORDER BY date DESC;

-- 查询低库存商品
SELECT p.*, i.quantity FROM products p
JOIN inventory i ON p.id = i.product_id
WHERE i.quantity < 10;
```

### 6.2 JPA查询方法

```java
// 方法名查询
List<User> findByRole(String role);
List<User> findByRoleAndStatus(String role, String status);
List<User> findByUsernameContaining(String keyword);

// @Query注解查询
@Query("SELECT u FROM User u WHERE u.role = :role AND u.status = :status")
List<User> findByRoleAndStatusQuery(@Param("role") String role, @Param("status") String status);

// 原生SQL查询
@Query(value = "SELECT * FROM users WHERE role = :role", nativeQuery = true)
List<User> findByRoleNative(@Param("role") String role);
```

---

## 7. 业务扩展指南

### 7.1 新增功能模块

**步骤1：创建实体类**
```java
@Entity
@Table(name = "new_entities")
public class NewEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    // getters and setters
}
```

**步骤2：创建Repository**
```java
@Repository
public interface NewEntityRepository extends JpaRepository<NewEntity, Long> {
    List<NewEntity> findByNameContaining(String keyword);
}
```

**步骤3：创建Service**
```java
@Service
public class NewEntityService {

    @Autowired
    private NewEntityRepository repository;

    public List<NewEntity> searchByName(String keyword) {
        return repository.findByNameContaining(keyword);
    }
}
```

**步骤4：创建Controller**
```java
@RestController
@RequestMapping("/api/new-entities")
public class NewEntityController {

    @Autowired
    private NewEntityService service;

    @GetMapping
    public Result<List<NewEntity>> search(@RequestParam String keyword) {
        return Result.success(service.searchByName(keyword));
    }
}
```

**步骤5：创建前端页面**
- 在 `pages/` 下创建目录和Vue文件
- 在 `pages.json` 中注册页面路由
- 在 `api/index.js` 中封装API方法

### 7.2 新增业务规则

**示例：添加订单优惠计算规则**

1. 在OrderService中添加计算方法：
```java
public BigDecimal calculateDiscount(Order order, BigDecimal totalAmount) {
    BigDecimal discount = BigDecimal.ZERO;

    // 会员折扣
    Member member = memberService.getMemberByCustomerId(order.getCustomerId());
    if (member != null) {
        discount = discount.add(calculateMemberDiscount(member, totalAmount));
    }

    // 优惠券折扣
    if (order.getCouponId() != null) {
        discount = discount.add(calculateCouponDiscount(order.getCouponId(), totalAmount));
    }

    // 积分抵扣
    if (order.getUsePoints() != null && order.getUsePoints() > 0) {
        discount = discount.add(calculatePointsDiscount(order.getUsePoints()));
    }

    return discount;
}
```

---

## 8. 测试指南

### 8.1 后端单元测试

```java
@SpringBootTest
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @MockBean
    private UserRepository userRepository;

    @Test
    public void testCreateUser() {
        UserRequest request = new UserRequest();
        request.setUsername("test");
        request.setPassword("123456");

        User user = new User();
        user.setId(1L);
        user.setUsername("test");

        when(userRepository.save(any(User.class))).thenReturn(user);

        User result = userService.createUser(request);
        assertNotNull(result);
        assertEquals("test", result.getUsername());
    }
}
```

### 8.2 前端组件测试

```javascript
import { mount } from '@vue/test-utils'
import UserForm from './UserForm.vue'

describe('UserForm.vue', () => {
  it('renders form fields', () => {
    const wrapper = mount(UserForm)
    expect(wrapper.find('input[type="text"]').exists()).toBe(true)
    expect(wrapper.find('button').exists()).toBe(true)
  })

  it('validates required fields', async () => {
    const wrapper = mount(UserForm)
    await wrapper.find('form').trigger('submit')
    expect(wrapper.find('.error').text()).toBe('用户名不能为空')
  })
})
```

---

## 9. 版本控制

### 9.1 Git工作流程

```
master (生产环境)
    │
    ├── develop (开发分支)
    │       │
    │       ├── feature/user模块
    │       ├── feature/order模块
    │       └── bugfix/修复问题
    │
    └── release (发布分支)
```

### 9.2 Git命令

```bash
# 创建功能分支
git checkout -b feature/new-feature develop

# 提交代码
git add .
git commit -m "feat: 新增用户模块功能"

# 合并到开发分支
git checkout develop
git merge feature/new-feature

# 创建发布分支
git checkout -b release/1.0.0 master

# 打标签
git tag -a v1.0.0 -m "版本1.0.0"
```

### 9.3 提交信息规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

---

## 10. 常用工具类

### 10.1 后端工具类

**Result统一响应：**
```java
public class Result<T> {
    private boolean success;
    private String message;
    private T data;

    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setSuccess(true);
        result.setMessage("操作成功");
        result.setData(data);
        return result;
    }

    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.setSuccess(false);
        result.setMessage(message);
        return result;
    }
}
```

**日期工具类：**
```java
public class DateUtils {
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    public static String formatDate(LocalDate date) {
        return date.format(DateTimeFormatter.ofPattern(DATE_FORMAT));
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime.format(DateTimeFormatter.ofPattern(DATETIME_FORMAT));
    }
}
```

### 10.2 前端工具类

**请求封装：**
```javascript
const request = (options) => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: BASE_URL + options.url,
      method: options.method || 'GET',
      data: options.data,
      header: {
        'Content-Type': 'application/json',
        'Authorization': uni.getStorageSync('token') || ''
      },
      success: (res) => {
        if (res.data.success) {
          resolve(res.data)
        } else {
          uni.showToast({ title: res.data.message, icon: 'none' })
          reject(res.data)
        }
      },
      fail: (err) => {
        uni.showToast({ title: '网络请求失败', icon: 'none' })
        reject(err)
      }
    })
  })
}
```

---

## 11. 常见问题排查

### 11.1 后端问题

| 问题 | 可能原因 | 解决方案 |
|------|----------|----------|
| 启动报错 | 端口占用 | 更换端口或关闭占用进程 |
| 数据库连接失败 | 配置错误 | 检查数据库配置 |
| 接口404 | 路径错误 | 检查Controller路径 |
| 接口500 | 代码异常 | 查看控制台日志 |

### 11.2 前端问题

| 问题 | 可能原因 | 解决方案 |
|------|----------|----------|
| 页面空白 | JS错误 | 打开控制台查看错误 |
| 请求失败 | 跨域问题 | 配置后端跨域 |
| 样式错乱 | CSS冲突 | 检查样式命名 |
| 数据不更新 | 响应式问题 | 检查ref/reactive使用 |

---

## 12. 附录

### 12.1 相关资源链接

- Spring Boot文档: https://docs.spring.io/spring-boot/docs/
- Spring Data JPA文档: https://docs.spring.io/spring-data/jpa/docs/
- Vue.js文档: https://vuejs.org/guide/
- uni-app文档: https://uniapp.dcloud.io/
- MySQL文档: https://dev.mysql.com/doc/

### 12.2 技术交流群

如有开发问题，请联系项目维护者或加入技术交流群讨论。

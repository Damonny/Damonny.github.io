<h1>Java实现代理模式</h1>
<hr />
<p>title:Java实现代理模式</p>
<hr />
<p>1、代理模式</p>
<hr />
<p>代理模式是一种比较好理解的设计模式。简单来说就是 我们使用代理对象来代替对真实对象(real object)的访问，这样就可以在不修改原目标对象的前提下，提供额外的功能操作，扩展目标对象的功能。</p>
<p>代理模式的主要作用是扩展目标对象的功能，比如说在目标对象的某个方法执行前后你可以增加一些自定义的操作。</p>
<p>代理模式有<strong>静态代理</strong>和<strong>动态代理</strong>两种实现方式。</p>
<p>2、静态代理</p>
<hr />
<p>静态代理中，我们对目标对象的每个方法的增强都是手动完成的（后面会具体演示代码），非常不灵活（比如接口一旦新增加方法，目标对象和代理对象都要进行修改）且麻烦(需要对每个目标类都单独写一个代理类)。 实际应用场景非常非常少，日常开发几乎看不到使用静态代理的场景。</p>
<p>上面我们是从实现和应用角度来说的静态代理，从 JVM 层面来说， 静态代理在编译时就将接口、实现类、代理类这些都变成了一个个实际的 class 文件。</p>
<p>下面通过代码展示！ <strong>1</strong>​ **.<strong>​ ** 定义发送短信的接口</strong></p>
<pre><code class="language-java">public interface SmsService {
    String send(String message);
}
</code></pre>
<h5><strong>2</strong>​ **.<strong>​ ** 实现发送短信的接口</strong></h5>
<pre><code class="language-java">public class SmsServiceImpl implements SmsService {
    public String send(String message) {
        System.out.println(&quot;真实的 send message : &quot; + message);
        return message;
    }
}
</code></pre>
<h5><strong>3</strong>​ **.<strong>​ ** 创建代理类并同样实现发送短信的接口</strong></h5>
<pre><code class="language-java">public class SmsProxy implements SmsService {
 
    private final SmsService smsService;
 
    public SmsProxy(SmsService smsService) {
        this.smsService = smsService;
    }
 
    @Override
    public String send(String message) {
        //调用方法之前，我们可以添加自己的操作
        System.out.println(&quot;静态代理 before method send()&quot;);
        smsService.send(message);
        //调用方法之后，我们同样可以添加自己的操作
        System.out.println(&quot;静态代理 after method send()&quot;);
        return message;
    }
}
</code></pre>
<h5><strong>4</strong>​ **.<strong>​ ** 实际使用</strong></h5>
<pre><code class="language-java">public class 静态代理和动态代理 {
    public static void main(String[] args) {
        // 静态代理
        SmsService smsService = new SmsServiceImpl();
        SmsProxy smsProxy = new SmsProxy(smsService);
        smsProxy.send(&quot;java&quot;);
    }
}
</code></pre>
<h5>5.执行结果：</h5>
<pre><code class="language-java">静态代理 before method send()
真实的 send message : java
静态代理 after method send()
</code></pre>
<p>3、动态代理</p>
<hr />
<p>相比于静态代理来说，动态代理更加灵活。我们不需要针对每个目标类都单独创建一个代理类，并且也不需要我们必须实现接口，我们可以直接代理实现类(CGLIB动态代理机制)。</p>
<p>从 JVM 角度来说，动态代理是在运行时动态生成类字节码，并加载到 JVM 中的。</p>
<p>说到动态代理，Spring AOP、RPC 框架应该是两个不得不提的，它们的实现都依赖了动态代理。</p>
<p>动态代理在我们日常开发中使用的相对较少，但是在框架中的几乎是必用的一门技术。学会了动态代理之后，对于我们理解和学习各种框架的原理也非常有帮助。</p>
<p>就 Java 来说，动态代理的实现方式有很多种，比如 JDK 动态代理、CGLIB 动态代理等等。</p>
<p>guide-rpc-framework使用的是 JDK 动态代理，我们先来看看 JDK 动态代理的使用。</p>
<p>另外，虽然 guide-rpc-framework 没有用到 CGLIB 动态代理 ，我们这里还是简单介绍一下其使用以及和JDK 动态代理的对比。</p>
<h3>3.1 JDK 动态代理机制</h3>
<h4>3.1.1 介绍</h4>
<p>在 Java 动态代理机制中 <code>*InvocationHandler*</code> 接口和 Proxy 类是核心。</p>
<p>Proxy 类中使用频率最高的方法是：newProxyInstance() ，这个方法主要用来生成一个代理对象。</p>
<pre><code class="language-java">    public static Object newProxyInstance(ClassLoader loader,
                                          Class&lt;?&gt;[] interfaces,
                                          InvocationHandler h)
        throws IllegalArgumentException
    {
        .......
    }
</code></pre>
<p>这个方法一共有 3 个参数：</p>
<ol>
<li>**loader：**类加载器，用于加载代理对象。</li>
<li>**interfaces：**被代理类实现的一些接口；</li>
<li>**h：**实现了 <code>InvocationHandler</code> 接口的对象；</li>
</ol>
<p>要实现动态代理的话，还必须需要实现InvocationHandler 来自定义处理逻辑。 当我们的动态代理对象调用一个方法时，这个方法的调用就会被转发到实现InvocationHandler 接口类的 invoke 方法来调用。</p>
<pre><code class="language-java">public interface InvocationHandler {
    // 当你使用代理对象调用方法的时候实际会调用到这个方法
    public Object invoke(Object proxy, Method method, Object[] args)
        throws Throwable;
}
</code></pre>
<p><code>invoke()</code> 方法有下面三个参数：</p>
<ol>
<li>**proxy：**动态生成的代理类</li>
<li>**methoh：**与代理类对象调用的方法相对应</li>
<li>**args：**当前 method 方法的参数</li>
</ol>
<p>也就是说：你通过Proxy 类的 newProxyInstance() 创建的代理对象在调用方法的时候，实际会调用到实现InvocationHandler 接口的类的 invoke()方法。 你可以在 invoke() 方法中自定义处理逻辑，比如在方法执行前后做什么事情。</p>
<h5>3.1.2 JDK 动态代理类使用步骤</h5>
<p>定义一个接口及其实现类； 自定义 InvocationHandler 并重写invoke方法，在 invoke 方法中我们会调用原生方法（被代理类的方法）并自定义一些处理逻辑； 通过 Proxy.newProxyInstance(ClassLoader loader,Class&lt;?&gt;[] interfaces,InvocationHandler h) 方法创建代理对象；</p>
<h5>3.1.2 代码示例</h5>
<ol>
<li>定义发送短信的接口</li>
</ol>
<pre><code class="language-java">public interface SmsService {
    String send(String message);
}
</code></pre>
<ol>
<li>实现发送短信的接口</li>
</ol>
<pre><code class="language-java">public class SmsServiceImpl implements SmsService {
    public String send(String message) {
        System.out.println(&quot;真实的 send message : &quot; + message);
        return message;
    }
}
</code></pre>
<ol>
<li>定义一个JDK动态代理类</li>
</ol>
<pre><code class="language-java">public class DebugInvocationHandler implements InvocationHandler {
    // 代理类中的真实对象
    private final Object target;
 
    public DebugInvocationHandler(Object target) {
        this.target = target;
    }
 
    public Object invoke(Object proxy, Method method, Object[] args) throws InvocationTargetException, IllegalAccessException {
        //调用方法之前，我们可以添加自己的操作
        System.out.println(&quot;JDK动态代理 before method &quot; + method.getName());
        Object result = method.invoke(target, args);
        //调用方法之后，我们同样可以添加自己的操作
        System.out.println(&quot;JDK动态代理 after method &quot; + method.getName());
        return result;
    }
}
</code></pre>
<ol>
<li>获取代理对象的工厂类</li>
</ol>
<pre><code class="language-java">public class JdkProxyFactory {
    public static Object getProxy(Object target) {
        return Proxy.newProxyInstance(
            target.getClass().getClassLoader(), // 目标类的类加载
            target.getClass().getInterfaces(),  // 代理需要实现的接口，可指定多个
            new DebugInvocationHandler(target)   // 代理对象对应的自定义 InvocationHandler
        );
    }
}
</code></pre>
<ol>
<li>实际使用</li>
</ol>
<pre><code class="language-java">public class 静态代理和动态代理 {
    public static void main(String[] args) {
        SmsService smsService1 = (SmsService) JdkProxyFactory.getProxy(new SmsServiceImpl());
        smsService1.send(&quot;Java!&quot;);
    }
}
</code></pre>
<ol>
<li>执行结果：</li>
</ol>
<pre><code class="language-java">JDK动态代理 before method send
真实的 send message : Java!
JDK动态代理 after method send
</code></pre>
<h3>3.2. CGLIB 动态代理机制</h3>
<h4>3.2.1. 介绍</h4>
<p>JDK 动态代理有一个最致命的问题是其只能代理实现了接口的类。为了解决这个问题，我们可以用 CGLIB 动态代理机制来避免。</p>
<p>CGLIB(Code Generation Library)是一个基于ASM的字节码生成库，它允许我们在运行时对字节码进行修改和动态生成。CGLIB 通过继承方式实现代理。很多知名的开源框架都使用到了CGLIB， 例如 Spring 中的 AOP 模块中：如果目标对象实现了接口，则默认采用 JDK 动态代理，否则采用 CGLIB 动态代理。</p>
<p>在 CGLIB 动态代理机制中 MethodInterceptor 接口和 Enhancer 类是核心。</p>
<p>你需要自定义 MethodInterceptor 并重写 intercept 方法，intercept 用于拦截增强被代理类的方法。</p>
<pre><code class="language-java">public interface MethodInterceptor
extends Callback{
    // 拦截被代理类中的方法
    public Object intercept(Object obj, java.lang.reflect.Method method, Object[] args,
                               MethodProxy proxy) throws Throwable;
}
</code></pre>
<ol>
<li>**obj：**被代理的对象（需要增强的对象）</li>
<li>**method：**被拦截的方法（需要增强的方法）</li>
<li>**args：**方法入参</li>
<li>**proxy：**用于调用原始方法</li>
</ol>
<p>你可以通过 Enhancer类来动态获取被代理类，当代理类调用方法的时候，实际调用的是 MethodInterceptor 中的 intercept 方法。</p>
<h4>3.2.2. CGLIB 动态代理类使用步骤</h4>
<ol>
<li>定义一个类；</li>
<li>自定义 <code>MethodInterceptor</code> 并重写 <code>intercept</code> 方法，<code>intercept</code> 用于拦截增强被代理类的方法，和 JDK 动态代理中的 <code>invoke</code> 方法类似；</li>
<li>通过 <code>Enhancer</code> 类的 <code>create()</code>创建代理类；</li>
</ol>
<h4>3.2.3. 代码示例</h4>
<p>不同于 JDK 动态代理不需要额外的依赖。CGLIB(Code Generation Library) 实际是属于一个开源项目，如果你要使用它的话，需要手动添加相关依赖。</p>
<pre><code class="language-xml">&lt;dependency&gt;
  &lt;groupId&gt;cglib&lt;/groupId&gt;
  &lt;artifactId&gt;cglib&lt;/artifactId&gt;
  &lt;version&gt;3.3.0&lt;/version&gt;
&lt;/dependency&gt;
</code></pre>
<ol>
<li>实现一个使用阿里云发送短信的类</li>
</ol>
<pre><code class="language-java">public class AliSmsService {
    public String send(String message) {
        System.out.println(&quot;send message:&quot; + message);
        return message;
    }
}
</code></pre>
<ol>
<li>自定义 MethodInterceptor（方法拦截器）</li>
</ol>
<pre><code class="language-java">public class DebugMethodInterceptor implements MethodInterceptor {
    /**
     * @param o           代理对象（增强的对象）
     * @param method      被拦截的方法（需要增强的方法）
     * @param args        方法入参
     * @param methodProxy 用于调用原始方法
     */
    @Override
    public Object intercept(Object o, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
        //调用方法之前，我们可以添加自己的操作
        System.out.println(&quot;before method &quot; + method.getName());
        Object object = methodProxy.invokeSuper(o, args);
        //调用方法之后，我们同样可以添加自己的操作
        System.out.println(&quot;after method &quot; + method.getName());
        return object;
    }
}
</code></pre>
<ol>
<li>获取代理类</li>
</ol>
<pre><code class="language-java">public class CglibProxyFactory {
    public static Object getProxy(Class&lt;?&gt; clazz) {
        // 创建动态代理增强类
        Enhancer enhancer = new Enhancer();
        // 设置类加载器
        enhancer.setClassLoader(clazz.getClassLoader());
        // 设置被代理类
        enhancer.setSuperclass(clazz);
        // 设置方法拦截器
        enhancer.setCallback(new DebugMethodInterceptor());
        // 创建代理类
        return enhancer.create();
    }
}
</code></pre>
<ol>
<li>
<p>实际使用</p>
<pre><code class="language-java">public class 静态代理和动态代理 {
    public static void main(String[] args) {
        AliSmsService aliSmsService = (AliSmsService) CglibProxyFactory.getProxy(AliSmsService.class);
        aliSmsService.send(&quot;java&quot;);
    }
}
</code></pre>
</li>
<li>
<p>执行结果：</p>
</li>
</ol>
<pre><code class="language-java">before method send
send message:java
after method send
</code></pre>
<h4>3.3. JDK动态代理和CGLIB动态代理对比</h4>
<ol>
<li>JDK 动态代理只能代理实现了接口的类或者直接代理接口，而 CGLIB 可以代理未实现任何接口的类。 另外， CGLIB 动态代理是通过生成一个被代理类的子类来拦截被代理类的方法调用，因此不能代理声明为 final 类型的类和方法。</li>
<li>就二者的效率来说，大部分情况都是 JDK 动态代理更优秀，随着 JDK 版本的升级，这个优势更加明显。</li>
</ol>
<p>4、静态代理和动态代理的对比</p>
<hr />
<ol>
<li>灵活性：动态代理更加灵活，不需要必须实现接口，可以直接代理实现类，并且可以不需要针对每个目标类都创建一个代理类。另外，静态代理中，接口一旦新增加方法，目标对象和代理对象都要进行修改，这是非常麻烦的！</li>
<li>JVM 层面：静态代理在编译时就将接口、实现类、代理类这些都变成了一个个实际的class文件。而动态代理是在运行时动态生成类字节码，并加载到 JVM 中的。</li>
</ol>

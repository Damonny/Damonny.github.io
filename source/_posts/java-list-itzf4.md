---
title: Java List 分片工具类
date: '2024-12-30 10:58:24'
updated: '2024-12-30 11:01:28'
excerpt: >-
  本文介绍了如何使用Java将一个大List分片为多个小List，每个小List的大小为50。通过`subList`方法实现分片，具体步骤包括：确定原List大小、使用循环分组、获取子列表并复制到新ArrayList、处理边界情况等。代码示例展示了如何实现分组功能，并解释了关键点，如检查分组大小、处理边界情况等。注意事项包括`subList`返回的是动态视图、处理原List大小不能被整除的情况，以及多线程环境下的使用建议。该方法适用于需要将大List分组的场景。
tags:
  - Java
  - List
  - 分片
  - 分组
  - 工具类
categories:
  - java
  - 工具类
permalink: /post/java-list-itzf4.html
comments: true
toc: true
abbrlink: 14367
---

# Java List 分片工具类

为了将一个大的List分组为多个小的List，每个小List的大小为50，我们可以使用Java中的`subList`​方法来实现。以下是详细的实现步骤和代码示例：

### 实现步骤

1. **确定原List的大小**：获取原List的大小，以便确定需要分成多少个小组。
2. **使用循环分组**：使用一个循环，每次取50个元素，直到处理完整个原List。
3. **获取子列表并复制**：使用`subList`​方法获取子列表，并将其复制到一个新的ArrayList中，以避免与原List的关联。
4. **将新的ArrayList加入到结果List中**：将包含50个元素的新ArrayList加入到结果List中。
5. **处理边界情况**：确保循环的索引不会越界，避免`IndexOutOfBoundsException`​。

### 代码示例

```java
import java.util.ArrayList;
import java.util.List;

public class ListGrouping {

    public static <T> List<List<T>> groupList(List<T> originalList, int groupSize) {
        if (groupSize <= 0) {
            throw new IllegalArgumentException("Group size must be positive.");
        }
        List<List<T>> result = new ArrayList<>();
        int size = originalList.size();
        for (int i = 0; i < size; i += groupSize) {
            int endIndex = i + groupSize;
            if (endIndex > size) {
                endIndex = size;
            }
            List<T> sub = new ArrayList<>(originalList.subList(i, endIndex));
            result.add(sub);
        }
        return result;
    }

    public static void main(String[] args) {
        List<Integer> original = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            original.add(i);
        }
        List<List<Integer>> groups = groupList(original, 4);
        System.out.println(groups); // 输出: [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
    }
}
```

### 代码解释

* **groupList方法**：

  * 检查分组大小`groupSize`​是否为正数，如果是非正数则抛出异常。
  * 初始化结果List来存储分组后的子List。
  * 使用循环遍历原List，每次取`groupSize`​个元素，创建新的ArrayList并加入结果List中。
  * 处理边界情况，确保`endIndex`​不超过原List的大小。
* **main方法**：

  * 创建一个包含10个元素的原List。
  * 调用`groupList`​方法将原List分组，每组4个元素。
  * 打印分组结果。

### 注意事项

* **动态视图**：`subList`​返回的是原List的视图，直接使用可能影响原List的修改，因此需要复制到新的ArrayList中。
* **边界情况**：处理原List大小不能被`groupSize`​整除的情况，确保最后一组包含剩余的所有元素。
* **多线程环境**：如果在多线程环境下使用，确保原List在分组过程中不被修改，或者使用不可变的List。

通过以上方法，可以有效地将一个大的List分组为多个小的List，每个小List的大小为指定的值，例如50。

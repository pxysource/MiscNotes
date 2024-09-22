# 1 JSON简介

[JSON](https://baike.baidu.com/item/JSON)([JavaScript](https://baike.baidu.com/item/JavaScript) Object Notation, JS 对象简谱) 是一种轻量级的数据交换格式。它基于 [ECMAScript](https://baike.baidu.com/item/ECMAScript) (欧洲计算机协会制定的js规范)的一个子集，采用完全独立于编程语言的文本格式来存储和表示数据。简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。 易于人阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率。

# 2 JSON 语法规则

- JSON是一个标记符的序列。这套标记符包含六个构造字符、字符串、数字和三个字面名。

- JSON是一个序列化的对象或数组。

## 2.1 六个构造字符：

- begin-array = ws %x5B ws ; [ 左方括号

- begin-object = ws %x7B ws ; { 左大括号

- end-array = ws %x5D ws ; ] 右方括号

- end-object = ws %x7D ws ; } 右大括号

- name-separator = ws %x3A ws ; : 冒号

- value-separator = ws %x2C ws ; , 逗号

## 2.2 在这六个构造字符的前或后允许存在无意义的空白符(ws)**:**

- ws = *（%x20 ; //空格符

- %x09 ; //水平制表符

- %x0A ; //换行符

- %x0D） //回车符

## 2.3 JSON的值

- JSON的构成: ws 值 ws 

- 值可以是对象、数组、数字、字符串或者三个字面值(false、null、true)中的一个。值中的字面值中的英文必须使用小写。

- 对象由花括号括起来的，逗号分割的成员构成。

### 2.3.1 成员

- 成员是由逗号分割的键值对（字符串键和所对应的值）组成，如：

| 1    | {"name": "John Doe", "age": 18, "address": {"country" : "china", "zip-code": "10000"}} |
| ---- | ------------------------------------------------------------ |

### 2.3.2 数组

- 数组是由方括号括起来的一组值构成，如：

| 1    | [3, 1, 4, 1, 5, 9, 2, 6] |
| ---- | ------------------------ |

### 2.3.3 字符串与数字

- 字符串与C或者Java的字符串非常相似。字符串是由双引号包围的任意数量Unicode字符的集合，使用反斜线转义。一个字符（character）即一个单独的字符串（character string）。

- 数字也与C或者Java的数值非常相似。除去未曾使用的八进制与十六进制格式。除去一些编码细节。 

- 一些合法的JSON的实例：

| 1    | {"a": 1, "b": [1, 2, 3]} |
| ---- | ------------------------ |

| 1    | [1, 2, "3", {"a": 4}] |
| ---- | --------------------- |

| 1    | 3.14 |
| ---- | ---- |

| 1    | "plain_text" |
| ---- | ------------ |

### 2.3.4 常用类型

- 任何支持的类型都可以通过 JSON 来表示，例如字符串、数字、对象、数组等。但是对象和数组是比较特殊且常用的两种类型。

- 对象：对象在 JS 中是使用花括号包裹 {} 起来的内容，数据结构为 {key1：value1, key2：value2, ...} 的键值对结构。在面向对象的语言中，key 为对象的属性，value 为对应的值。键名可以使用整数和字符串来表示。值的类型可以是任意类型。

- 数组：数组在 JS 中是方括号 [] 包裹起来的内容，数据结构为 ["java", "javascript", "vb", ...] 的索引结构。在 JS 中，数组是一种比较特殊的数据类型，它也可以像对象那样使用键值对，但还是索引使用得多。同样，值的类型可以是任意类型。

# 3 实例比较

XML和JSON都使用[结构化方法](https://baike.baidu.com/item/结构化方法)来标记数据，下面来做一个简单的比较。

- 用XML表示中国部分省市数据如下：

```xml
<?xml version="1.0" encoding="utf-8"?>
<country>    
    <name>中国</name>    
    <province>        
        <name>黑龙江</name>        
        <cities>            
            <city>哈尔滨</city>            
            <city>大庆</city>        
        </cities>    
    </province>    
    <province>        
        <name>广东</name>       
        <cities>            
            <city>广州</city>            
            <city>深圳</city>            
            <city>珠海</city>       
        </cities>    
    </province>    
    <province>        
        <name>台湾</name>       
        <cities>            
            <city>台北</city>            
            <city>高雄</city>        
        </cities>    
    </province>    
    <province>        
        <name>新疆</name>        
        <cities>            
            <city>乌鲁木齐</city>        
        </cities>    
    </province>
</country>
```

- 用JSON表示如下：

```json
{  
    "name": "中国",  
    "province": [{    
        "name": "黑龙江",    
        "cities": {      
            "city": ["哈尔滨", "大庆"]    
        }  
    }, {    
        "name": "广东",    
        "cities": {      
            "city": ["广州", "深圳", "珠海"]    
        }  
    }, {    
        "name": "台湾",    
        "cities": {      
            "city": ["台北", "高雄"]    
        }  
    }, {    
        "name": "新疆",    
        "cities": {      
            "city": ["乌鲁木齐"]    
        }  
    }]
}
```

可以看到，JSON 简单的语法格式和清晰的层次结构明显要比 XML 容易阅读，并且在数据交换方面，由于 JSON 所使用的字符要比 XML 少得多，可以大大得节约传输数据所占用的带宽。
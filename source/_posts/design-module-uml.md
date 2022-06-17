---
title: 设计模式-UML图
date: 2021-08-07 16:39:19
tags: 设计模式
---

# UML 类图
用于描述类和类之间的静态关系，包括类之间的关 `依赖`, `泛化（继承）`，`实现`，`关联`，`聚合` 和 `组合`

## 依赖关系（Dependence）
一般使用 `----->` 表示依赖关系。依赖关系是类与类之间最基础的关系，只要在 A 类中使用 B 类，就表示 A B 之间存在依赖关系。`CraeteHuman -----> People` 表示类 `CreateHumam` 依赖类 `People`。 

```Java
public class People {
    String name;
    Integer age;
    Integer sex;
    public  People(String name,Integer age,Integer sex){
        this.name = name;
        this.age = age;
        this.sex = sex;
    }
}

public class CreateHuman {
    public  CreateHuman(People people){
        System.out.println(people);
    }
}

```

![Dependance](https://blogimage.lemonlife.top/20210808192757.png)

## 聚合关系（Aggregation）
聚合表示整体和部分的关系，常` A ◇—————> B`表示 `B` 是 `A` 的一部分。即只要在 A类中存在以成员变量形式存在的 B 类，就说明 A 与 B 之间存在聚合关系。对于人来说。性格特征是人的一部分。因此可以定义类 `Character`。` People ◇—————> Character`
```JAVA

public class Character {
    private String personality;

    public String getPersonality() {
        return personality;
    }

    public void setPersonality(String personality) {
        this.personality = personality;
    }
}

public class People {
    private Character character;

    public void setCharacter(Character character) {
        this.character = character;
    }
}
```
![聚合 Aggregation](https://blogimage.lemonlife.top/20210808214038.png)



## 组合（Composite）
组合表示某个部分是整体的易一部分，是一种更为特殊的聚合关系。A 类与 B 类总是同时创建同时销毁。例如现在每次创建一个`"善良"`的人。类 `Character` 和类 `People` 总是同时实例化。常用 `People ♦——————> Character`

```JAVA
public class Character {
    private String personality;

    public String getPersonality() {
        return personality;
    }

    public void setPersonality(String personality) {
        this.personality = personality;
    }

    public Character(String personality) {
        this.personality = personality;
    }

    @Override
    public String toString() {
        return "Character{" +
                "personality='" + personality + '\'' +
                '}';
    }
}

public class People {
    private Character character = new Character("善良");
    private  String name;

    public People(String name){
        this.name = name;
        this.character = character;
    }

    public static void main(String[] args) {
        People people = new People("张三");
        // People{character=Character{personality='善良'}, name='张三'}
        System.out.println(people);
    }

    @Override
    public String toString() {
        return "People{" +
                "character=" + character +
                ", name='" + name + '\'' +
                '}';
    }

}

```
![组合 Composite](https://blogimage.lemonlife.top/20210808214643.png)

## 泛化（继承）（Generalization）
类型 `A` 继承了类型 `B` 说明 A 于 B 存在继承关系。如 男性（`Man`）作为人类的一种继承自类 `People`。 

```JAVA
public class Man extends People {
    public Man(String name) {
        super(name);
    }
}
```

![继承 Generalization](https://blogimage.lemonlife.top/20210808215621.png)

## 实现关系 (Implementation)
实现一般是指类实现了某个特点的标准（接口）。如下 `PeopleInterface`规定了人有自我介绍（` `）的能力， `People` 实现了 `PeopleInterface` 拥有了自我介绍的能力。  
```JAVA
public interface PeopleInterface {
    public default void introduce(){};
}

public class People implements PeopleInterface {
    public String name;
    public Integer age;

    public People(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public void introduce() {
        System.out.println("I am " + name + " age is " + age);
    }

    public static void main(String[] args) {
        People zs = new People("张三",3);
//        I am 张三 age is 3
        zs.introduce();
    }
}
```
![实现 Implementation](http://blogimage.lemonlife.top/20210808222006.png)
## 关联关系 （Association）
表示类与类之间的联系。是一种特殊的依赖关系。相互之间的一种依赖关系。例如一个人（`People`）生病了可能需要多个医生 `Doctor` 配合治疗。同时医生可能也在治疗多个病人。这种类与类之间存在互相使用的场景。可以定义为关联关系，可以是一对一或者一对多的关系。

```JAVA
public class Doctor {
    public List<People> peoples;
}

public class People  {
   public List<Doctor> doctors;
}
``` 
![关联关系 Association](http://blogimage.lemonlife.top/20210808231122.png)
---
title: React 使用 immer
date: 2023-07-17 23:48:59
tags: 
 - React
 - 前端
---

## 不可变数据

在 React 中数据发生了变更组件就会重新渲染，为了更高效的判断数据是否变更，React 使用了不可变数据（浅比较），这就导致如果直接修改源数据，组件并不会重新渲染。 更新数据都是需要创建一个新的数据副本，下面我们来演示一下不可变数据

1.我们定义了一个 animal 相关的数据，在  useEffect 修改了 animal 的 name 属性。

```jsx
export default function Page() {
  const [animal, setAnimal] = useState({
    name: 'cat',
    body: {
      color: 'white',
    },
  });

  useEffect(() => {
    animal.name = 'dog';
    setAnimal(animal);
  }, []);

  console.log(JSON.stringify(animal, null, 2));

  return null;
}

```

![](https://p1.hfutonline.cn/a-img/20230729222808.png)

通过最终输出的结果可以看出来，数据并没有发生变更。是因为 React 底层采用的是不可变数据，直接修改数据，虽然影响了 animal 对象属性的值，但 animal 数据本身的内存地址并未发生变化，所以 setAnimal 不会触发数据更新。


2.为了数据能更新成功，我们需要创建一个新的对象并且把原有对象复制过来，再复写我们想更新的属性。

```jsx
  useEffect(() => {
    setAnimal({
      ...animal,
      name: 'dog',
    });
  }, []);

```
![](https://p1.hfutonline.cn/a-img/20230729222843.png)

输出显示这样可以更新成功。


3.假设我们想更新color 值，由于color属性位于嵌套对象的第二层。

```jsx
  useEffect(() => {
    animal.body.color = 'black';
    setAnimal({
      ...animal,
      name: 'dog',
    });
  }, []);

```

![](https://p1.hfutonline.cn/a-img/20230729223216.png)

通过操作看到数据确实更新了，在这个场景下看似正确，但是其实我们已经在不知不觉中埋下了一个错误。

4.这时候我们把案例变得复杂。我们增加一个 useEffect 希望能监听到 body 属性的变更。

```jsx
  useEffect(()=>{
    console.log("animal.body change", animal.body)
  }, [animal.body])

  useEffect(() => {
    animal.body.color = 'black';
    setAnimal({
      ...animal,
      name: 'dog',
    });
  }, []);

```
![](https://p1.hfutonline.cn/a-img/20230729223236.png)

由于代码直接修改了 body 的 color 属性，对于 body 这个对象来说他的内存地址是没有任何变化的，只是内部属性的值发生了变动。所以 useEffect 中的 console 只输出了 `color: white` color值被二次调整成 `black` 并未被监听到。

5.为了让 body 内部属性的变动可以被监听到，所以我们要再次修改 setAnimal 的逻辑，对于一个有嵌套层级的对象，如果我们要更新内层的某一个属性，一定要将对象每一层都要重新创建一遍（深拷贝）。

```jsx
  useEffect(()=>{
    console.log("animal.body change", animal.body)
  }, [animal.body])

  useEffect(() => {
    setAnimal({
      ...animal,
      name: 'dog',
      body: {
        ...animal.body,
        color: 'black',
      }
    });
  }, []);
```
![](https://p1.hfutonline.cn/a-img/20230729223305.png)

这样能准确的监听到 body 属性的变更。 这种方案有两个明显的缺点，1. 如果对象嵌套层数较多，需要按层解构，赋值，代码中会充斥这很多这样的模板代码。2. 为了更新某一个属性却要把所有的值都复制一次，会带来很多不必要的内存浪费 和 更频繁的 GC对应的CPU资源的浪费。

> 小程序完整代码

```jsx
export default function Page() {
  const [animal, setAnimal] = useState({
    name: 'cat',
    body: {
      color: 'white',
    },
  });
  
  useEffect(()=>{
    console.log("animal.body change", animal.body)
  }, [animal.body])

  useEffect(() => {
    setAnimal({
      ...animal,
      name: 'dog',
      body: {
        ...animal.body,
        color: 'black',
      }
    });
  }, []);

  console.log(JSON.stringify(animal, null, 2));

  return null;
}
```

为了解决不可变数据的更新问题，引入了 Immer 这一套解决方案 .

## 使用 Immer

> Immer 文档 [https://immerjs.github.io/immer/zh-CN/](https://immerjs.github.io/immer/zh-CN/)

immer 的基本思想是 通过对我们当前的数据 currentState 进行代理 生成 中间态 draftState，更新 drafState 中的数据，immer 会生成新的 nextState。
    
![](https://p1.hfutonline.cn/a-img/20230729223339.png)
    

```jsx
export default function Home() {
  const [currentData, setCurrentData] = useState<any>({ current: 1 });
  
  useEffect(() => {
    const nextData = produce(currentData, (draftData: any) => {
      draftData.current = 2;
    })
    setCurrentData(nextData);
  }, []);

  console.log('currentData.current', currentData.current);
  return null;
}

// 输出
// currentData.current 1
// currentData.current 2
```

- hooks 写法

```jsx
export default function Home() {
  const [currentData, setCurrentData] = useImmer<any>({ current: 1 });
  
  useEffect(() => {
    setCurrentData((draftState: any) => {
      draftState.current = 2;
    });
  }, []);

  console.log("currentData.current", currentData.current);
  return null;
}
```

接着我们使用 Immer 对之前的小程序进行改造

```jsx
export default function Page() {
  const [animal, setAnimal] = useImmer({
    name: 'cat',
    body: {
      color: 'white',
    },
  });

  useEffect(()=>{
    console.log("animal.body change", animal.body)
  }, [animal.body])

  useEffect(() => {
    setAnimal((draft)=> {
      draft.body.color = 'black'
    });
  }, []);

  console.log(JSON.stringify(animal, null, 2));

  return null;
}
```

同样的功能使用 immer 之后少了很多模板代码，程序变得整洁，而且也不容易出错。

## Immer 的特点

- 写时复制（Copy on Write）

```jsx
export default function Page() {
  const [data, setData] = useState({
    d1: { a: 1 },
    d2: { a: 2 },
    d3: { a: 3 },
  });

  const nextState = produce(data, (draftState: any) => {
    console.log(draftState.d1)
  });
  console.log("nextState === data", nextState === data);
  const nextState2 = produce(data, (draftState: any) => {
    draftState.d1.a = 4;
  });
  console.log("nextState2 === data", nextState2 === data);
  console.log("nextState2.d1 === data.d1", nextState2.d1 === data.d1);
  console.log("nextState2.d2 === data.d2", nextState2.d2 === data.d2);

  return null;
}

```
![](https://p1.hfutonline.cn/a-img/20230729223436.png)

immer 利用 Proxy 代理原对象，我们不对任何属性做修改时，nextState 和 data 的值相等，说明数据没有发生复制，当 draftState 发生了部分写入的时候，只有原对象的地址和发生修改的地方产生了数据复制，没有写入的部分数据并不会产生数据复制，相对于深拷贝更新来说能减少内存的占用，减少不必要的GC。

> buildData 函数

```jsx
const buildData = () => {
  let data: any = {};
  for (let i = 0; i < 1024 * 1024; i++) {
    data[`${i}`] = `${i}`;
  }
  return {
    data,
    data2: 0
  };
};
```

1.深拷贝更新数据时候内存图

```jsx
export default function Page() {
  const [state, setState] = useState<any>(buildData());
  useEffect(() => {
    const timer = setInterval(() => {
      setState((ctr: any) => {
        return {
          ...ctr,
          data: {
            ...ctr.data,
          },
          data2: 1
        };
      });
    }, 1000);
    return () => clearInterval(timer);
  }, []);
}
```
![](https://p1.hfutonline.cn/a-img/20230729223604.png)

2.使用 immer 之后的内存图

```jsx
export default function Page() {
  const [state, setState] = useImmer<any>(buildData());
  useEffect(() => {
    const timer = setInterval(() => {
      setState((ctr: any) => {
        ctr.data2 = 1;
      })
    }, 1000);
    return () => clearInterval(timer);
  }, []);
}
```

![](https://p1.hfutonline.cn/a-img/20230729223457.png)

> 虽然上面的例子看上去有些刻意，我的想法是能从逻辑上证明使用immer在某些场景下更新数据是能减少开发者的心智负担，减少程序出现的问题，有时还能减少程序内存的占用和减少CPU的消耗，至少使用immer 之后不会对程序造成太大的负面影响。

在学习的过程中，还发现了一个社区里面一次有趣的讨论 Redux Toolkit 团队不断有用户提 pr ，想要将 immer 变成可选的属性，开发着则认为 immer 对性能影响不大，而且帮助很大应该保留。

- Redux toolkit 社区的争论 https://github.com/reduxjs/redux-toolkit/issues/242
- immer 性能 [https://immerjs.github.io/immer/zh-CN/performance](https://immerjs.github.io/immer/zh-CN/performance)
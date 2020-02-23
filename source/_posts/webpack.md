---
title: Webpack教程~基础篇
date: 2020-02-23 14:30:31
tags:
  - 前端
  - webpack
---
### 基础概念
[官网安装方式](https://webpack.docschina.org/guides/installation/)

通过官网的指引安装好webpack,在项目根目录添加 `webpack.config.js` 的文件.
`webpack.config.js` 遵循的是 `commonJS` 规范,依次文件采用 `module.exports={[key]:[value]}` 的方式,来暴露具体的配置。

一个基本的webpack配置如下
```js
module.exports = {
  entry: "[xxx].js",
  output: {
    filename: 'xxxx.js',
    path: resolve(__dirname, 'xxx')
  },
  module: {
    rules: [
      {[key]:[value]}
    ]
  },
  plugins: [
    new PluginsName()
  ],
  mode: 'production | development'
}
```

[官网基础概念](https://webpack.docschina.org/concepts/)
#### Entry
指定webpack,打包的起始文件，根据此文件分析构建依赖关系图。

入口文件，可配置一个，也可以 `{[key]:[value]}` 的形式配置多个

#### Output
指示webpack打包后的资源，输出到哪里去，以及如何命名。

output的值是一个对象，指定了输出文件名，和文件路径，输出文件建议使用 path模块中的resolve即 `resolve(__dirname,xxx)`

在webpack中输出的文件名，如果你不想指定，可以取使用`[hash].扩展名`的形式，webpack在输出的时候，会自动指定hash值。

#### Loader

Webpack去处理那些非`Javascript`文件。(webpack本身只处理js和json数据)

对应webpack的字段是 `module`,里面指定了webpack各种的loader配置。形如
```json
  module: {
    rules: [
      {[key]:[value]}
    ]
  },
```
rules中的每一个对象，对应着一个处理某个文件的模块，为了处理某种文件，我们需要配置，匹配这个文件的正则表达式,形如 `test:/具体正则表达式/` ，和通过 `use:[loader-name]` 的形式指定 多个loader,如：处理css 文件，我们需要 `style-loader` 和 `css-loader` 。甚至有时候use数组里面，不只是 各个loader的名称，可能还需要修改一些loader的配置，就会采取对象的形式指定loader，如给css添加兼容性处理的情景

同一文件各种loader的处理顺序是自下而上的,css文件配置如下,文件会先经过 `css-loader` 处理,再经过`style-loader`处理。

```json
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      }
    ]
  },
```
上面引入的两种loader都是直接通过loader名称的形式引入的，按照对象的方式引入postcss-loader，对css做兼容性处理。

```json
  {
    test: /\.css$/,
    use: [
      'style-loader'
      'css-loader',
      {
        loader: 'postcss-loader',
        options: {
          ident: 'postcss',
          plugins: () => {
            require('postcss-preset-env')
          }
        }
      }
    ]
  },
```
当然最后要注意的是，这些loader都不是webpack，内置的，而是需要 通过npm 安装。具体的插件安装可看官网。建议大家和webpack有关的都安装在  `devDependencies` 下 。

#### Plugins
各种功能强大的工具，包括打包优化和压缩，甚至可以重新定义环境中的变量。插件相比于Loader可以做很多比Loader功能更强大的事。

插件和loader相同的是都需要先npm安装，不同的是，loader不需要引入，但是要在use里面写一些配置。而插件则是通过，先require 引入某个插件，然后再在plugins,实例化引入的插件对象即可。如果需要修改插件的默认配置，在实例化的时候，以对象的形式传入即可。

html 模板插件使用如下
```js
const HtmlWebpackPlugin = require('html-webpack-plugin')
module.exports = {
  entry: '......',
  output:'......',
  module:'......',
  plugins: [
    // 实例化require引入的插件 html-webpack-plugin
    //指定传入的HTML模板是src目录下的index.html文件
    new HtmlWebpackPlugin({
      template: './src/index.html'
    })
  ],
  mode: '.....'
}
```

#### Mode
模式分为 `development`开发环境，`production` 生产环境。
这大概是webpack最简洁的配置了，在`production` 模式下，会自动开启压缩js代码和 `tree shaking` 。

在未来的 webpack5中,只有在 `webpack.config.js` 文件中指定一个mode,就可以使用，上面的 `entry,output` 等配置,都变成了默认配置。

### webpack打包过程
1. 指定入口文件 entry
2. webpack会根据入口文件里面所有的依赖,形成依赖树，然后会根据依赖树中把所以需要的依赖引入，形成代码块(chunk),然后再根据不同的资源对应的loader,对代码块进行处理输出为 `bundles`.
   

### 处理css、less
```bash
npm install style-loader css-loader  -D
```
其中 css-loader 是为了把 css 文件变成commonJS模块，加载到JS中，style-loader是为了在JS解析的时候能创建style标签,把样式整合到style标签中，插入浏览器的head。

默认是有多少css，less 文件就会插入多少style标签，每个标签就是对应的css代码。

```bash
npm install less-loader -D 
```
安装less-loader处理less文件，注意loader在代码里面配置顺序是固定的，less文件必须要经过less-loader处理，才能被css-loader识别，同理最后才能被style-loader处理。

```
    rules: [
      {
        test: /\.css$/,
        use: [
          // 从下到上运行loader
          // 创建style标签，将js资源插入，添加到head生效
          'style-loader',
          // 将css 文件变成commonjs 模块加载到js中，里面内容 是样式字符串。
          'css-loader',
        ]
      },
      {
        test: /\.less$/,
        use: [
          'style-loader',
          'css-loader',
          'less-loader'
        ]
      }
    ]
```

把css,less文件提取合并，并且压缩一下形成单独的css,再通过link标签引入。目的是为了把css尽快的提供给浏览器，而不是放在js中，导致浏览器需要先解析js才能获取css,[具体原因见博客~浏览器](http://lemonlife.top/2020/02/23/web-fundamentals-optimize/),需要使用插件 mini-css-extract-plugin 
```js
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
```
把css文件和less文件配置中的,style-loader都替换成 `MiniCssExtractPlugin.loader`,在plugins中实例化插件并且制定输出文件路径,完整配置如下

```js
const { resolve } = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
module.exports = {
  entry: "./src/index.js",
  output: {
    filename: 'js/build.js',
    path: resolve(__dirname, 'build')
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
        ]
      },
      {
        test: /\.less$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'less-loader'
        ]
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/public/index.html'
    }),
    // [hash:10]制定文件名称取哈希值的前10位
    new MiniCssExtractPlugin({
      filename:"css/[hash:10].css"
    })
  ],
  mode: 'development'
}
```
压缩css,感觉就是去掉了css文件中的，空格注释，也可能去掉了一些写重复的样式吧，反正就是为了减少文件体积加快网络传输速度。需要用到插件`optimize-css-assets-webpack-plugin`

```bash
npm install optimize-css-assets-webpack-plugin -D
```
这个插件使用比较简单了,一样需要引入

`const OptimizeCssAssetsWebpackPlugin = require('optimize-css-assets-webpack-plugin')`

```
....
  plugins: [
    ....,
    new OptimizeCssAssetsWebpackPlugin()
  ]
.... 
```
### 处理HTML、图片、其他静态资源
```bash
npm install html-webpack-plugin -D
```
处理HTML文件需要使用 `html-webpack-plugin`,在plugins中实例化的时候，指定一下使用的模板，webpack会把输出的js通过script标签自动引入HTML中。

```js
// webpack处理 HTML
const { resolve } = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
module.exports = {
  entry: "./src/index.js",
  output: {
    filename: '/js/build.js',
    path: resolve(__dirname, 'build')
  },
  module: {
  },
  plugins: [
    new HtmlWebpackPlugin({
      //指定 src下的index.html 为HTML基础模板。
      template: './src/index.html'
    })
  ],
  mode: 'development'
}
```
处理图片资源的时候使用的是loader名称是`url-loader`,没有photo-loader😁😁😁,当然还要下载file-loader,因为url-loader依赖于file-loader

```bash
npm install file-loader url-loader -D
```
具体配置如下，可以解决commonJS import 图片资源，和css,less文件中url里面引用图片资源的问题。
```json
{
  test: /\.(jpg|png|gif|jpeg)$/,
  loader: 'url-loader',
  options: {
    // 图片小于8kb时候会被base64处理
    limit: 8 * 1024,
    // 给图片重新命名
    // ext 图片原来扩展名称
    name:'[hash:10].[ext]'
  }
},
```
如果还要处理HTML模板中引入图片的问题还需要使用 `html-loader`，
此时要注意修改一下之前url-loader的配置,因为url-loader默认使用es6模块化解析，而html-loader引入图片是commonjs,解析时会出问题：[object Module],需要在url-loader配置文件中，关闭url-loader的es6模块化，使用commonjs解析
```
npm install html-loader -D
```

```json
{
  test: /\.(jpg|png|gif|jpeg)$/,
  loader: 'url-loader',
  options: {
    limit: 8 * 1024,
    // 解决：关闭url-loader的es6模块化，使用commonjs解析
    esModule: false,
    name:'[hash:10].[ext]'
  },

},
{
  test: /\.html$/,
  loader: 'html-loader'
}
```
处理其他静态资源，比如字体图标文件等,需要安装file-loader,在之前安装url-loader的时候已经安装过file-loader了

```json
{
   // exclude 排除 前面被处理过的 css/js/html资源
   // 其他文件一律交给file-loader处理。
  exclude: /\.(css|js|html|less)$/,
  loader: 'file-loader',
  options: {
    name: '[hash:10].[ext]',
    // 指定其他资源都输出到static目录下
    outputPath: 'static'
  }
}
```
### css兼容性处理
面试的时候经常会被问到，浏览器兼容性问题，作为一个学生，目前我开发都是使用Chrome和Firefox，处理浏览器兼容性问题，也就是webpack配置一下。
兼容css需要用插件postcss-loader,和插件的的配置postcss-preset-env(当然也可采用,autoprefixer规则取代postcss-preset-env规则)
```bash
npm install postcss-loader postcss-preset-env -D
```
安装好插件，如果业务场景浏览器确定，可采用中 `package.json` 增加`browserslist`,来确定具体浏览器,至于browserslist的配置文件可看[github](https://github.com/browserslist/browserslist)

其中`development`,`production` 是指NodeJS环境(`process.env.NODE_ENV `),默认是production,而非webpack指定的mode。
```json
{
  "xxx":"xxx",
  "devDependencies": "xxxx",
  "browserslist": {
    "development": [
      "last 1 version",
      "> 1%",
      "IE 10"
    ],
    "production": [
      "> 0.2%",
      "not dead",
      "not op_mini all"
    ]
  }
}
```
具体配置如下
```js
const miniCssExtractPlugin = require('mini-css-extract-plugin')
//指定node环境为 development
process.env.NODE_ENV = 'development'
module.exports = {
  entry: "...",
  output: "....",
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          miniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              plugins: (loader) => [
                //也可以采用
                // require('postcss-preset-env')()
                require('autoprefixer')()
              ]
            }
          }
        ]
      },
    ]
  },
  plugins:".....",
  mode: '.....'
}
```
### devServer
配置devServer,相当于本地运行了一个NodeJS后来服务,需要安装插件`webpack-dev-server`,此时webpack编译的结果不会输出在我们指定的目录下，因为dev-server不输出文件，可以想象成文件放内存中，node服务可以访问到，因此我们手动刷新浏览器可以看到正确结果。
```
npm install webpack-dev-server -D
```
```js
module.exports = {
  ....,
  mode: '.....',
  devServer: {
    // 项目构建后路径
    contentBase: resolve(__dirname, 'build'),
    // 启动gzip压缩
    compress: true,
    // 端口号
    port: 3000,
    // 自动打开浏览器
    open: true
  }
};
```

此时我建议在 `package.json` 的 `script` 脚本中写入两条脚本，分别用于之前的打包模式和开启devServer 模式

```json
{
  ....,
  "scripts": {
    ....,
    "build": "webpack",
    "build:prod": "webpack --mode=production",
    "dev": "webpack-dev-server --open",
  },
  ....
}
```
通过运行 `npm run build` 或者`npm run build:prod` 获取之前类似的输出，`npm run dev` 开启webpack服务,此时还不支持热更新和自动刷新浏览器，需要手动刷新，才能看到结果。

> 更多devServer看 [官网配置](https://www.webpackjs.com/configuration/dev-server/)

###  Javascript代码兼容性
前面配置了css代码的兼容性处理，但是JS代码其实更需要兼容，JS不兼容可能就是无法运行。处理JS兼容当然就是`babel`家族。[babel官网](https://www.babeljs.cn/)

```
npm install @babel/cli @babel/core @babel/preset-env babel-loader -D

npm install @babel/plugin-transform-runtime  -D 

npm install @babel/plugin-proposal-class-properties -D

npm install @babel/runtime @babel/runtime-corejs2 --save
```
在项目根目录编写 `babel.config.js` 文件,写入如下配置
```js
module.exports = {
  "presets": [
       [
         "@babel/preset-env",
         //指定要兼容的浏览器，以及版本
         "targets": {
          "esmodules": true,
          "chrome": '60',
          "firefox": '60',
          "ie": '9',
          "safari": '10',
           "edge": '17'
          }
        ]
    ],
  "plugins": [
    ["@babel/plugin-transform-runtime", {
      "corejs": 2,
    }],
    "@babel/transform-arrow-functions",
    "@babel/plugin-proposal-class-properties"
  ]
}
```
在webpack.config.js中用babel处理js

```js
module.exports={
  entry:"....",
  output:"....",
  module:{
    rules:[
      { 
        // 匹配js和jsx文件
        test: /\.tsx?$/,
        use: ["babel-loader"],
        //排除node_modules里面的文件
        // 防止babel编译了，node_modules里面代码包。
        exclude: [join(__dirname, "node_modules")]
      }
    ]
  },
}

```
上面的babel配置 (我用的是[babel7](https://babeljs.io/docs/en/v7-migration)的配置) 是我上次配置ts的，不知道会不会出错，应该没有问题， `presets` 里面指定了`target`, `core-js` 部分没问题，应该就可以兼容ie。

> 我认为 webpack最好的教程是来源与官网，这是我看了官网和网上找的一些视频教程之后总结的一些基础操作，详细的配置可看 [webpack官网~中文](https://webpack.docschina.org/)，本文中部分文字来源于尚硅谷的视频，感谢尚硅谷老师的分享。【这不是广告只是为了声明版权😂】

>以上差不多就是 webpack的一些基本操作了,后面打算把webpack配置优化部分也补上，然后自己封装一个脚手架，再加上一些ESLint的配置,欢迎大家持续关注 [**http://lemonlife.top**](http://lemonlife.top/) 最近有点忙/(ㄒoㄒ)/~~
# zhvt-classic 中文线装书模板

本 $\LaTeX$ 中文线装书模板，按照较为常见的传统线装书排版格式，实现框线、书口、目录、序言、夹注等排版元素，支持书名页、图像和句读。

## 依赖宏包

本模板依赖`jiazhu.sty`宏包。该宏包尚未收录进$\TeX Live$，需要手动下载安装。

安装方法：[GitHub: CTeX-org/ctex-kit/issues/630](https://github.com/CTeX-org/ctex-kit/issues/630)

## 默认字体

本模板默认使用基于思源宋体修改的源流明体。请自行下载安装。

下载地址：[GitHub: ButTaiwan/genryu-font](https://github.com/ButTaiwan/genryu-font)

Windows 用户解压后右键点击选择“为所有用户安装”，否则可能报找不到字体的错误。

## 基本用法

```tex
\documentclass{zhvt-classic}

% 标题，可选参数设置标题叶显示标题
\title{大學章句}[大~學~章~句]
% 作者，可选
\author{宋新安朱文公章句並注}
% 制作者，可选
\maker{壬寅夏潤州江南布衣重製}

\begin{document}

% 标题叶，可选
\maketitle

% 目录叶，可选
\tableofcontents

% 无序号章标题
\chapter*[序]{大學章句序}
大學之書古之大學……

% 节标题
\section{賢聖之君}
及周之衰賢聖之君不作……

% 有序号标题，第一个可选参数留空取消书口标题显示
\chapter[]{大學章句}[大舊音泰今讀如字]

% 小序环境
\begin{preface}
子程子曰大學孔氏之遺書……
\end{preface}

% 【】夹注内容
大學之道在明明德在親民在止於至善【程子曰親當……】
知止而后有定定而后能靜

\end{document}
```

## 模板参数

本模板默认参照清武英殿版《明史》尺寸。

- 书：高九寸，宽六寸

- 文：高七寸，宽四寸五分

- 字：高三分，宽二分七厘，行四分五厘

- 每叶二十行，每面十行，每行二十一字

- 天头地脚：二比一

按照清光绪三十四年营造尺库平制，一营造尺折算 320 mm，计算相关参数。这些参数可在 导言区使用 `\zhvtset`设置，参数说明及默认值如下：

```tex
\zhvtset{
  % 正文字体，源流明体半粗
  main font           = GenRyuMin TW SB,
  % 正文字体高度，三分
  font size           = 9.6mm,
  % 行距，即基线间距，四分五厘
  baseline skip       = 14.4mm,
  % 夹注字体，源流明体
  jiazhu font         = GenRyuMin TW M,
  % 书宽，六寸
  book width          = 192mm,
  % 书高，九寸
  book height         = 288mm,
  % 单面行数
  page lines          = 10,
  % 每行字数
  line chars          = 21,
  % 天头地脚比例
  top bottom ratio    = 2,
  % 横排时，基线位于汉字下部。直排时，汉字与基线居中对齐。
  % 二者在视觉上出现位置偏移，这个偏移也影响到 LaTeX 绘图
  % 的坐标，需要微调予以补偿。
  % 微调比例按照公式“( 字高 - 总高 / 2 )  / 总高”计算
  % 对于思源系列字体而言，总高 1000，字深 120，字高 880
  micro adjust ratio  = 0.38,
  % 界栏线宽度，一厘
  grid line width     = 0.32mm,
  % 外框线宽度，六厘
  frame line width    = 1.92mm,
  % 界栏、外框间距，六厘
  frame sep           = 1.92mm,
  % 界栏颜色
  grid color          = red,
  % 小序缩进
  preface margin      = 2,
  % 章缩进
  chapter indent      = 1,
  % 节缩进
  section indent      = 2,
  % 书口标题字数
  shukou title chars  = 6,
  % 书口页码字数
  shukou page number chars = 4,
}
```

## 排版功能

### 图像

传统书籍基本上都是整面图像，基本上没有图文混排。本模板仅支持整面图像，不支持图文混排。插入图像根据需要手动分页，并且根据图像左右，设置界栏的绘制。

```tex
\clearpage % 开启新叶，图像位于正面
\grid{none}{all} % 指定右侧无界栏，左侧绘制全部界栏
\insertgraphic[<options>]{<path to image file>}
其他正文内容 % 此处位于背面
\clearpage % 开启另一叶
\gridall % 重新设置绘制全部界栏
```

选项与`\includegraphics`相同，该命令自动将图片置于页面正中，但不会自动调整大小和方向，请自行调整。

### 小序环境

章节标题与正文之间或者在段落节后插入的注释性文字，前者称为小序，后者称为尾注。本模板格式上不加以区分，顶部整体缩进 2 字符高度。

```tex
\begin{preface}
子程子曰大學孔氏之遺書……
\end{preface}
```

### 章节标题

章标题命令三个参数，其中两个可选参数。带 \* 号的命令，表示不编号。

```tex
\chapter[<书口显示的标题>] {<标题>} [<标题夹注>]
\chapter*[<书口显示的标题>] {<标题>} [<标题夹注>]
```

节标题命令两个参数，其中一个可选参数。带 * 号的命令，表示不编号。

```tex
\section{<标题>} [<标题夹注>]
\section*{<标题>} [<标题夹注>]
```

### 界栏

```tex
\grid{<正面界栏定义>}{<背面界栏定义>}
```

参数可以是 `none, all`，分别表示不绘制界栏和绘制所有界栏。或者是逗号分割数字列表，如`{2,8}`，表示绘制第2行和第8行之后绘制界栏，注意从右向左计数。

定义了两个快捷命令

```tex
\gridall   % 绘制所有界栏
\gridnone  % 不绘制所有界栏
\grid{2,8}{none} % 正面第2、8行后绘制界栏，背面不绘制界栏。标题叶界栏默认设置
```

### 标题叶

两个可选参数，分别定义正面、背面界栏。默认正面第2、3行和第8、9行之间绘制界栏，背面无界栏。

```tex
\maketitle[<正面界栏定义>][<正面界栏定义>]
```

默认布局：右侧作者栏顶部对齐；中间标题栏居中对齐，字体尺寸为正文的3倍；左侧制作栏底部对齐。

### 夹注

```tex
\jiazhu{<夹注内容>}
【<夹注内容>】
```

定义中文【】实心中括号作为夹注的快捷方式，避免中英文输入法的频繁切换。

### 句读

中文传统是没有标点符号的。通常视为标点符号的句读，有两种形式：

- 句：与现代标点符号的句号形式与功能相同，表示句子结束

- 读：音逗。外观与现代标点符号的顿号接近，表示句子中所有停顿

句读不是中文传统语法成分，只是读书人为方便断句而使用的一种标记，并作为读书人的基本功之一。著作、出版都不需要句读。中文传统印刷书籍中，极少见到句读。即使有，也是民间出版书籍，通常也只是在断句困难或者极易混淆的地方加以标注。

因此，本模板只支持手动插入句读，重新定义句号和顿号，作为句读的快捷方式。在需要的地方插入句号或者顿号即可。不支持自动句读，避免滥用句读。

## 待解决的问题

### 夹注跨面首行对齐

夹注跨面或者跨页时，首行若无正文，夹注位置会发生偏移。这个问题在现代直排中并无大碍。但在传统直排中是无法接受的。经与夹注宏包开发者讨论，暂时无法自动处理。

[GitHub: CTeX-org/ctex-kit/issues/631](https://github.com/CTeX-org/ctex-kit/issues/631)

作为替代方案，在夹注跨面断行处截断成两个夹注，之间插入零宽度影子字符。本模板使用`Full Block █ (U+2588)`作为影子字符，定义`\zhvt`命令共使用。

```tex
【長上聲弟】\zhvt【去聲倍與背同潔胡結反老老所……】
```

### 全高字体夹注

传统线装书除了字典，注释远多于正文的情形，采用半高夹注，即夹注字体尺寸为正文的一半。
更常见的是采用全高窄字体夹注，即夹注字体高度等于正文或者略小于正文，宽度为一半或一半略宽的字体。

市面上除了美术字体之外，中文窄字体非常少见，而支持繁体大字符集的印刷窄字体更是阙如。解决这个问题的最佳解决方案当然是制作一套能够完美配合的两种字体，作为非专业者，这是一个几乎不可能的方案。（也可个别爱好者使用`fontforge`等字体制作软件，通过收窄现有字体的方式，自行制作。）

本人设想了一个替代性方案，通过 `FakeStretch`实现字形宽度收缩，模拟全高窄体汉字，有了一些初步的效果，但存在个别夹注不能对齐的问题。

### 边框界栏绘制时机

目前，边框界栏绘制是页面背景方式实现的，绘制时机处于页面内容构建完成之后输出之前，难以实现根据页面内容动态调整界栏的绘制。

## 版权说明

本模板

1. 个人免费使用，但仅限于学习、研究、非经营性分发采用本模板生成的最终作品。

2. 除此上述用途之外，请于本人联系获得授权。

3. 本模板所引用宏包版权归开发者所有，如需授权请自行联系。

Mail: chianjin@foxmail.com
VX: w1280543

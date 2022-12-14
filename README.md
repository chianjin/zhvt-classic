# zhvt-classic 中文线装书模板

本 $\LaTeX$ 中文线装书模板，按照较为常见的传统线装书排版格式，实现框线、书口、目录、序言、夹注等排版元素，支持书名页、图像和句读。

## 依赖宏包

本模板依赖`jiazhu.sty`宏包。该宏包尚未收录进$\TeX Live$，需要手动下载安装。

下载地址：[https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu](https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu)

安装方法：[https://github.com/CTeX-org/ctex-kit/issues/630](https://github.com/CTeX-org/ctex-kit/issues/630)

## 默认字体

本模板默认使用思源宋体，请自行下载安装。

下载地址：[https://github.com/adobe-fonts/source-han-serif/tree/release#downloading-source-han-serif](https://github.com/adobe-fonts/source-han-serif/tree/release#downloading-source-han-serif)

## 基本使用

```tex
\documentclass{zhvt-classic}
\title{大學章句}

\begin{document}

% 书名页，默认由 \title 命令设置，亦可以选项形式另行设置
\maketitle{宋新安朱文公章句並注}{壬寅夏潤州宜軒製版}[大~學~章~句]

% 目录页
\setcounter{page}{1}
\tableofcontents

% 正文部分
\mainmatter 

\chapter*{大學章句序} % 带*号表示不编号

大學之書古之大學所以教人之法也...

\chapter*{大學章句}[大舊音泰今讀如字] % 标题夹注
\begin{fw} % 序言环境
子程子曰大學孔氏之遺書而初學入德之門也...
\end{fw}

大學之道在明明德在親民在止於至善
\jz{程子曰親當作新...} % 夹注

\end{document}
```

## 参数设置

本模板默认参照清内府版《明史》尺寸。

- 书：高九寸，宽六寸

- 文：高七寸，宽四寸五分

- 字：高三分，宽二分七厘，行四分五厘

- 每叶二十行，左右半叶各十行；每行二十一字

- 天头地脚：二比一

按照清光绪三十四年营造尺库平制，一营造尺折算 320 mm，计算相关参数。这些参数可在 导言区使用 `\zhvtset`设置，参数说明及默认值如下：

```tex
\zhvtset {
    % 字体
    main_font           = Source Han Serif SemiBold,
    % 字体尺寸，三分，9.6mm，直接用 9.6mm 会有奇怪的问题
    font_size           = 27.32pt,
    % 行距与字体尺寸的倍数
    baselineskip_ratio  = 1.5,
    % 夹注字体
    jiazhu_font         = Source Han Serif Medium,
    % 书名标题字体
    title_font          = Source Han Serif Bold,
    % 页面宽度，六寸
    paper_width         = 192mm,
    % 页面高度，九寸
    paper_height        = 288mm,
    % 每页行数
    page_lines          = 10,
    % 每行字数
    line_chars          = 21,
    % 天头地脚比例
    top_bottom_ratio    = 2,
    % 微调位移，使得左右页竖排中文对称
    micro_offset        = 2.76pt,
    % 内框线宽度
    grid_line_width     = 1pt,
    % 外框线宽度，默认为内框线的 3 倍
    frame_line_width    = 3pt,
    % 内外框线中心间距，默认为内框线宽度的 6 倍
    frame_sep           = 6pt,
    % 框线、界栏、鱼口颜色
    grid_color          = red,
    % 是否显示界栏
    grid_lines          = true,
    % 句读垂直位移，默认向上 -0.4 倍字符尺寸
    judou_voffset       = -0.4,
    % 句读水平位移，默认向右 0.3 倍字符尺寸
    judou_hoffset       = 0.3,
    % 序言环境缩进，字符尺寸的倍数
    foreword_margin     = 2,
    % 章标题缩进，字符尺寸的倍数
    chapter_indent      = 1,
    % 节标题缩进，字符尺寸的倍数
    section_indent      = 2,
}
```

## 图像

传统书籍基本上都是整页图像，基本上没有图文混排。本模板亦支持整页图像，不支持图文混排。

```tex
\insertgraphics[<options>]{<path to image file>}
```

选项与`\includegraphics`相同，该命令自动将图片置于页面正中，但不会自动调整大小和方向，请自行调整。

## 句读

中文传统是没有标点符号的。通常被当作标点符号的句读，有两种形式：

- 句：与现代标点符号的句号形式与功能相同，表示句子结束

- 读：音逗。外观与现代标点符号的顿号接近，表示句子中所有停顿

但句读并不是中文传统语法成分，只是读书人为方便断句而使用的一种标记，并作为读书人的基本功之一。写作、出版人都不需要句读。中文传统印刷书籍中，极少见到句读。即使有，也是民间出版书籍，通常也只是在断句困难或者极易混淆的地方加以标注。

因此，本模板只支持手动插入句读，在需要的地方插入`\ju`和`\dou`命令即可。不支持自动句读，避免滥用句读。

## 输出拼版

以上代码实际还是以横排、奇偶页方式实现的，所以输出的 PDF 也是以奇偶页方式分页的。与线装书的一叶（葉）概念不同。最终输出需要进行拼版。

```shell
# need pymupdf package, can be installed by pip
# pip install pymupdf
python tools/splice-page.py <path/some.pdf>
```

## 版权说明

本模板

1. 个人免费使用，但仅限于学习、研究、非经营性分发采用本模板生成的最终作品。

2. 除此上述用途之外，请于本人联系获得授权。

3. 本模板所引用宏包版权归开发者所有，如需授权请自行联系。

Mail: chianjin@foxmail.com
VX: w1280543

# zhvt-classic 中文线装书模板

本 $\LaTeX$ 中文线装书模板，按照较为常见的传统线装书排版格式，实现框线、书口、目录、序言、夹注等排版元素，支持书名页、图像和句读。

## 基本使用方法

```tex
\documentclass{zhvt-classic}
\title{大學章句}

\begin{document}

% 书名页
\maketitle{宋新安朱文公章句並注}{大~學~章~句}{壬寅夏潤州宜軒製版}

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

\begin{document}
```

## 参数设置

在 Preamble 部分使用 `\zhvtset{...}`，可设置排版的相关参数，参数说明如下：

```tex
\zhvtset {
    % 字体
    main_font           = Source Han Serif SC SemiBold,
    % 字体尺寸
    font_size           = 20pt,
    % 行距与字体尺寸的倍数
    baselineskip_ratio  = 1.5,
    % 夹注字体
    jiazhu_font         = Source Han Serif SC SemiBold,
    % 页面宽度，大32开
    paper_width         = 140mm,
    % 页面高度，大32开
    paper_height        = 203mm,
    % 每页行数
    page_lines          = 10,
    % 每行字数
    line_chars          = 20,
    % 天头地脚比例
    top_bottom_ratio    = 2,
    % 微调位移，使得左右页竖排中文对称
    micro_offset        = 2.25pt,
    % 内框线宽度
    grid_line_width     = 1pt,
    % 外框线宽度，默认为内框线的 3 倍
    frame_line_width    = 3pt,
    % 内外框线中心间距，默认为内框线宽度的 6 倍
    frame_sep           = 6pt,
    % 框线、界栏、鱼口颜色
    grid_color          = red,
    % 句读垂直位移，默认向上 -0.4 倍字符尺寸
    judou_voffset       = -8pt,
    % 句读水平位移，默认向右 0.3 倍字符尺寸
    judou_hoffset       = 6pt,
    % 序言环境缩进，字符尺寸的倍数
    foreword_margin     = 2,
    % 章标题缩进，字符尺寸的倍数
    chapter_indent      = 1,
    % 节标题缩进，字符尺寸的倍数
    section_indent      = 2,
}
```

## 输出拼版

以上代码实际还是以横排、奇偶页方式实现的，所以输出的 PDF 也是以奇偶页方式分页的。与线装书的一叶（葉）概念不同。最终输出需要进行拼版。

```shell
# need pymupdf package, can be installed by pip
# pip install pymupdf
python tools/splice-page.py <path/some.pdf>
```

## 版权说明

本模板

1. 个人免费使用，但仅限于学习、研究，非营利性分发采用本模板生成的最终作品。

2. 除此上述用途之外，请于本人联系获得授权。

3. 本模板所引用宏包版权归开发者所有，如需授权请自行联系。

VX: w1280543

% LaTeX 中文线装书模板
%
% 本模板：
% 1. 个人免费使用，但仅限于：学习、研究、非经营性分发采用本模板
%    生成的最终作品。
% 2. 除此上述用途之外，请与本人联系获取授权。
% 3. 本模板所引用宏包版权归开发者所有，如需授权请自行联系。
%
% 邮件： chianjin@foxmail.com
% 微信：w1280543
%
% 项目地址：https://github.com/chianjin/zhvt-classic

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{zhvt}
\ProcessOptions\relax
\LoadClass{book}
\RequirePackage{xparse}
\RequirePackage[LoadFandol=false]{xeCJK}
\RequirePackage{zhnumber}
\RequirePackage{atbegshi}   % 用于实现页面旋转、框线、界栏、鱼尾等版式部件
\RequirePackage{tikz}
\RequirePackage{l3draw}
\RequirePackage{jiazhu}     % 割注包 https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu

\ExplSyntaxOn
%\debug_on:n { check-declarations }
% 使得夹注行宽总是汉字宽度的偶数倍
% https://github.com/CTeX-org/ctex-kit/issues/631
% 感谢 Qing Lee https://github.com/qinglee
\cs_set_protected:Npn \__jiazhu_dim_normalize:N #1
  {
    \int_set:Nn \l_tmpa_int
        { \dim_ratio:nn { #1 } { \l__jiazhu_unit_dim } }
    \int_if_even:nF { \l_tmpa_int }
        { \int_incr:N \l_tmpa_int }
    \dim_set:Nn #1 { \l__jiazhu_unit_dim * \l_tmpa_int }
  }
\cs_set_protected:Npn \__jiazhu_extract_max_width:N #1
  {
    \dim_set:Nn \l__jiazhu_width_dim { \box_wd:N #1 }
    \dim_set_eq:NN \l__jiazhu_max_dim \l__jiazhu_width_dim
  }

% 常量
\dim_const:Nn \c_one_inch_dim { 1 in }

% 参数定义
\str_new:N  \l__zhvt_main_font_str                % 正文字体
\str_new:N  \l__zhvt_jiazhu_font_str              % 夹注字体
\str_new:N  \l__zhvt_title_font_str               % 标题字体
\dim_new:N  \l__zhvt_paper_width_dim              % 页面宽度（页面高度）
\dim_new:N  \l__zhvt_paper_height_dim             % 页面高度（页面宽度）
\dim_new:N  \l__zhvt_font_size_dim                % 字体尺寸
\fp_new:N   \l__zhvt_baseline_skip_ratio_fp       % 行距倍数
\int_new:N  \l__zhvt_page_lines_int               % 每页行数
\int_new:N  \l__zhvt_line_chars_int               % 每行字数
\fp_new:N   \l__zhvt_top_bottom_ratio_fp          % 天头、地脚高度比例
\dim_new:N  \l__zhvt_grid_line_width_dim          % 内框线宽
\dim_new:N  \l__zhvt_frame_line_width_dim         % 外框线宽
\dim_new:N  \l__zhvt_frame_sep_dim                % 内外框间距
\str_new:N  \l__zhvt_grid_color_str               % 栏框颜色
\bool_new:N \l__zhvt_grid_lines_bool              % 是否显示界栏
\dim_new:N  \l__zhvt_micro_offset_dim             % 字体旋转后，行的视觉中线有所变化，对此进行微调
\fp_new:N   \l__zhvt_judou_vertical_offset_fp     % 句读垂直位移比例
\fp_new:N   \l__zhvt_judou_horizontal_offset_fp   % 句读水平位移比例
\int_new:N  \l__zhvt_foreword_margin_int          % 序言环境缩进
\int_new:N  \l__zhvt_chapter_indent_int           % 章标题缩进
\int_new:N  \l__zhvt_section_indent_int           % 节标题缩进


% 需要计算的长度
\dim_new:N  \l__zhvt_baseline_skip_dim            % 行距，两行基线的距离
\dim_new:N  \l__zhvt_line_sep_dim                 % 行间距，上行底部与下行顶部的距离
\dim_new:N  \l__zhvt_text_width_dim               % 文本宽度（文本高度）
\dim_new:N  \l__zhvt_text_height_dim              % 文本高度（文本宽度）
\dim_new:N  \l__zhvt_top_margin_dim               % 天头高度（左侧页边距）

\keys_define:nn { zhvt }
  {
    main_font           .str_set:N = \l__zhvt_main_font_str,
    main_font           .initial:n = Source~Han~Serif~SemiBold,
    font_size           .dim_set:N = \l__zhvt_font_size_dim,
    font_size           .initial:n = 20pt,
    baselineskip_ratio   .fp_set:N = \l__zhvt_baseline_skip_ratio_fp,
    baselineskip_ratio  .initial:n = 1.5,
    jiazhu_font         .str_set:N = \l__zhvt_jiazhu_font_str,
    jiazhu_font         .initial:n = Source~Han~Serif~Medium,
    title_font          .str_set:N = \l__zhvt_title_font_str,
    title_font          .initial:n = Source~Han~Serif~Bold,
    paper_width         .dim_set:N = \l__zhvt_paper_width_dim,
    paper_width         .initial:n = 140mm,
    paper_height        .dim_set:N = \l__zhvt_paper_height_dim,
    paper_height        .initial:n = 203mm,
    page_lines          .int_set:N = \l__zhvt_page_lines_int,
    page_lines          .initial:n = 10,
    line_chars          .int_set:N = \l__zhvt_line_chars_int,
    line_chars          .initial:n = 20,
    top_bottom_ratio     .fp_set:N = \l__zhvt_top_bottom_ratio_fp,
    top_bottom_ratio    .initial:n = 2,
    micro_offset        .dim_set:N = \l__zhvt_micro_offset_dim,
    micro_offset        .initial:n = 2.25pt,
    grid_line_width     .dim_set:N = \l__zhvt_grid_line_width_dim,
    grid_line_width     .initial:n = 1pt,
    frame_line_width    .dim_set:N = \l__zhvt_frame_line_width_dim,
    frame_line_width    .initial:n = 3\l__zhvt_grid_line_width_dim,
    frame_sep           .dim_set:N = \l__zhvt_frame_sep_dim,
    frame_sep           .initial:n = 6\l__zhvt_grid_line_width_dim,
    grid_color          .str_set:N = \l__zhvt_grid_color_str,
    grid_color          .initial:n = red,
    grid_lines         .bool_set:N = \l__zhvt_grid_lines_bool,
    grid_lines          .initial:n = true,
    judou_voffset        .fp_set:N = \l__zhvt_judou_vertical_offset_fp,
    judou_voffset       .initial:n = -0.4,
    judou_hoffset        .fp_set:N = \l__zhvt_judou_horizontal_offset_fp,
    judou_hoffset       .initial:n = 0.3,
    foreword_margin     .int_set:N = \l__zhvt_foreword_margin_int,
    foreword_margin     .initial:n = 2,
    chapter_indent      .int_set:N = \l__zhvt_chapter_indent_int,
    chapter_indent      .initial:n = 1,
    section_indent      .int_set:N = \l__zhvt_section_indent_int,
    section_indent      .initial:n = 2,
  }
\NewDocumentCommand { \zhvtset } { }
  { \keys_set:nn { zhvt } }

% 计算后续所需的一些长度
\cs_new_protected:Nn \__zhvt_calculate_dimensions:
  {
    \dim_set:Nn \l__zhvt_baseline_skip_dim
      { \fp_to_dim:n { \l__zhvt_baseline_skip_ratio_fp * \l__zhvt_font_size_dim } }
    \dim_set:Nn \l__zhvt_line_sep_dim
      { \l__zhvt_baseline_skip_dim - \l__zhvt_font_size_dim }
    \dim_set:Nn \l__zhvt_text_width_dim
      { \fp_to_dim:n { \l__zhvt_page_lines_int * \l__zhvt_baseline_skip_dim } }
    \dim_set:Nn \l__zhvt_text_height_dim
      { \fp_to_dim:n { \l__zhvt_line_chars_int * \l__zhvt_font_size_dim } }
    \dim_set:Nn \l__zhvt_top_margin_dim
      {
        \fp_to_dim:n
          {
            \l__zhvt_top_bottom_ratio_fp
            / ( \l__zhvt_top_bottom_ratio_fp + 1 )
            * ( \l__zhvt_paper_height_dim - \l__zhvt_text_height_dim )
          }
      }
  }

\cs_new:Nn \__zhvt_set_layout:
  {
    \dim_set:Nn \paperwidth { \l__zhvt_paper_height_dim }
    \dim_set:Nn \paperheight { \l__zhvt_paper_width_dim }
    \dim_set:Nn \textwidth { \l__zhvt_text_height_dim }
    \dim_set:Nn \textheight { \l__zhvt_text_width_dim }
    \dim_zero:N \headheight
    \dim_zero:N \headsep
    \dim_zero:N \footskip
    \dim_zero:N \marginparwidth
    \dim_zero:N \marginparsep
    \dim_set:Nn \hoffset { \c_zero_dim }
    \dim_set:Nn \topmargin { - \c_one_inch_dim - \l__zhvt_micro_offset_dim }
    \dim_set:Nn \oddsidemargin { (\paperwidth - \textwidth) * 2 / 3 - \c_one_inch_dim }
    \dim_set:Nn \evensidemargin { \oddsidemargin }
  }

% 句读
\NewDocumentCommand { \judou } { m }
  {%s
    \begin{picture} ( \c_zero_dim, \c_zero_dim )
        \put ( \fp_use:N \l__zhvt_judou_vertical_offset_fp em,
            \fp_use:N \l__zhvt_judou_horizontal_offset_fp em ) {#1}
    \end{picture}\CJKglue%
  }
\NewDocumentCommand { \ju } { } { \judou {。} }
\NewDocumentCommand { \dou } { } { \judou{、} }

% 注释标记
\NewDocumentCommand { \notemark } { O { black } m }
  {
    \draw_begin:
        \draw_baseline:n { \c_zero_dim }
        \color_fill:n { #1 }
        \draw_path_corner_arc:nn { 0.1 em } { 0.1 em }
        \draw_path_rectangle:nn { 0, -0.5 em } { \str_count:n {#2} em, 1 em }
        \draw_path_use_clear:n { fill }
        \color_fill:n { white }
        \hbox_set:Nn \l_tmpa_box {#2}
        \draw_box_use:N \l_tmpa_box
    \draw_end:
  }

% 注释分割
\NewDocumentCommand { \quan } { } { \symbol{ "25CB } }

% 序言环境
\NewDocumentEnvironment{ foreword } { O { \l__zhvt_foreword_margin_int } }
  {%
    \begin{list} { }
      {
        \topsep\z@
        \parskip\z@
        \parsep\z@
        \partopsep\z@
        \setlength{\leftmargin}{#1 em}
      }
    \item[]
  }
  { \end{list} }
% 序言环境别名，少打几个字符
\NewDocumentEnvironment { fw } { } { \begin { foreword } } { \end { foreword } }

% 夹注 Hack
% 跨页夹注，纠正位置偏移
\NewDocumentCommand { \newpagejiazhu } { } { \vphantom { 国 } \jiazhu }
% 夹注相关快捷命令，少打几个字母
\NewDocumentCommand { \jz } { } { \jiazhu }
\NewDocumentCommand { \njz } { } { \newpagejiazhu }

%% 使用两种 mark 类型，分别保存章和节的标题
%% from Qing Lee https://github.com/qinglee
\mark_new_class:n { zhvt_chapter }
\mark_new_class:n { zhvt_section }
% 重定义目录
\RenewDocumentCommand { \tableofcontents } { }
  {%
    \tocmatter
    \mark_insert:nn { zhvt_chapter } { 目錄 }
    目錄
    \@starttoc { toc }
    \cleardoublepage
  }
% 重定义章、节，以符合线装书样式
\RenewDocumentCommand { \chapter } { s m o }
  {%
    \cleardoublepage
    \refstepcounter { chapter }
    \IfBooleanTF { #1 }
      { \tl_set:Nn \l_tmpa_tl { #2 } }
      { \tl_set:Nn \l_tmpa_tl { #2 第 \zhnum{chapter} } }%
    \tl_set:Nn \l_tmpb_tl
      {%
        \par \hspace { \int_use:N \l__zhvt_chapter_indent_int em }
        \l_tmpa_tl
      }
    \addtocontents { toc } { \l_tmpb_tl }
    \mark_insert:nn { zhvt_chapter } {\l_tmpa_tl}
    \l_tmpb_tl%
    \IfNoValueF { #3 } { \jiazhu { #3 } }
    \par
  }
\RenewDocumentCommand { \section } { m o }
  {%
    \refstepcounter { section }%
    \tl_set:Nn \l_tmpb_tl
      { \par \hspace { \int_use:N \l__zhvt_section_indent_int em } #1 }%
    \addtocontents { toc } { \l_tmpb_tl }%
    \mark_insert:nn { zhvt_section } {#1}
    \l_tmpb_tl%
    \IfNoValueF { #2 } { \jiazhu { #2 } }
    \par
  }

% 传统线装书，正反算一叶：1,2 -> 一，3,4 -> 二
\int_new:N \l__zhvt_page_int
\cs_new_protected:Nn \__zhvt_page:
  {%
    \int_set:Nn \l__zhvt_page_int { \c@page / 2 }%
    \zhnumber { \int_use:N \l__zhvt_page_int }%
  }

% 文档结构
\bool_new:N \l__zhvt_title_matter_bool
\bool_new:N \l__zhvt_foreword_matter_bool
\bool_new:N \l__zhvt_toc_matter_bool
\bool_new:N \l__zhvt_main_matter_bool
\NewDocumentCommand { \titlematter } { }
  {
    \cleardoublepage
    \bool_set_true:N  \l__zhvt_title_matter_bool
    \bool_set_false:N \l__zhvt_foreword_matter_bool
    \bool_set_false:N \l__zhvt_toc_matter_bool
    \bool_set_false:N \l__zhvt_main_matter_bool
  }
\NewDocumentCommand { \forewordmatter } { }
  {
    \cleardoublepage
    \bool_set_false:N \l__zhvt_title_matter_bool
    \bool_set_true:N  \l__zhvt_foreword_matter_bool
    \bool_set_false:N \l__zhvt_toc_matter_bool
    \bool_set_false:N \l__zhvt_main_matter_bool
  }
\NewDocumentCommand { \tocmatter } { }
  {
    \cleardoublepage
    \bool_set_false:N \l__zhvt_title_matter_bool
    \bool_set_false:N \l__zhvt_foreword_matter_bool
    \bool_set_true:N  \l__zhvt_toc_matter_bool
    \bool_set_false:N \l__zhvt_main_matter_bool
  }
\RenewDocumentCommand { \mainmatter } { }
  {
    \cleardoublepage
    \bool_set_false:N \l__zhvt_title_matter_bool
    \bool_set_false:N \l__zhvt_foreword_matter_bool
    \bool_set_false:N \l__zhvt_toc_matter_bool
    \bool_set_true:N  \l__zhvt_main_matter_bool
  }

% 奇偶页右侧间距，即原始页面顶部间距。
% 奇数页左侧、偶数页右侧各留一半行距的间距
% 双页合并后，正好居中一行宽度的书口。
\cs_new_eq:NN \latex@outputpage \@outputpage
% TODO: 待转换为 expl3 语法
\def \@outputpage { \expandafter \__zhvt_set_output_voffset: \latex@outputpage }
\cs_new_protected:Nn \__zhvt_set_output_voffset:
  {%
    \int_if_odd:nTF \c@page
      {
        \dim_set:Nn \voffset
          {
            \l__zhvt_paper_width_dim - \l__zhvt_text_width_dim
            - \l__zhvt_baseline_skip_dim / 2
          }
      }
      {
        \dim_set:Nn \voffset { \l__zhvt_baseline_skip_dim / 2}
      }
  }
%\cs_new_protected:Nn \zhvt_outputpage:
%    {\expandafter \__zhvt_set_output_voffset: \latex@outputpage}
%\cs_set_eq:NN \@outputpage \zhvt_outputpage

% 书名叶
\RenewDocumentCommand { \maketitle } { O { 3 } m m O { \@title } }
  {%
    \titlematter
    \begin{picture} ( \textwidth , \textheight )
        \put ( \c_zero_int, \textheight - \baselineskip - \l__zhvt_micro_offset_dim )
          {
            \skip_horizontal:n { \l__zhvt_font_size_dim } #2
          }
        \put ( \c_zero_int, 0.5 \textheight )
          {
            \parbox[t]{ \textwidth }
              {
                \titlefont \fontsize{ #1 \l__zhvt_font_size_dim } { \c_zero_dim }
                \selectfont \hfil { #4 }
              }
          }
        \put ( \c_zero_int, \baselineskip - \l__zhvt_micro_offset_dim )
          {
            \hbox_to_wd:nn { \textwidth - \l__zhvt_font_size_dim } { \hfill #3 }
          }
    \end{picture}
    \cleardoublepage
  }

% 图像叶
\NewDocumentCommand { \insertgraphics } { o m }
  {
    \clearpage
    \bool_set_eq:NN \l_tmpa_bool \l__zhvt_grid_lines_bool
    \bool_set_false:N \l__zhvt_grid_lines_bool
    \null \vfil \hfil \includegraphics [ #1 ] { #2 }
    \clearpage
    \bool_set_eq:NN \l__zhvt_grid_lines_bool \l_tmpa_bool
  }

% 绘制页框、界栏、鱼尾，设置版心等
\NewDocumentCommand { \zhvt@setlayout } { }
  {
    \__zhvt_set_page_center:
    \__zhvt_draw_grid:
    \__zhvt_draw_yuwei:
    \__zhvt_draw_frame:
    \__zhvt_draw_grid_lines:
  }

% 设置版心
\cs_new_protected:Nn \__zhvt_set_page_center:
  {
    % 书名
    \int_if_odd:nTF \c@page
      {
        \put ( \l__zhvt_top_margin_dim,
            - \l__zhvt_text_width_dim - 0.5 \l__zhvt_baseline_skip_dim ) { \@title }
      }
      {
        \put ( \l__zhvt_top_margin_dim, 0.5 \l__zhvt_baseline_skip_dim ) { \@title }
      }

    % 篇名，页码，仅奇数页
    \int_if_odd:nT \c@page
      {
        \put ( \l__zhvt_top_margin_dim + 0.4 \l__zhvt_text_height_dim,
              -\l__zhvt_text_width_dim - 0.25 \l__zhvt_baseline_skip_dim )
          {% 篇名
            \jiazhusize%
            \bool_if:nTF \l__zhvt_foreword_matter_bool
              { 序 }%
              { \mark_use_first:nn { page } { zhvt_chapter } }
          }
        % 页码
        \bool_if:nF \l__zhvt_title_matter_bool
          {
            \put( \l__zhvt_top_margin_dim + 0.85 \l__zhvt_text_height_dim,
                - \l__zhvt_text_width_dim - 0.25 \l__zhvt_baseline_skip_dim )
              { \jiazhusize \__zhvt_page: }
          }
      }
  }

% 设置内框坐标，upperleft 左上角，lowerright 右下角。
\dim_new:N \l__zhvt_grid_upper_dim
\dim_new:N \l__zhvt_grid_lower_dim
\dim_new:N \l__zhvt_grid_left_dim
\dim_new:N \l__zhvt_grid_right_dim
\cs_new_protected:Nn \__zhvt_calculate_grid_position:
{
    \dim_set:Nn \l__zhvt_grid_upper_dim
      { \l__zhvt_top_margin_dim - 0.5 \l__zhvt_line_sep_dim }
    \dim_set:Nn \l__zhvt_grid_lower_dim
      { \l__zhvt_top_margin_dim + \l__zhvt_text_height_dim + 0.5 \l__zhvt_line_sep_dim }
    \dim_set:Nn \l__zhvt_grid_left_dim
      { - \l__zhvt_text_width_dim }
    \dim_set:Nn \l__zhvt_grid_right_dim
      { \c_zero_dim }
}

% 内框
\cs_new_protected:Nn \__zhvt_draw_grid:
  {
    \put ( \c_zero_int, \c_zero_int )
      {%
        \int_if_odd:nTF \c@page
          {
            \begin{tikzpicture}
              [
                overlay,
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_grid_line_width_dim
              ]
                \draw ( \l__zhvt_grid_upper_dim,
                        \l__zhvt_grid_left_dim - 0.5 \l__zhvt_baseline_skip_dim )
                    --( \l__zhvt_grid_upper_dim, \l__zhvt_grid_right_dim )
                    --( \l__zhvt_grid_lower_dim, \l__zhvt_grid_right_dim )
                    --( \l__zhvt_grid_lower_dim,
                        \l__zhvt_grid_left_dim - 0.5\l__zhvt_baseline_skip_dim );
                \draw ( \l__zhvt_grid_upper_dim, \l__zhvt_grid_left_dim )
                    --( \l__zhvt_grid_lower_dim, \l__zhvt_grid_left_dim );
            \end{tikzpicture}
          }
          {
            \begin{tikzpicture}
              [
                overlay,
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_grid_line_width_dim
              ]
                \draw ( \l__zhvt_grid_upper_dim,
                        \l__zhvt_grid_right_dim + 0.5\l__zhvt_baseline_skip_dim )
                    --( \l__zhvt_grid_upper_dim, \l__zhvt_grid_left_dim )
                    --( \l__zhvt_grid_lower_dim, \l__zhvt_grid_left_dim )
                    --( \l__zhvt_grid_lower_dim,
                        \l__zhvt_grid_right_dim + 0.5 \l__zhvt_baseline_skip_dim );
                \draw ( \l__zhvt_grid_upper_dim, \l__zhvt_grid_right_dim )
                    --( \l__zhvt_grid_lower_dim, \l__zhvt_grid_right_dim );
            \end{tikzpicture}
          }
      }
  }

% 鱼尾
\cs_new_protected:Nn \__zhvt_draw_yuwei:
  {
    \int_if_odd:nTF \c@page
      {
        \put
          (
            \l__zhvt_top_margin_dim + 0.3 \l__zhvt_text_height_dim,
            - \l__zhvt_text_width_dim - 0.5 \l__zhvt_baseline_skip_dim
              - 0.5 \l__zhvt_grid_line_width_dim
          )
          {%
            \begin{tikzpicture}
              [
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_grid_line_width_dim
              ]
                \draw [ fill = \l__zhvt_grid_color_str, line~width = \c_zero_dim ]
                    ( \c_zero_dim, \c_zero_dim )
                    -- ( 0.5 \l__zhvt_font_size_dim, \c_zero_dim )
                    -- ( \l__zhvt_font_size_dim, 0.5\l__zhvt_baseline_skip_dim )
                    -- ( \c_zero_dim, 0.5 \l__zhvt_baseline_skip_dim ) -- cycle;
                \draw ( 0.7 \l__zhvt_text_width_dim, \c_zero_dim )
                    --(0.7 \l__zhvt_text_width_dim, 0.5 \l__zhvt_baseline_skip_dim );
                \draw ( \c_zero_dim, \c_zero_dim )
                    -- ( 0.7 \l__zhvt_text_width_dim, \c_zero_dim );
            \end{tikzpicture}
          }
      }
      {
        \put
          (
            \l__zhvt_top_margin_dim + 0.3 \l__zhvt_text_height_dim,
            - 0.5 \l__zhvt_grid_line_width_dim
          )
          {%
            \begin{tikzpicture}
              [
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_grid_line_width_dim
              ]
                \draw [ fill = \l__zhvt_grid_color_str, line~width = \c_zero_dim ]
                    ( \c_zero_dim, \c_zero_dim )
                    -- ( \l__zhvt_font_size_dim, \c_zero_dim )
                    -- ( 0.5 \l__zhvt_font_size_dim, 0.5 \l__zhvt_baseline_skip_dim )
                    -- ( \c_zero_dim, 0.5 \l__zhvt_baseline_skip_dim ) -- cycle;
                \draw ( 0.7 \l__zhvt_text_width_dim, \c_zero_dim )
                    --( 0.7 \l__zhvt_text_width_dim, 0.5\l__zhvt_baseline_skip_dim );
                \draw ( \c_zero_dim, 0.5\l__zhvt_baseline_skip_dim )
                    --( 0.7 \l__zhvt_text_width_dim, 0.5 \l__zhvt_baseline_skip_dim );
            \end{tikzpicture}
          }
      }
  }

% 外框
\cs_new_protected:Nn \__zhvt_draw_frame:
  {
    \put ( \c_zero_dim, \c_zero_dim )
      {%
        \int_if_odd:nTF \c@page
          {
            \begin{tikzpicture}
              [
                overlay,
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_frame_line_width_dim
              ]
                \draw
                    ( \l__zhvt_grid_upper_dim - \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_left_dim - 0.5\l__zhvt_baseline_skip_dim )
                    --( \l__zhvt_grid_upper_dim - \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_right_dim + \l__zhvt_frame_sep_dim )
                    --( \l__zhvt_grid_lower_dim + \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_right_dim + \l__zhvt_frame_sep_dim)
                    --( \l__zhvt_grid_lower_dim + \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_left_dim - 0.5\l__zhvt_baseline_skip_dim );
            \end{tikzpicture}
          }
          {
            \begin{tikzpicture}
              [
                overlay,
                color = \l__zhvt_grid_color_str,
                line~width = \l__zhvt_frame_line_width_dim
              ]
              {
                \draw
                    ( \l__zhvt_grid_upper_dim - \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_right_dim + 0.5\l__zhvt_baseline_skip_dim )
                    --( \l__zhvt_grid_upper_dim - \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_left_dim - \l__zhvt_frame_sep_dim )
                    --( \l__zhvt_grid_lower_dim + \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_left_dim - \l__zhvt_frame_sep_dim )
                    --( \l__zhvt_grid_lower_dim + \l__zhvt_frame_sep_dim,
                        \l__zhvt_grid_right_dim + 0.5\l__zhvt_baseline_skip_dim);
              }
            \end{tikzpicture}
          }
      }
  }

% 界栏
\NewDocumentCommand { \gridlines } { }
  { \bool_set_true:N \l__zhvt_grid_lines_bool }
\NewDocumentCommand { \nogridlines } { }
  { \bool_set_false:N \l__zhvt_grid_lines_bool }

\tl_new:N \l__zhvt_grid_line_index_tl
\cs_new_protected:Nn \__zhvt_draw_grid_lines:
  {
    \bool_if:nT \l__zhvt_grid_lines_bool
      {
        \put ( \c_zero_dim, \c_zero_dim )
          {
            \bool_if:nTF \l__zhvt_title_matter_bool
              {
                \begin{tikzpicture}
                  [
                    overlay,
                    color=\l__zhvt_grid_color_str,
                    line~width=\l__zhvt_grid_line_width_dim
                  ]
                    \foreach \i in { 2, \int_eval:n { \l__zhvt_page_lines_int - 2 } }
                      {
                        \draw
                            ( \l__zhvt_grid_upper_dim,
                                \l__zhvt_grid_left_dim + \i \l__zhvt_baseline_skip_dim )
                            -- ( \l__zhvt_grid_lower_dim,
                                \l__zhvt_grid_left_dim + \i \l__zhvt_baseline_skip_dim );
                      }
                \end{tikzpicture}
              }
              {
                \begin{tikzpicture}
                  [
                    overlay,
                    color=\l__zhvt_grid_color_str,
                    line~width=\l__zhvt_grid_line_width_dim
                  ]
                    \foreach \i in { 1, 2 , ..., \int_eval:n {\l__zhvt_page_lines_int - 1 } }
                      {
                        \draw
                            ( \l__zhvt_grid_upper_dim,
                                \l__zhvt_grid_left_dim + \i \l__zhvt_baseline_skip_dim )
                            -- ( \l__zhvt_grid_lower_dim,
                                \l__zhvt_grid_left_dim + \i \l__zhvt_baseline_skip_dim );
                      }
                \end{tikzpicture}
              }
          }
      }
  }

%% 调整钩子顺序，避免警告
\hook_gset_rule:nnnn { begindocument/before }
  { zhvt } { < } { xeCJK  }
\hook_gput_code:nnn { begindocument/before } { zhvt }
  {
    % 计算相关长度
    \__zhvt_calculate_dimensions:
    \__zhvt_calculate_grid_position:
    % 页面尺寸设置
    \__zhvt_set_layout:
    % 设置字体
    \defaultCJKfontfeatures { Script = CJK , RawFeature = vertical }
    \setCJKmainfont { \l__zhvt_main_font_str }
    % 添加白色圆圈
    \xeCJKDeclareCharClass{CJK} {"25CB}
    \RenewDocumentCommand { \normalsize } { }
      {
        \fontsize
          { \l__zhvt_font_size_dim }
          { \l__zhvt_baseline_skip_dim }
        \selectfont
      }
    % 书名叶标题字体
    \newCJKfontfamily \titlefont { \l__zhvt_title_font_str }
    % 夹注相关设置
    \newCJKfontfamily \jiazhufont { \l__zhvt_jiazhu_font_str }
    \NewDocumentCommand \jiazhusize { }
      {
        \fontsize
          { \dim_eval:n { \l__zhvt_font_size_dim / 2 } }
          { \dim_eval:n { \l__zhvt_font_size_dim / 2 } }
        \selectfont
      }
    \jiazhuset
      {
        format     = \jiazhufont ,
        ratio      = 1/2 ,
        beforeskip = \c_zero_skip ,
        afterskip  = \c_zero_skip ,
      }
    % 取消段落缩进和段间距
    \dim_zero:N \parindent
    \dim_zero:N \parskip
    % 空白页面样式
    \pagestyle { empty }
  }

\hook_gput_code:nnn { enddocument } { zhvt }
  { \cleardoublepage }

\ExplSyntaxOff

% 输出页面
\AtBeginShipout
  {%
    % 旋转页面
    \global\setbox\AtBeginShipoutBox\vbox
      {%
        \special{pdf: put @thispage <</Rotate 90>>}%
        \box\AtBeginShipoutBox
      }%
    % 输出版心、框线
    \AtBeginShipoutUpperLeft
      {%
        \zhvt@setlayout
      }
  }

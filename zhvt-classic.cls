% 中文线装书模板
% 本模板：
% 1. 个人免费使用，但仅限于学习、研究，非营利性分发采用本模板
%    生成的最终作品。
% 2. 除此上述用途之外，请于本人联系获得授权。
% 3. 本模板所引用宏包版权归开发者所有，如需授权请自行联系。
%
% 电子邮件： chianjin@foxmail.com
% 微信：w1280543

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{zhvt}
\ProcessOptions\relax
\LoadClass[oneside]{book}   % 启用 oneside 选项，避免实际左右间距的自动调整
\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{xeCJK}
\RequirePackage{zhnumber}
\RequirePackage{geometry}
\RequirePackage{atbegshi}   % 用于实现页面旋转、框线、界栏、鱼尾等版式部件
\RequirePackage{tikz}
\RequirePackage{keyval}
\RequirePackage{jiazhu}     % 割注包 https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu

\ExplSyntaxOn
% 使得夹注行宽总是汉字宽度的偶数倍
% https://github.com/CTeX-org/ctex-kit/issues/631
% 感谢 Qing Lee https://github.com/qinglee
\cs_set_protected:Npn \__jiazhu_dim_normalize:N #1
{
    \int_set:Nn \l_tmpa_int
    { \dim_ratio:nn {#1} { \l__jiazhu_unit_dim } }
    \int_if_even:nF { \l_tmpa_int }
    { \int_incr:N \l_tmpa_int }
    \dim_set:Nn #1 { \l__jiazhu_unit_dim * \l_tmpa_int }
}
\cs_set_protected:Npn \__jiazhu_extract_max_width:N #1
{
    \dim_set:Nn \l__jiazhu_width_dim { \box_wd:N #1 }
    \dim_set_eq:NN \l__jiazhu_max_dim \l__jiazhu_width_dim
}

% 参数定义
\str_new:N \l_zhvt_main_font_str                % 正文字体
\str_new:N \l_zhvt_jiazhu_font_str              % 夹注字体
\dim_new:N \l_zhvt_paper_width_dim              % 页面宽度（页面高度）
\dim_new:N \l_zhvt_paper_height_dim             % 页面高度（页面宽度）
\dim_new:N \l_zhvt_font_size_dim                % 字体尺寸
\fp_new:N  \l_zhvt_baseline_skip_ratio_fp       % 行距倍数
\int_new:N \l_zhvt_page_lines_int               % 每页行数
\int_new:N \l_zhvt_line_chars_int               % 每行字数
\fp_new:N  \l_zhvt_top_bottom_ratio_fp          % 天头、地脚高度比例
\dim_new:N \l_zhvt_grid_line_width_dim          % 内框线宽
\dim_new:N \l_zhvt_frame_line_width_dim         % 外框线宽
\dim_new:N \l_zhvt_frame_sep_dim                % 内外框间距
\str_new:N \l_zhvt_grid_color_str               % 栏框颜色
\dim_new:N \l_zhvt_micro_offset_dim             % 字体旋转之后行的视觉中线有所变化，对此进行微调
\dim_new:N \l_zhvt_judou_vertical_offset_dim    % 句读垂直位移
\dim_new:N \l_zhvt_judou_horizontal_offset_dim  % 句读水平位移
\int_new:N \l_zhvt_foreword_margin_int          % 序言环境缩进
\int_new:N \l_zhvt_chapter_indent_int           % 章标题缩进
\int_new:N \l_zhvt_section_indent_int           % 节标题缩进

\dim_new:N \l_zhvt_baseline_skip_dim            % 行距，两行中心的距离
\dim_new:N \l_zhvt_line_sep_dim                 % 行间距，上行底部到下行顶部的距离
\dim_new:N \l_zhvt_text_width_dim               % 文本宽度（文本高度）
\dim_new:N \l_zhvt_text_height_dim              % 文本高度（文本宽度）
\dim_new:N \l_zhvt_top_margin_dim               % 天头高度（左侧页边距）

\keys_define:nn {zhvt} {
    main_font           .str_set:N = \l_zhvt_main_font_str,
    main_font           .initial:n = Source~Han~Serif~SC~SemiBold,
    font_size           .dim_set:N = \l_zhvt_font_size_dim,
    font_size           .initial:n = 20pt,
    baselineskip_ratio   .fp_set:N = \l_zhvt_baseline_skip_ratio_fp,
    baselineskip_ratio  .initial:n = 1.5,
    jiazhu_font         .str_set:N = \l_zhvt_jiazhu_font_str,
    jiazhu_font         .initial:n = Source~Han~Serif~SC~SemiBold,
    paper_width         .dim_set:N = \l_zhvt_paper_width_dim,
    paper_width         .initial:n = 140mm,
    paper_height        .dim_set:N = \l_zhvt_paper_height_dim,
    paper_height        .initial:n = 203mm,
    page_lines          .int_set:N = \l_zhvt_page_lines_int,
    page_lines          .initial:n = 10,
    line_chars          .int_set:N = \l_zhvt_line_chars_int,
    line_chars          .initial:n = 20,
    top_bottom_ratio     .fp_set:N = \l_zhvt_top_bottom_ratio_fp,
    top_bottom_ratio    .initial:n = 2,
    micro_offset        .dim_set:N = \l_zhvt_micro_offset_dim,
    micro_offset        .initial:n = 2.25pt,
    grid_line_width     .dim_set:N = \l_zhvt_grid_line_width_dim,
    grid_line_width     .initial:n = 1pt,
    frame_line_width    .dim_set:N = \l_zhvt_frame_line_width_dim,
    frame_line_width    .initial:n = 3\l_zhvt_grid_line_width_dim,
    frame_sep           .dim_set:N = \l_zhvt_frame_sep_dim,
    frame_sep           .initial:n = 6\l_zhvt_grid_line_width_dim,
    grid_color          .str_set:N = \l_zhvt_grid_color_str,
    grid_color          .initial:n = red,
    judou_voffset       .dim_set:N = \l_zhvt_judou_vertical_offset_dim,
    judou_voffset       .initial:n = -0.4\l_zhvt_font_size_dim,
    judou_hoffset       .dim_set:N = \l_zhvt_judou_horizontal_offset_dim,
    judou_hoffset       .initial:n = 0.3\l_zhvt_font_size_dim,
    foreword_margin     .int_set:N = \l_zhvt_foreword_margin_int,
    foreword_margin     .initial:n = 2,
    chapter_indent      .int_set:N = \l_zhvt_chapter_indent_int,
    chapter_indent      .initial:n = 1,
    section_indent      .int_set:N = \l_zhvt_section_indent_int,
    section_indent      .initial:n = 2,
}
\NewDocumentCommand {\zhvtset} { }
  { \keys_set:nn { zhvt } }

% 计算所需的一些长度
\cs_new:Nn \__zhvt_calculate_dimensions: {
    \dim_set:Nn \l_zhvt_baseline_skip_dim {
        \fp_to_dim:n {\l_zhvt_baseline_skip_ratio_fp * \l_zhvt_font_size_dim}
    }
    \dim_set:Nn \l_zhvt_line_sep_dim {
        \l_zhvt_baseline_skip_dim - \l_zhvt_font_size_dim
    }
    \dim_set:Nn \l_zhvt_text_width_dim {
        \fp_to_dim:n {\l_zhvt_page_lines_int * \l_zhvt_baseline_skip_dim}
    }
    \dim_set:Nn \l_zhvt_text_height_dim {
        \fp_to_dim:n {\l_zhvt_line_chars_int * \l_zhvt_font_size_dim}
    }
    \dim_set:Nn \l_zhvt_top_margin_dim {
        \fp_to_dim:n {
            \l_zhvt_top_bottom_ratio_fp
              / (\l_zhvt_top_bottom_ratio_fp + 1)
              * (\l_zhvt_paper_height_dim - \l_zhvt_text_height_dim)
        }
    }
}

% 实现 oneside 选项下的 \cleardoublepage
\RenewDocumentCommand{\cleardoublepage}{}{%
    \clearpage
    \int_if_odd:nF \c@page {\hbox{}\newpage}
}

% 句读
\NewDocumentCommand { \judou } { m }{%
    \begin{picture}(0,0)
        \put(\l_zhvt_judou_vertical_offset_dim,\l_zhvt_judou_horizontal_offset_dim){#1}
    \end{picture}\penalty 0%
}
\NewDocumentCommand{\ju}{}{\judou{。}}
\NewDocumentCommand{\dou}{}{\judou{、}}

% 序言环境
\int_new:N \l_zhvt_foreword_margin_temp_int
\NewDocumentEnvironment{foreword}{o}{%
    \IfNoValueTF{#1}
        {\int_set:Nn \l_zhvt_foreword_margin_temp_int {\l_zhvt_foreword_margin_int}}
        {\int_set:Nn \l_zhvt_foreword_margin_temp_int {#1}}%
    \begin{list}{}{
        \topsep\z@
        \parskip\z@
        \parsep\z@
        \partopsep\z@
        \setlength{\leftmargin}{\int_use:N \l_zhvt_foreword_margin_temp_int em}
    }\item[]
}{\end{list}}
% 序言环境别名，少打几个字符
\NewDocumentEnvironment{fw}{}{\begin{foreword}}{\end{foreword}}

% 夹注 Hack
% 跨页夹注，纠正位置偏移
\NewDocumentCommand{\newpagejiazhu}{}{\vphantom{国}\jiazhu}
% 夹注相关快捷命令，少打几个字母
\NewDocumentCommand{\jz}{}{\jiazhu}
\NewDocumentCommand{\njz}{}{\newpagejiazhu}

% 重定义目录
\RenewDocumentCommand{\tableofcontents}{}{
    \tocmatter\hspace{2\l_zhvt_font_size_dim} 目錄\@starttoc{toc}\cleardoublepage
}
% 重定义章、节，以符合线装书样式
\str_new:N \l_zhvt_current_chapter_title_str
\tl_new:N  \l_zhvt_chapter_title_temp_tl
\tl_new:N \l_zhvt_content_line_tl
\RenewDocumentCommand{\chapter}{smo}{%
    \cleardoublepage%
    \refstepcounter{chapter}%
    \str_set:Nn \l_zhvt_current_chapter_title_str {#2}%
    \IfBooleanTF{#1}
        {\tl_set:Nn \l_zhvt_chapter_title_temp_str {#2}}
        {\tl_set:Nn \l_zhvt_chapter_title_temp_str {#2第\zhnum{chapter}}}%
    \tl_set:Nn \l_zhvt_content_line_str {%
        \par\hspace{\int_use:N \l_zhvt_chapter_indent_int em}
        \l_zhvt_chapter_title_temp_str
    }%
    \addtocontents{toc}{\l_zhvt_content_line_str}%
    \l_zhvt_content_line_str%
    \IfNoValueF{#3}{\jiazhu{#3}}
    \par
}
\RenewDocumentCommand{\section}{mo}{%
    \refstepcounter{section}%
    \tl_set:Nn \l_zhvt_content_line_str {%
        \par\hspace{\int_use:N \l_zhvt_section_indent_int em} #1%
    }%
    \addtocontents{toc}{\l_zhvt_content_line_str}%
    \l_zhvt_content_line_str%
    \IfNoValueF{#2}{\jiazhu{#2}}
    \par
}

% 传统线装书，正反算一叶：1,2 -> 一，3,4 -> 二
\int_new:N \l_zhvt_page_int
\cs_new:Nn \__zhvt_page: {%
    \int_set:Nn \l_zhvt_page_int {\c@page/2}%
    \zhnumber{\int_use:N \l_zhvt_page_int}%
}

% 文档结构
\bool_new:N \l_zhvt_title_matter_bool
\bool_new:N \l_zhvt_foreword_matter_bool
\bool_new:N \l_zhvt_toc_matter_bool
\bool_new:N \l_zhvt_main_matter_bool
\NewDocumentCommand{\titlematter}{}{
    \cleardoublepage
    \bool_set_true:N  \l_zhvt_title_matter_bool
    \bool_set_false:N \l_zhvt_foreword_matter_bool
    \bool_set_false:N \l_zhvt_toc_matter_bool
    \bool_set_false:N \l_zhvt_main_matter_bool
}
\NewDocumentCommand{\forewordmatter}{}{
    \cleardoublepage
    \bool_set_false:N \l_zhvt_title_matter_bool
    \bool_set_true:N  \l_zhvt_foreword_matter_bool
    \bool_set_false:N \l_zhvt_toc_matter_bool
    \bool_set_false:N \l_zhvt_main_matter_bool
}
\NewDocumentCommand{\tocmatter}{}{
    \cleardoublepage
    \bool_set_false:N \l_zhvt_title_matter_bool
    \bool_set_false:N \l_zhvt_foreword_matter_bool
    \bool_set_true:N  \l_zhvt_toc_matter_bool
    \bool_set_false:N \l_zhvt_main_matter_bool
}
\RenewDocumentCommand{\mainmatter}{}{
    \cleardoublepage
    \bool_set_false:N \l_zhvt_title_matter_bool
    \bool_set_false:N \l_zhvt_foreword_matter_bool
    \bool_set_false:N \l_zhvt_toc_matter_bool
    \bool_set_true:N  \l_zhvt_main_matter_bool
}

% 奇偶页右侧间距，即原始页面顶部间距。
% 奇数页左侧、偶数页右侧各留一半行距的间距
% 双页合并后，正好居中一行宽度的书口。
% TODO: 待转换为 expl3 语法
\let\zhvt@outputpage\@outputpage
\def\@outputpage{\expandafter\zhvt@setvoffset\zhvt@outputpage}
\newcommand{\zhvt@setvoffset}{%
    \ifodd \c@page
        \setlength{\voffset}{\dimexpr\l_zhvt_paper_width_dim-\l_zhvt_text_width_dim-0.5\l_zhvt_baseline_skip_dim}
    \else
        \setlength{\voffset}{0.5\l_zhvt_baseline_skip_dim}
    \fi
}

% 書名葉
\RenewDocumentCommand{\maketitle}{ommm}{%
    \IfNoValueTF{#1}
        {\cs_new:Nn \__zhvt_title_size: {\fontsize{3\l_zhvt_font_size_dim}{0pt}}}
        {\cs_new:Nn \__zhvt_title_size: {\fontsize{#1\l_zhvt_font_size_dim}{0pt}}}
    \titlematter
    \begin{picture}(\textwidth,\textheight)
        \put(0,\textheight-\baselineskip){\symbol{"3000}\parbox{\dimexpr\textwidth-\l_zhvt_font_size_dim}{#2}}
        \put(0,0.5\textheight){\parbox[t]{\textwidth}{\__zhvt_title_size:\hfil #3}}
        \put(0,\baselineskip){\parbox{\dimexpr\textwidth-\l_zhvt_font_size_dim}{\hfill #4}\symbol{"3000}}
    \end{picture}
    \cleardoublepage
}

% 图像
\NewDocumentCommand{\insertgraphics}{om}{
    \clearpage
    \bool_set_false:N \l_zhvt_grid_lines_bool
    \null \vfil \hfil \includegraphics[#1]{#2}
    \clearpage
    \bool_set_true:N \l_zhvt_grid_lines_bool
}

% 绘制页框、界栏、鱼尾，设置版心等
\NewDocumentCommand{\zhvt@setlayout}{}{
    \__zhvt_set_page_center:
    \__zhvt_draw_grid:
    \__zhvt_draw_yuwei:
    \__zhvt_draw_frame:
    \__zhvt_draw_grid_lines:
}

% 设置书口
\cs_new:Nn \__zhvt_set_page_center: {
    % 书名
    \int_if_odd:nTF \c@page {
        \put(\l_zhvt_top_margin_dim,-\l_zhvt_text_width_dim-0.5\l_zhvt_baseline_skip_dim)
          {\@title}
    }{
        \put(\l_zhvt_top_margin_dim,0.5\l_zhvt_baseline_skip_dim)
          {\@title}
    }

    % 篇名，页码，仅奇数页
    \int_if_odd:nT \c@page {
        \put(\l_zhvt_top_margin_dim+0.4\l_zhvt_text_height_dim,-\l_zhvt_text_width_dim-0.25\l_zhvt_baseline_skip_dim)
          {%
            \jiazhusize%
            \bool_if:nT \l_zhvt_foreword_matter_bool {序}%
            \bool_if:nT \l_zhvt_toc_matter_bool {目錄}%
            \bool_if:nT \l_zhvt_main_matter_bool {\l_zhvt_current_chapter_title_str}
          }
        % 页码
        \bool_if:nF \l_zhvt_title_matter_bool {
            \put(\l_zhvt_top_margin_dim+0.85\l_zhvt_text_height_dim,-\l_zhvt_text_width_dim-0.25\l_zhvt_baseline_skip_dim)
              {\jiazhusize\__zhvt_page:}
        }
    }
}

% 设置内框坐标，upperleft 左上角，lowerright 右下角。
\dim_new:N \l_zhvt_grid_upper_dim
\dim_new:N \l_zhvt_grid_lower_dim
\dim_new:N \l_zhvt_grid_left_dim
\dim_new:N \l_zhvt_grid_right_dim
\cs_new:Nn \__zhvt_calculate_grid_position: {
    \dim_set:Nn \l_zhvt_grid_upper_dim {\l_zhvt_top_margin_dim-0.5\l_zhvt_line_sep_dim}
    \dim_set:Nn \l_zhvt_grid_lower_dim {\l_zhvt_top_margin_dim+\l_zhvt_text_height_dim+0.5\l_zhvt_line_sep_dim}
    \dim_set:Nn \l_zhvt_grid_left_dim {-\l_zhvt_text_width_dim}
    \dim_set:Nn \l_zhvt_grid_right_dim {\z@}
}

% 内框
\cs_new:Nn \__zhvt_draw_grid: {
    \put(0,0){%
        \begin{tikzpicture}[
                overlay,
                color=\l_zhvt_grid_color_str,
                line~width=\l_zhvt_grid_line_width_dim
            ]
            \int_if_odd:nTF \c@page {
                \draw (\l_zhvt_grid_upper_dim,\l_zhvt_grid_left_dim-0.5\l_zhvt_baseline_skip_dim)
                  --(\l_zhvt_grid_upper_dim,\l_zhvt_grid_right_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_right_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_left_dim-0.5\l_zhvt_baseline_skip_dim);
                \draw (\l_zhvt_grid_upper_dim,\l_zhvt_grid_left_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_left_dim);
            }{
                \draw (\l_zhvt_grid_upper_dim,\l_zhvt_grid_right_dim+0.5\l_zhvt_baseline_skip_dim)
                  --(\l_zhvt_grid_upper_dim,\l_zhvt_grid_left_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_left_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_right_dim+0.5\l_zhvt_baseline_skip_dim);
                \draw (\l_zhvt_grid_upper_dim,\l_zhvt_grid_right_dim)
                  --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_right_dim);
            }
        \end{tikzpicture}
    }
}

% 鱼尾
\cs_new:Nn \__zhvt_draw_yuwei: {
    \int_if_odd:nTF \c@page {
        \put(\l_zhvt_top_margin_dim+0.3\l_zhvt_text_height_dim,-\l_zhvt_text_width_dim-0.5\l_zhvt_baseline_skip_dim-0.5\l_zhvt_grid_line_width_dim){%
            \begin{tikzpicture}[color=\l_zhvt_grid_color_str]
                \draw[fill=\l_zhvt_grid_color_str,line~width=\z@]
                  (0,0) -- (0.5\l_zhvt_font_size_dim,0)
                  -- (\l_zhvt_font_size_dim,0.5\l_zhvt_baseline_skip_dim)
                  -- (0,0.5\l_zhvt_baseline_skip_dim) -- cycle;
                \draw[color=\l_zhvt_grid_color_str,line~width=\l_zhvt_grid_line_width_dim]
                  (0.7\l_zhvt_text_width_dim,0)--(0.7\l_zhvt_text_width_dim,0.5\l_zhvt_baseline_skip_dim);
                \draw[color=\l_zhvt_grid_color_str,line~width=\l_zhvt_grid_line_width_dim]
                  (0,0)--(0.7\l_zhvt_text_width_dim,0);
            \end{tikzpicture}
        }
    }{
        \put(\l_zhvt_top_margin_dim+0.3\l_zhvt_text_height_dim,-0.5\l_zhvt_grid_line_width_dim){%
            \begin{tikzpicture}[color=\l_zhvt_grid_color_str]
                \draw[fill=\l_zhvt_grid_color_str,line~width=\z@]
                (0,0) -- (\l_zhvt_font_size_dim,0)
                -- (0.5\l_zhvt_font_size_dim,0.5\l_zhvt_baseline_skip_dim)
                -- (0,0.5\l_zhvt_baseline_skip_dim) -- cycle;
                \draw[color=\l_zhvt_grid_color_str,line~width=\l_zhvt_grid_line_width_dim]
                (0.7\l_zhvt_text_width_dim,0)--(0.7\l_zhvt_text_width_dim,0.5\l_zhvt_baseline_skip_dim);
                \draw[color=\l_zhvt_grid_color_str,line~width=\l_zhvt_grid_line_width_dim]
                (0,0.5\l_zhvt_baseline_skip_dim)--(0.7\l_zhvt_text_width_dim,0.5\l_zhvt_baseline_skip_dim);
            \end{tikzpicture}
        }
    }
}

% 外框
\cs_new:Nn \__zhvt_draw_frame: {
    \put(0,0){%
        \begin{tikzpicture}[overlay,color=\l_zhvt_grid_color_str,line~width=\l_zhvt_frame_line_width_dim]
            \int_if_odd:nTF \c@page {
                \draw
                  (\l_zhvt_grid_upper_dim-\l_zhvt_frame_sep_dim,\l_zhvt_grid_left_dim-0.5\l_zhvt_baseline_skip_dim)
                  --(\l_zhvt_grid_upper_dim-\l_zhvt_frame_sep_dim,\l_zhvt_grid_right_dim+\l_zhvt_frame_sep_dim)
                  --(\l_zhvt_grid_lower_dim+\l_zhvt_frame_sep_dim,\l_zhvt_grid_right_dim+\l_zhvt_frame_sep_dim)
                  --(\l_zhvt_grid_lower_dim+\l_zhvt_frame_sep_dim,\l_zhvt_grid_left_dim-0.5\l_zhvt_baseline_skip_dim);
           }{
                \draw
                  (\l_zhvt_grid_upper_dim-\l_zhvt_frame_sep_dim,\l_zhvt_grid_right_dim+0.5\l_zhvt_baseline_skip_dim)
                  --(\l_zhvt_grid_upper_dim-\l_zhvt_frame_sep_dim,\l_zhvt_grid_left_dim-\l_zhvt_frame_sep_dim)
                  --(\l_zhvt_grid_lower_dim+\l_zhvt_frame_sep_dim,\l_zhvt_grid_left_dim-\l_zhvt_frame_sep_dim)
                  --(\l_zhvt_grid_lower_dim+\l_zhvt_frame_sep_dim,\l_zhvt_grid_right_dim+0.5\l_zhvt_baseline_skip_dim);
            }
        \end{tikzpicture}
    }
}

% 界栏
\bool_new:N \l_zhvt_grid_lines_bool
\bool_set_true:N \l_zhvt_grid_lines_bool
\NewDocumentCommand{\gridlines}{}{\bool_set_true:N \l_zhvt_grid_lines_bool}
\NewDocumentCommand{\nogridlines}{}{\bool_set_false:N \l_zhvt_grid_lines_bool}
\tl_new:N \l_zhvt_grid_line_index_tl

\cs_new:Nn \__zhvt_draw_grid_lines: {
    \bool_if:nT \l_zhvt_grid_lines_bool {
        \bool_if:nTF \l_zhvt_title_matter_bool {
            \tl_set:Nn \l_zhvt_grid_line_index_tl {2,\int_eval:n {\l_zhvt_page_lines_int-2}}
        }{
            \tl_set:Nn \l_zhvt_grid_line_index_tl {1,2,...,\int_eval:n {\l_zhvt_page_lines_int-1}}
        }
        \put(0,0){%
            \begin{tikzpicture}[overlay,color=\l_zhvt_grid_color_str,line~width=\l_zhvt_grid_line_width_dim]
                \foreach \i in \l_zhvt_grid_line_index_tl {
                    \draw
                       (\l_zhvt_grid_upper_dim,\l_zhvt_grid_left_dim+\i\l_zhvt_baseline_skip_dim)
                       --(\l_zhvt_grid_lower_dim,\l_zhvt_grid_left_dim+\i\l_zhvt_baseline_skip_dim);
                }
            \end{tikzpicture}
        }
    }
}

\AtEndPreamble{
    % 计算相关长度
    \__zhvt_calculate_dimensions:
    \__zhvt_calculate_grid_position:
    % 页面尺寸设置
    \geometry{
        paperwidth=\l_zhvt_paper_height_dim,
        paperheight=\l_zhvt_paper_width_dim,
        textwidth=\l_zhvt_text_height_dim,
        textheight=\l_zhvt_text_width_dim,
        % 左侧间距（底部间距）设置为 0，后面根据奇偶页进行调整
        % 此处设为 -\zhvt@vtadjust 微调每行的视觉中心线
        top=-\l_zhvt_micro_offset_dim,
        left=\l_zhvt_top_margin_dim,
        noheadfoot,
        nomarginpar,
    }
    % 设置字体
    \defaultCJKfontfeatures{RawFeature={vertical:+vert:+vhal}}
    \setCJKmainfont{\l_zhvt_main_font_str}
    % 夹注相关设置
    \setCJKfamilyfont{jiazhufont}{\l_zhvt_jiazhu_font_str}
    \NewDocumentCommand{\jiazhufont}{}{\CJKfamily{jiazhufont}}
    \NewDocumentCommand{\jiazhusize}{}{
        \fontsize{0.5\l_zhvt_font_size_dim}{0.5\l_zhvt_font_size_dim}
        \selectfont
    }
    \jiazhuset{
        format=\jiazhufont,
        ratio=1/2,
        beforeskip=0pt,
        afterskip=0pt,
    }
    % 取消首行缩进
    \setlength{\parindent}{\z@}
    % 设置空页面样式
    \pagestyle{empty}
}

\AtBeginDocument {
    \fontsize{\l_zhvt_font_size_dim}{\l_zhvt_baseline_skip_dim}
    \selectfont
}

\AtEndDocument{\cleardoublepage}

\ExplSyntaxOff

% 输出页面
\AtBeginShipout{%
    % 旋转页面
    \global\setbox\AtBeginShipoutBox\vbox{%
        \special{pdf: put @thispage <</Rotate 90>>}%
        \box\AtBeginShipoutBox}%
    % 输出版心、框线
    \AtBeginShipoutUpperLeft{%
        \zhvt@setlayout
    }
}


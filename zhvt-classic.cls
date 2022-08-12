% LaTeX 中文綫裝書模板
%
% 本模板：
% 1. 個人免費使用，但僅限於：學習、研究、非經營性分發採用本模板
%    生成的最終作品。
% 2. 除此上述用途之外，請與本人聯係獲取授權。
% 3. 本模板所引用宏包版權歸開發者所有，如需授權請自行聯繫。
%
% 郵件： chianjin@foxmail.com
% 微信：w1280543
%
% 項目地址：https://github.com/chianjin/zhvt-classic

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{zhvt-classic}
\ProcessOptions\relax
\LoadClass[oneside]{book}   % 啟用 oneside 選項，避免左右間距的自動調整
%\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage[LoadFandol=false]{xeCJK}
\RequirePackage{zhnumber}
\RequirePackage{geometry}
\RequirePackage{atbegshi}   % 用於實現頁面旋轉、框綫、界欄、魚尾等版式部件
\RequirePackage{tikz}
\RequirePackage{keyval}
\RequirePackage{jiazhu}     % 夾註包 https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu

\ExplSyntaxOn
% 使得夾註行寬總是漢字寬度的偶數倍
% https://github.com/CTeX-org/ctex-kit/issues/631
% 感謝 Qing Lee https://github.com/qinglee
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

% 參數定義
\str_new:N \l_zhvt_main_font_str                % 正文字體
\str_new:N \l_zhvt_jiazhu_font_str              % 夾註字體
\dim_new:N \l_zhvt_paper_width_dim              % 頁面寬度（頁面高度）
\dim_new:N \l_zhvt_paper_height_dim             % 頁面高度（頁面寬度）
\dim_new:N \l_zhvt_font_size_dim                % 字體尺寸
\fp_new:N  \l_zhvt_baseline_skip_ratio_fp       % 行距倍數
\int_new:N \l_zhvt_page_lines_int               % 每頁行數
\int_new:N \l_zhvt_line_chars_int               % 每行字數
\fp_new:N  \l_zhvt_top_bottom_ratio_fp          % 天頭、地腳高度比例
\dim_new:N \l_zhvt_grid_line_width_dim          % 內框綫寬
\dim_new:N \l_zhvt_frame_line_width_dim         % 外框綫寬
\dim_new:N \l_zhvt_frame_sep_dim                % 內外框間距
\str_new:N \l_zhvt_grid_color_str               % 欄框顏色
\dim_new:N \l_zhvt_micro_offset_dim             % 字體旋轉後，行的視覺中綫有所變化，對此進行微調
\fp_new:N \l_zhvt_judou_vertical_offset_fp      % 句讀垂直位移
\fp_new:N \l_zhvt_judou_horizontal_offset_fp    % 句讀水平位移
\int_new:N \l_zhvt_foreword_margin_int          % 序言環境縮進
\int_new:N \l_zhvt_chapter_indent_int           % 章標題縮進
\int_new:N \l_zhvt_section_indent_int           % 節標題縮進

\dim_new:N \l_zhvt_baseline_skip_dim            % 行距，兩行基綫的距離
\dim_new:N \l_zhvt_line_sep_dim                 % 行間距，上行底部與下行頂部的距離
\dim_new:N \l_zhvt_text_width_dim               % 文本寬度（文本高度）
\dim_new:N \l_zhvt_text_height_dim              % 文本高度（文本寬度）
\dim_new:N \l_zhvt_top_margin_dim               % 天頭高度（左側頁邊距）

\keys_define:nn {zhvt} {
    main_font           .str_set:N = \l_zhvt_main_font_str,
    main_font           .initial:n = Source~Han~Serif~SemiBold,
    font_size           .dim_set:N = \l_zhvt_font_size_dim,
    font_size           .initial:n = 20pt,
    baselineskip_ratio   .fp_set:N = \l_zhvt_baseline_skip_ratio_fp,
    baselineskip_ratio  .initial:n = 1.5,
    jiazhu_font         .str_set:N = \l_zhvt_jiazhu_font_str,
    jiazhu_font         .initial:n = Source~Han~Serif~SemiBold,
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
    judou_voffset        .fp_set:N = \l_zhvt_judou_vertical_offset_fp,
    judou_voffset       .initial:n = -0.4,
    judou_hoffset        .fp_set:N = \l_zhvt_judou_horizontal_offset_fp,
    judou_hoffset       .initial:n = 0.3,
    foreword_margin     .int_set:N = \l_zhvt_foreword_margin_int,
    foreword_margin     .initial:n = 2,
    chapter_indent      .int_set:N = \l_zhvt_chapter_indent_int,
    chapter_indent      .initial:n = 1,
    section_indent      .int_set:N = \l_zhvt_section_indent_int,
    section_indent      .initial:n = 2,
}
\NewDocumentCommand {\zhvtset} { }
  { \keys_set:nn { zhvt } }

% 計算後續所需的一些長度
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


% 實現 oneside 選項下的 \cleardoublepage
\RenewDocumentCommand{\cleardoublepage}{}{%
    \clearpage
    \int_if_odd:nF \c@page {\hbox{}\newpage}
}

% 句讀
\NewDocumentCommand{\judou}{m}{%
    \CJKglue\begin{picture}(0,0)
        \put(\fp_use:N \l_zhvt_judou_vertical_offset_fp em,\fp_use:N \l_zhvt_judou_horizontal_offset_fp em){#1}
    \end{picture}\CJKglue
}
\NewDocumentCommand{\ju}{}{\judou{。}}
\NewDocumentCommand{\dou}{}{\judou{、}}

% 序言環境
\NewDocumentEnvironment{foreword}{O{\l_zhvt_foreword_margin_int}}
{%
    \begin{list}{}{
        \topsep\z@
        \parskip\z@
        \parsep\z@
        \partopsep\z@
        \setlength{\leftmargin}{#1 em}
    }\item[]
}{\end{list}}
% 序言環境別名，少打幾個字符
\NewDocumentEnvironment{fw}{}{\begin{foreword}}{\end{foreword}}

% 夾註 Hack
% 跨頁夾註，糾正位置偏移
\NewDocumentCommand{\newpagejiazhu}{}{\vphantom{國}\jiazhu}
% 夾註相關快捷命令，少打幾個字母
\NewDocumentCommand{\jz}{}{\jiazhu}
\NewDocumentCommand{\njz}{}{\newpagejiazhu}

% 重定義目錄
\RenewDocumentCommand{\tableofcontents}{}{
    \tocmatter\hspace{2\l_zhvt_font_size_dim} 目錄\@starttoc{toc}\cleardoublepage
}
% 重定義章、節，以符合綫裝書樣式
\tl_new:N \l_zhvt_current_chapter_title_tl
\tl_new:N \l_zhvt_content_line_tl
\RenewDocumentCommand{\chapter}{smo}{%
    \cleardoublepage%
    \refstepcounter{chapter}%
    \IfBooleanTF{#1}
        {\tl_set:Nn \l_zhvt_current_chapter_title_tl {#2}}
        {\tl_set:Nn \l_zhvt_current_chapter_title_tl {#2第\zhnum{chapter}}}%
    \tl_set:Nn \l_zhvt_content_line_tl {%
        \par\hspace{\int_use:N \l_zhvt_chapter_indent_int em}
        \l_zhvt_current_chapter_title_tl
    }%
    \addtocontents{toc}{\l_zhvt_content_line_tl}%
    \l_zhvt_content_line_tl%
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

% 傳統綫裝書，正反算一葉：1,2 -> 一，3,4 -> 二
\int_new:N \l_zhvt_page_int
\cs_new:Nn \__zhvt_page: {%
    \int_set:Nn \l_zhvt_page_int {\c@page/2}%
    \zhnumber{\int_use:N \l_zhvt_page_int}%
}

% 文檔結構
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

% 奇偶頁右側間距，即原始頁面頂部間距。
% 奇數頁左側、偶數頁右側各留一半行距的間距
% 雙頁合併後，正好居中一行寬度的書口。
% TODO: 待轉換為 expl3 語法
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
\RenewDocumentCommand{\maketitle}{O{3}mmO{\@title}}{%
    \cs_new:Nn \__zhvt_title_size: {\fontsize{#1\l_zhvt_font_size_dim}{0pt}\selectfont}
    \titlematter
    \begin{picture}(\textwidth,\textheight)
        \put(0,\textheight-\baselineskip){\symbol{"3000}\parbox{\dimexpr\textwidth-\l_zhvt_font_size_dim}{#2}}
        \put(0,0.5\textheight){\parbox{\textwidth}{%
            \__zhvt_title_size: \hfil #4}
        }
        \put(0,\baselineskip){\parbox{\dimexpr\textwidth-\l_zhvt_font_size_dim}{\hfill #3}\symbol{"3000}}
    \end{picture}
    \cleardoublepage
}

% 圖像葉
\NewDocumentCommand{\insertgraphics}{om}{
    \clearpage
    \bool_set_false:N \l_zhvt_grid_lines_bool
    \null \vfil \hfil \includegraphics[#1]{#2}
    \clearpage
    \bool_set_true:N \l_zhvt_grid_lines_bool
}

% 繪製頁框、界欄、魚尾，設置版心等
\NewDocumentCommand{\zhvt@setlayout}{}{
    \__zhvt_set_page_center:
    \__zhvt_draw_grid:
    \__zhvt_draw_yuwei:
    \__zhvt_draw_frame:
    \__zhvt_draw_grid_lines:
}

% 設置版心
\cs_new:Nn \__zhvt_set_page_center: {
    % 書名
    \int_if_odd:nTF \c@page {
        \put(\l_zhvt_top_margin_dim,-\l_zhvt_text_width_dim-0.5\l_zhvt_baseline_skip_dim)
          {\@title}
    }{
        \put(\l_zhvt_top_margin_dim,0.5\l_zhvt_baseline_skip_dim)
          {\@title}
    }

    % 篇名，頁碼，僅奇數頁
    \int_if_odd:nT \c@page {
        \put(\l_zhvt_top_margin_dim+0.4\l_zhvt_text_height_dim,-\l_zhvt_text_width_dim-0.25\l_zhvt_baseline_skip_dim)
          {%
            \jiazhusize%
            \bool_if:nT \l_zhvt_foreword_matter_bool {序}%
            \bool_if:nT \l_zhvt_toc_matter_bool {目錄}%
            \bool_if:nT \l_zhvt_main_matter_bool {\l_zhvt_current_chapter_title_tl}
          }
        % 頁碼
        \bool_if:nF \l_zhvt_title_matter_bool {
            \put(\l_zhvt_top_margin_dim+0.85\l_zhvt_text_height_dim,-\l_zhvt_text_width_dim-0.25\l_zhvt_baseline_skip_dim)
              {\jiazhusize\__zhvt_page:}
        }
    }
}

% 設置內框坐標，upperleft 左上角，lowerright 右下角。
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

% 內框
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

% 魚尾
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

% 界欄
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
    % 計算相關長度
    \__zhvt_calculate_dimensions:
    \__zhvt_calculate_grid_position:
    % 頁面尺寸設置
    \geometry{
        paperwidth=\l_zhvt_paper_height_dim,
        paperheight=\l_zhvt_paper_width_dim,
        textwidth=\l_zhvt_text_height_dim,
        textheight=\l_zhvt_text_width_dim,
        % 左側間距（底部間距）設置為 0，後面根據奇偶頁進行調整
        % 此處設為 -\zhvt@vtadjust 微調每行的視覺中心綫
        top=-\l_zhvt_micro_offset_dim,
        left=\l_zhvt_top_margin_dim,
        noheadfoot,
        nomarginpar,
    }
    % 設置字體
    \defaultCJKfontfeatures{RawFeature={vertical:+vert:+vhal}}
    \setCJKmainfont{\l_zhvt_main_font_str}
    % 夾註相關設置
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
    % 取消首行縮進
    \setlength{\parindent}{\z@}
    % 設置空頁面樣式
    \pagestyle{empty}
}

\AtBeginDocument {
    \fontsize{\l_zhvt_font_size_dim}{\l_zhvt_baseline_skip_dim}
    \selectfont
}

\ExplSyntaxOff

\newlength{\zhvt@noteboxwidth}
\NewDocumentCommand{\note}{m}{%
    \settowidth{\zhvt@noteboxwidth}{#1}%
    \raisebox{-0.5em}{%
        \begin{tikzpicture}[inner sep=0pt,outer sep=0pt]
            \draw[draw=none,
                fill=black,
                rounded corners=0.1em,
                line width=0pt
              ] (0,0) rectangle (\zhvt@noteboxwidth,1em);
            \node[color=white,right] at (0, 0.88em) {#1};
        \end{tikzpicture}%
    }%
}

\AtEndDocument{\cleardoublepage}

% 輸出頁面
\AtBeginShipout{%
    % 旋轉頁面
    \global\setbox\AtBeginShipoutBox\vbox{%
        \special{pdf: put @thispage <</Rotate 90>>}%
        \box\AtBeginShipoutBox}%
    % 輸出版心、框綫
    \AtBeginShipoutUpperLeft{%
        \zhvt@setlayout
    }
}

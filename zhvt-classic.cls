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
\ProvidesClass{zhvt-classic}
\ProcessOptions\relax
\RequirePackage{fix-cm}
\LoadClass[oneside]{book}   % 启用 oneside 选项，避免实际左右间距的自动调整
\RequirePackage{xparse}
\RequirePackage[LoadFandol=false]{xeCJK}
\RequirePackage{zhnumber}
\RequirePackage{jiazhu}     % 割注包 https://github.com/CTeX-org/ctex-kit/tree/master/jiazhu
\RequirePackage{graphicx}
\RequirePackage{l3draw}

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
\cs_new:Nn \__zhvt_calculate_dimensions:
  {
    \dim_set:Nn \l_zhvt_baseline_skip_dim
      { \fp_to_dim:n { \l_zhvt_baseline_skip_ratio_fp * \l_zhvt_font_size_dim } }
    \dim_set:Nn \l_zhvt_line_sep_dim
      { \l_zhvt_baseline_skip_dim - \l_zhvt_font_size_dim }
    \dim_set:Nn \l_zhvt_text_width_dim
      { \l_zhvt_baseline_skip_dim * \l_zhvt_page_lines_int }
    \dim_set:Nn \l_zhvt_text_height_dim
      { \l_zhvt_font_size_dim * \l_zhvt_line_chars_int }
  }

% 实现 oneside 选项下的 \cleardoublepage
\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \int_if_even:nF { \g_shipout_totalpages_int }
      {
        \hbox:n { }
        \newpage
      }
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

% 夹注相关快捷命令，少打几个字母
\NewDocumentCommand{\jz}{}{\jiazhu}

%% 使用两种 mark 类型，分别保存章和节的标题
\mark_new_class:n { zhvt_chapter }
\mark_new_class:n { zhvt_section }

% 重定义目录
\RenewDocumentCommand \tableofcontents { }
  {
    \tocmatter
    \mark_insert:nn { zhvt_chapter } { 目錄 }
    \skip_horizontal:n { \l_zhvt_font_size_dim * 2 } 目錄
    \@starttoc { toc }
    \cleardoublepage
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
    \mark_insert:nn { zhvt_chapter } {#2}
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
    \mark_insert:nn { zhvt_section } {#1}
    \l_zhvt_content_line_str%
    \IfNoValueF{#2}{\jiazhu{#2}}
    \par
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
    \pagenumbering { zhnum }
    \bool_set_false:N \l_zhvt_title_matter_bool
    \bool_set_false:N \l_zhvt_foreword_matter_bool
    \bool_set_true:N  \l_zhvt_toc_matter_bool
    \bool_set_false:N \l_zhvt_main_matter_bool
}
\RenewDocumentCommand{\mainmatter}{}{
    \cleardoublepage
    \bool_if:NF \l_zhvt_toc_matter_bool
      { \pagenumbering { zhnum } }
    \bool_set_false:N \l_zhvt_title_matter_bool
    \bool_set_false:N \l_zhvt_foreword_matter_bool
    \bool_set_false:N \l_zhvt_toc_matter_bool
    \bool_set_true:N  \l_zhvt_main_matter_bool
}

% 書名葉
\RenewDocumentCommand \maketitle { O { 3 } m m O { \@title } }
  {
    \cleardoublepage
    \titlematter
    \__zhvt_page_box:n
      {
        \__zhvt_move_hbox:nn { down } {#2}
        \vss
        \nointerlineskip
        \hbox_to_wd:nn { \l_zhvt_text_height_dim }
          {
            \hss
            \fontsize
              { \dim_eval:n { \l_zhvt_font_size_dim * \int_eval:n {#1} } }
              { \c_zero_skip }
            \selectfont
            #4
            \hss
          }
        \vss
        \nointerlineskip
        \__zhvt_move_hbox:nn { up } {#3}
      }
    \cleardoublepage
  }
\cs_new_protected:Npn \__zhvt_move_hbox:nn #1#2
  {
    \hbox_gset:Nn \g_tmpa_box
      {
        \use:c { box_move_ #1 :nn }
          { \l_zhvt_baseline_skip_dim }
          {
            \hbox_to_wd:nn
              { \l_zhvt_text_height_dim }
              {
                \str_if_eq:nnTF {#1} { up }
                  { \hss #2 \skip_horizontal:n { \l_zhvt_font_size_dim } }
                  { \skip_horizontal:n { \l_zhvt_font_size_dim } #2 \hss }
              }
          }
      }
    \str_if_eq:nnF {#1} { up }
      { \box_gset_dp:Nn \g_tmpa_box { \c_zero_dim } }
    \box_use_drop:N \g_tmpa_box
  }

% 图像
\NewDocumentCommand \insertgraphics { O { } m }
  {
    \cleardoublepage
    \bool_set_false:N \l_zhvt_grid_lines_bool
    \__zhvt_page_box:n
      {
        \vss
        \hbox_to_wd:nn { \l_zhvt_text_height_dim }
          { \hss \includegraphics [#1] {#2} \hss }
        \vss
      }
    \cleardoublepage
    \bool_set_true:N \l_zhvt_grid_lines_bool
  }

\cs_new_protected:Npn \__zhvt_page_box:n #1
  {
    \hrule width \c_zero_dim \scan_stop:
    \skip_vertical:n { - \topskip - \c__zhvt_fix_top_skip }
    \hbox_gset:Nn \g_tmpa_box
      {
        \box_move_down:nn { \l_zhvt_text_width_dim }
          { \vbox_to_ht:nn { \l_zhvt_text_width_dim } {#1} }
      }
    \box_gset_ht:Nn \g_tmpa_box { \c_zero_dim }
    \box_gset_dp:Nn \g_tmpa_box { \c_zero_dim }
    \box_use_drop:N \g_tmpa_box
  }

\bool_new:N \l_zhvt_grid_lines_bool
\bool_set_true:N \l_zhvt_grid_lines_bool
\NewDocumentCommand \gridlines { }
  { \bool_set_true:N \l_zhvt_grid_lines_bool }
\NewDocumentCommand \nogridlines { }
  { \bool_set_false:N \l_zhvt_grid_lines_bool }

\RenewDocumentCommand \normalsize { }
  {
    \fontsize { \l_zhvt_font_size_dim } { \l_zhvt_baseline_skip_dim }
    \selectfont
  }

%% 调整钩子顺序，避免警告
\hook_gset_rule:nnnn { begindocument/before }
  { zhvt } { < } { xeCJK  }
\hook_gput_code:nnn { begindocument/before } { zhvt }
  {
    % 计算相关长度
    \__zhvt_calculate_dimensions:
    \normalsize
    %% 设置比较大的 \topskip，保证首行基线对齐
    \skip_set:Nn \topskip
      { \l_zhvt_baseline_skip_dim * 4 / 5 }
    %% 用于页面盒子构建完成后，修正 \topskip 的误差
    \skip_const:Nn \c__zhvt_fix_top_skip
      { \l_zhvt_baseline_skip_dim / 2 - \topskip }
    \dim_const:Nn \c__zhvt_shipout_ht_dim
      {
          \l_zhvt_text_width_dim * 2
        + \l_zhvt_baseline_skip_dim
        + \c__zhvt_fix_top_skip
      }
    % 页面尺寸设置
    \dim_set_eq:NN \textwidth  \l_zhvt_text_height_dim
    \dim_set_eq:NN \textheight \l_zhvt_text_width_dim
    % 自动拼版后的纸张大小，并将所有页面顺时针旋转 90 度
    \dim_set_eq:NN \paperwidth \l_zhvt_paper_height_dim
    \dim_set:Nn \paperheight { \l_zhvt_paper_width_dim * 2 }
    \dim_set_eq:NN \pdfpagewidth  \paperwidth
    \dim_set_eq:NN \pdfpageheight \paperheight
    \hook_gput_code:nnn { shipout/firstpage } { zhvt }
      { \special { pdf: ~ put ~ @pages <</Rotate ~ 90>> } }
    % 设置字体
    \defaultCJKfontfeatures { Script = CJK , RawFeature = vertical }
    \setCJKmainfont { \l_zhvt_main_font_str }
    % 夹注相关设置
    \newCJKfontfamily \jiazhufont { \l_zhvt_jiazhu_font_str }
    \NewDocumentCommand \jiazhusize { }
      {
        \fontsize
          { \dim_eval:n { \l_zhvt_font_size_dim / 2 } }
          { \dim_eval:n { \l_zhvt_font_size_dim / 2 } }
        \selectfont
      }
    \jiazhuset
      {
        format     = \jiazhufont ,
        ratio      = 1/2 ,
        beforeskip = \c_zero_skip ,
        afterskip  = \c_zero_skip ,
      }
    \dim_zero:N \parindent
  }

\hook_gput_code:nnn { enddocument } { zhvt }
  { \cleardoublepage }

% 我们不需要页眉页脚，也不需要每次都更新 page，版心的位置用 \hoffset 和 \voffset 设置，
% 为此，从 \@outputpage 中删去相关无用设置，减少干扰
\cs_new_eq:NN \latex@outputpage \@outputpage
\group_begin:
\cs_set:Npn \@_tmp:w #1 \shipout \vbox #2 #3 \stepcounter #4 #5 \s_stop
  {
    \cs_new_protected:Npn \zhvt_outout_page:
      {
        #1
        \shipout \box \@outputbox
        #3
        \endgroup
        #5
      }
  }
\exp_after:wN \@_tmp:w \@outputpage \s_stop
\group_end:
\cs_set_eq:NN \@outputpage \zhvt_outout_page:
%% 将两页拼版完成后再更新 page 计数器
\hook_gput_code:nnn { shipout/after } { zhvt }
  { \stepcounter { page } }
%% 奇数页先将页面盒子保存起来备用，偶数页则将完成拼版输出
\hook_gput_code:nnn { shipout/before } { zhvt }
  {
    \int_if_even:nTF { \g_shipout_totalpages_int }
      { \__zhvt_save_shipout_box: }
      { \__zhvt_build_shipout_box: }
  }
%% 奇数保存盒子，不输出
\cs_new_protected:Npn \__zhvt_save_shipout_box:
  {
    \box_gset_eq_drop:NN \g__zhvt_last_shipout_box \l_shipout_box
    \tl_gset:Nx \g__zhvt_chapter_mark_tl
      { \mark_use_first:nn { page } { zhvt_chapter } }
    \shipout_discard:
  }
\tl_new:N \g__zhvt_chapter_mark_tl
\box_new:N \g__zhvt_last_shipout_box
%% 偶数页完成拼版输出
\cs_new_protected:Npn \__zhvt_build_shipout_box:
  {
    \vbox_set_to_ht:Nnn \l_shipout_box
      { \c__zhvt_shipout_ht_dim }
      {
        \skip_vertical:N \c__zhvt_fix_top_skip
        \box_use_drop:N \g__zhvt_last_shipout_box
        \vss
        \__zhvt_put_center_box:
        \__zhvt_fix_baseline_skip:
        \box_use_drop:N \l_shipout_box
      }
    %% 加入书口、框线、界栏、鱼尾等版式部件，更新版心盒子大小与外框线大小相同
    \vbox_gset:Nn \g__zhvt_last_shipout_box
      {
        \__zhvt_put_frame_box:
        \box_move_right:nn
          { \g__zhvt_xshift_dim }
          { \box_use_drop:N \l_shipout_box }
      }
    \hbox_gset:Nn \g__zhvt_last_shipout_box
      {
        \box_move_up:nn
          { \g__zhvt_yshift_dim }
          { \box_use_drop:N \g__zhvt_last_shipout_box }
      }
    \box_gset_ht:Nn \g__zhvt_last_shipout_box { \g__zhvt_total_ht_dim }
    \box_gset_wd:Nn \g__zhvt_last_shipout_box { \g__zhvt_total_wd_dim }
    \box_set_eq_drop:NN \l_shipout_box \g__zhvt_last_shipout_box
  }
%% 加入书口
\cs_new_protected:Npn \__zhvt_put_center_box:
  {
    \nointerlineskip
    \hbox:n
      {
        \tl_if_empty:NTF \g__zhvt_chapter_mark_tl
          { \@title }
          {
            \hbox_overlap_right:n { \@title }
            \jiazhusize
            \skip_horizontal:n { \l_zhvt_font_size_dim * 8 }
            \box_move_up:nn { \l_zhvt_baseline_skip_dim / 4 }
              { \hbox_overlap_right:n { \g__zhvt_chapter_mark_tl } }
            \skip_horizontal:n { \l_zhvt_font_size_dim * 9 }
            \box_move_up:nn { \l_zhvt_baseline_skip_dim / 4 }
              { \hbox_overlap_right:n { \thepage } }
          }
      }
  }
%% 修正拼版的偏移误差
\cs_new_protected:Npn \__zhvt_fix_baseline_skip:
  {
    \skip_vertical:n
      { \l_zhvt_baseline_skip_dim - \prevdepth - \topskip }
    \nointerlineskip
  }
%% 加入框线、界栏、鱼尾等版式部件，我们缓存重复的背景盒子，不重复作图
\cs_new_protected:Npn \__zhvt_put_frame_box:
  {
    \exp_args:Nc \__zhvt_put_frame_box_aux:N
      {
        g__zhvt_frame
        _ \bool_to_str:N \l_zhvt_grid_lines_bool
        _ \bool_to_str:N \l_zhvt_title_matter_bool
        _box
      }
  }
\cs_new_protected:Npn \__zhvt_put_frame_box_aux:N #1
  {
    \box_if_exist:NF #1 { \__zhvt_build_frame_box:N #1 }
    \box_use:N #1
    \nointerlineskip
  }
%% 实际的作图环境
\cs_new_protected:Npn \__zhvt_build_frame_box:N #1
  {
    \box_new:N #1
    \hbox_gset:Nn #1
      {
        \draw_begin:
          \exp_args:Ne \color_fill:n { \l_zhvt_grid_color_str }
          \exp_args:Ne \color_stroke:n { \l_zhvt_grid_color_str }
          \draw_linewidth:n { \l_zhvt_grid_line_width_dim }
          \dim_add:Nn \l_zhvt_text_height_dim { \l_zhvt_line_sep_dim }
          %% 鱼尾
          \draw_transform_shift:n
            {
              \l_zhvt_font_size_dim * 6 + \l_zhvt_line_sep_dim / 2 ,
              - \l_zhvt_text_width_dim - \l_zhvt_baseline_skip_dim
            }
          \draw_path_moveto:n { \l_zhvt_font_size_dim / 2 , \l_zhvt_baseline_skip_dim / 2 }
          \draw_path_lineto:n { \l_zhvt_font_size_dim , \l_zhvt_baseline_skip_dim }
          \draw_path_lineto:n { 0 , \l_zhvt_baseline_skip_dim }
          \draw_path_lineto:n { 0 , 0 }
          \draw_path_lineto:n { \l_zhvt_font_size_dim , 0 }
          \draw_path_close:
          \draw_transform_xshift:n { \l_zhvt_font_size_dim / 2 * 21 }
          \draw_path_lineto:n { 0 , \l_zhvt_baseline_skip_dim / 2 }
          \draw_path_moveto:n { 0 , 0 }
          \draw_path_lineto:n { 0 , \l_zhvt_baseline_skip_dim }
          \draw_path_use_clear:n { fill , stroke }
          \draw_transform_shift_reset:
          %% 界栏
          \bool_if:NTF \l_zhvt_grid_lines_bool
            {
              \bool_if:NTF \l_zhvt_title_matter_bool
                {
                  \clist_map_function:nN
                    {
                      2 ,
                      \l_zhvt_page_lines_int - 2 ,
                      \l_zhvt_page_lines_int ,
                      \l_zhvt_page_lines_int + 1 ,
                      \l_zhvt_page_lines_int + 3 ,
                      \l_zhvt_page_lines_int * 2 - 2
                    } \__zhvt_draw_grid_lines:n
                }
                {
                  \prg_replicate:nn
                    { \l_zhvt_page_lines_int * 2 }
                    {
                      \draw_transform_yshift:n { - \l_zhvt_baseline_skip_dim }
                      \draw_path_moveto:n { 0 , 0 }
                      \draw_path_lineto:n { \l_zhvt_text_height_dim , 0 }
                    }
                }
            }
            {
              \bool_if:NTF \l_zhvt_title_matter_bool
                {
                  \clist_map_function:nN
                    {
                      \l_zhvt_page_lines_int ,
                      \l_zhvt_page_lines_int + 1 ,
                      \l_zhvt_page_lines_int + 3 ,
                      \l_zhvt_page_lines_int * 2 - 2
                    } \__zhvt_draw_grid_lines:n
                }
                {
                  \draw_transform_yshift:n
                    { - \l_zhvt_baseline_skip_dim * \l_zhvt_page_lines_int }
                  \prg_replicate:nn
                    { \l_zhvt_page_lines_int + 1 }
                    {
                      \draw_path_moveto:n { 0 , 0 }
                      \draw_path_lineto:n { \l_zhvt_text_height_dim , 0 }
                      \draw_transform_yshift:n { - \l_zhvt_baseline_skip_dim }

                    }
                }
            }
          \draw_path_use_clear:n { stroke }
          \draw_transform_shift_reset:
          %% 内框
          \dim_set:Nn \l_zhvt_text_width_dim
            { - \l_zhvt_text_width_dim * 2 - \l_zhvt_baseline_skip_dim }
          \draw_path_rectangle:nn
            { 0 , 0 }
            { \l_zhvt_text_height_dim , \l_zhvt_text_width_dim }
          \draw_path_use_clear:n { stroke }
          %% 外框
          \draw_linewidth:n { \l_zhvt_frame_line_width_dim }
          \draw_path_rectangle:nn
            { - \l_zhvt_frame_sep_dim , \l_zhvt_frame_sep_dim }
            {
              \l_zhvt_text_height_dim + \l_zhvt_frame_sep_dim * 2 ,
              \l_zhvt_text_width_dim  - \l_zhvt_frame_sep_dim * 2
            }
          \draw_path_use_clear:n { stroke }
          \draw_baseline:n { \c_zero_dim }
        \draw_end:
      }
    \__zhvt_offset:N #1
    \__zhvt_pdfsavebox:N #1
  }
\cs_new_protected:Npn \__zhvt_draw_grid_lines:n #1
  {
    \dim_set:Nn \l_tmpa_dim
      { - \l_zhvt_baseline_skip_dim * \int_eval:n {#1} }
    \draw_path_moveto:n { 0 , \l_tmpa_dim }
    \draw_path_lineto:n { \l_zhvt_text_height_dim , \l_tmpa_dim }
  }
%% 设置版心的偏移量，水平方向居中，竖直方向按天头、地脚高度比例设置
\cs_new_protected:Npn \__zhvt_offset:N #1
  {
    \dim_gset:Nn \g__zhvt_total_wd_dim { \box_wd:N #1 }
    \dim_gset:Nn \g__zhvt_total_ht_dim { \box_ht_plus_dp:N #1 }
    \dim_gset:Nn \hoffset
      {
        \fp_to_dim:n
          {
            \dim_to_fp:n { \paperwidth - \g__zhvt_total_wd_dim }
              * \l_zhvt_top_bottom_ratio_fp
              / ( \l_zhvt_top_bottom_ratio_fp + 1 )
          }
      }
    \dim_gset:Nn \voffset
      { ( \paperheight - \g__zhvt_total_ht_dim ) / 2 }
    \dim_gsub:Nn \hoffset { 72.27pt }
    \dim_gsub:Nn \voffset { 72.27pt }
    \dim_gset:Nn \g__zhvt_xshift_dim
      { ( \box_wd:N #1 - \box_wd:N \l_shipout_box ) / 2 }
    \dim_gset:Nn \g__zhvt_yshift_dim
      { \box_dp:N #1 - \box_ht:N \l_shipout_box }
  }
\dim_new:N \g__zhvt_total_ht_dim
\dim_new:N \g__zhvt_total_wd_dim
\dim_new:N \g__zhvt_xshift_dim
\dim_new:N \g__zhvt_yshift_dim

\cs_new_protected:Npn \__zhvt_pdfsavebox:N #1
  {
    \exp_args:NNe \__zhvt_pdfsavebox_aux:Nn
      #1 { @zhvt@obj@ \int_value:w #1 }
  }
\cs_new_protected:Npn \__zhvt_pdfsavebox_aux:Nn #1#2
  {
    \hbox_gset:Nn #1
      {
        \tex_special:D
          {
            pdf: bxobj ~ #2 ~
              width  ~ \dim_eval:n { \box_wd:N #1 } ~
              height ~ \dim_eval:n { \box_ht:N #1 } ~
              depth  ~ \dim_eval:n { \box_dp:N #1 }
          }
        \box_use_drop:N #1
        \tex_special:D { pdf: exobj }
      }
    \box_gset_wd:Nn #1 { \c_zero_dim }
    \box_gset_ht:Nn #1 { \c_zero_dim }
    \box_gset_dp:Nn #1 { \c_zero_dim }
    \box_use_drop:N #1
    \nointerlineskip
    \hbox_gset:Nn #1 { \tex_special:D { pdf: uxobj ~ #2 } }
  }

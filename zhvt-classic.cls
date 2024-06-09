% 本中文直排模板参照清武英殿（又称内府版）《明史》版式编写。
% 依清光绪三十四年颁布营造尺库平制，一尺为公制 32 厘米。
% 书本形制尺寸换算如下：
% 书高九寸：288mm；书宽六寸：192mm；字高三分：9.6mm
% 单面十行，每行二十一字，行距四分五厘：14.4mm
% 外框线宽六厘：1.92mm；内框、界栏线宽一厘：0.32mm
% 内外框间距六厘：1.92mm（净间距）
% 天头地脚比例二比一


\XeTeXuseglyphmetrics=0\relax
\RequirePackage{fix-cm}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{zhvt-classic}
  [Chinese classic Vertical Typesetting]
\ProcessOptions\relax
\LoadClass[oneside,openany]{book}

\RequirePackage[LoadFandol=false]{xeCJK}
\RequirePackage{jiazhu}
\RequirePackage{zhnumber}
\RequirePackage{graphicx}
\RequirePackage{flowfram}
\RequirePackage{hyperref}
\RequirePackage{xparse}
\RequirePackage{l3draw}


\ExplSyntaxOn

%=================================
% 参数定义与设置
%=================================

% 设置选项
%---------------------------------
\keys_define:nn { zhvt } {
  % 正文字体
  main~font           .str_set:N = \l__zhvt_main_font_str,
  main~font           .initial:n = GenRyuMin~TW~SB,
  % 正文字号，三分
  font~size           .dim_set:N = \l__zhvt_font_size_dim,
  font~size           .initial:n = 9.6mm,
  % 行距，即基线间距，四分五厘
  baseline~skip       .dim_set:N = \l__zhvt_baseline_skip_dim,
  baseline~skip       .initial:n = 14.4mm,
  % 夹注字体
  jiazhu~font         .str_set:N = \l__zhvt_jiazhu_font_str,
  jiazhu~font         .initial:n = GenRyuMin~TW~M,
  % 夹注半高，若设置此选项，将忽略 jiazhu font stretch 参数
  jiazhu~half~size   .bool_set:N = \l__zhvt_jiazhu_half_size_bool,
  jiazhu~half~size    .initial:n = false,
  jiazhu~half~size    .default:n = true,
  % 夹注字体宽度缩放
  % jiazhu~font~stretch  .fp_set:N = \l__zhvt_jiazhu_font_stretch_fp,
  % 似乎只能设置为 0.5 方可实现对齐。
  % jiazhu~font~stretch .initial:n = 0.5,
  % 书宽，六寸
  book~width          .dim_set:N = \l__zhvt_book_width_dim,
  book~width          .initial:n = 192mm,
  % 书高，九寸
  book~height         .dim_set:N = \l__zhvt_book_height_dim,
  book~height         .initial:n = 288mm,
  % 单面行数
  page~lines          .int_set:N = \l__zhvt_page_lines_int,
  page~lines          .initial:n = 10,
  % 每行字数
  line~chars          .int_set:N = \l__zhvt_line_chars_int,
  line~chars          .initial:n = 21,
  % 天头地脚比例
  top~bottom~ratio     .fp_set:N = \l__zhvt_top_bottom_ratio_fp,
  top~bottom~ratio    .initial:n = 2,
  % 水平位置微调比例，横排字深 120， 直排字深 500
  % ( 500 - 120 ) / 1000 = 0.38
  adjust~ratio         .fp_set:N = \l__zhvt_adjust_ratio_fp,
  adjust~ratio        .initial:n = 0.38,
  % 界栏线宽度，一厘
  grid~line~width     .dim_set:N = \l__zhvt_grid_line_width_dim,
  grid~line~width     .initial:n = 0.32mm,
  % 外框线宽度，六厘
  frame~line~width    .dim_set:N = \l__zhvt_frame_line_width_dim,
  frame~line~width    .initial:n = 1.92mm,
  % 界栏、外框间距，六厘
  frame~sep           .dim_set:N = \l__zhvt_frame_sep_dim,
  frame~sep           .initial:n = 1.92mm,
  % 界栏颜色
  grid~color          .str_set:N = \l__zhvt_grid_color_str,
  grid~color          .initial:n = red,
  % 小序缩进
  preface~margin     .int_set:N = \l__zhvt_preface_margin_int,
  preface~margin     .initial:n = 2,
  % 章标题缩进
  chapter~indent      .int_set:N = \l__zhvt_chapter_indent_int,
  chapter~indent      .initial:n = 1,
  % 节标题缩进
  section~indent      .int_set:N = \l__zhvt_section_indent_int,
  section~indent      .initial:n = 2,
  % 书口标题字数
  shukou~title~chars  .int_set:N = \l__zhvt_shukou_title_chars_int,
  shukou~title~chars  .initial:n = 6,
  % 书口页码字数
  shukou~page~number~chars .int_set:N = \l__zhvt_shukou_page_number_chars_int,
  shukou~page~number~chars .initial:n = 4,
}

\fp_new:N \l__zhvt_jiazhu_font_stretch_fp
\fp_set:Nn \l__zhvt_jiazhu_font_stretch_fp { 0.5 }

% 其他参数，需由选项参数计算
%---------------------------------
% 水平微调距离
\dim_new:N \l__zhvt_adjust_dim
% 行间距，上行底部到下行顶部的距离
\dim_new:N \l__zhvt_line_sep_dim
% 行距与字高倍数
\fp_new:N \l__zhvt_baseline_skip_ratio_fp
% 单面正文宽度（横排文本高度）
\dim_new:N \l__zhvt_page_text_width_dim
% 筒子叶文本净宽度（横排文本高度）
\dim_new:N \l__zhvt_text_width_dim
% 文本高度（横排文本宽度）
\dim_new:N \l__zhvt_text_height_dim
% 右边距（横排顶部边距）
\dim_new:N \l__zhvt_right_margin_dim
% 顶部边距（横排左侧边距）
\dim_new:N \l__zhvt_top_margin_dim
% 书口标题高度
\dim_new:N \l__zhvt_shukou_title_height_dim
% 书口章节标题高度
\dim_new:N \l__zhvt_shukou_chapter_title_height_dim
% 书口章节标题垂直位置
\dim_new:N \l__zhvt_shukou_chapter_title_start_dim
% 书口页码高度
\dim_new:N \l__zhvt_shukou_page_number_height_dim
% 书口页码垂直位置
\dim_new:N \l__zhvt_shukou_page_number_start_dim
% 标题
\str_new:N \l__zhvt_title_str
% 标题叶标题
\tl_new:N \l__zhvt_title_display_tl
% 标题叶标题尺寸倍数
\fp_new:N \l__zhvt_title_display_ratio_fp
% 作者
\str_new:N \l__zhvt_author_str
% 制作者
\str_new:N \l__zhvt_maker_str



%=================================
% 文档属性计算与设置
%=================================

% 计算长度
\cs_new_protected:Nn \__zhvt_calculate_dimensions: {
  % 行间距，两行内侧净间距：行距 - 字高
  \dim_set:Nn \l__zhvt_line_sep_dim {
    \l__zhvt_baseline_skip_dim - \l__zhvt_font_size_dim
  }
  % 行距倍数
  \fp_set:Nn \l__zhvt_baseline_skip_ratio_fp {
    \l__zhvt_baseline_skip_dim / \l__zhvt_font_size_dim
  }
  % 单面正文宽度：行距 * 行数
  \dim_set:Nn \l__zhvt_page_text_width_dim {
    \l__zhvt_baseline_skip_dim * \l__zhvt_page_lines_int
  }
  % 筒子叶文本净宽度：2 倍单面正文宽度 + 书口宽度 - 行间距
  % 书口宽度等于行距
  % 注意：TeX 文本高度应当设置为：净宽度 + 书口宽度
  \dim_set:Nn \l__zhvt_text_width_dim {
    \l__zhvt_page_text_width_dim * 2 + \l__zhvt_baseline_skip_dim
      - \l__zhvt_line_sep_dim
  }
  % 文本高度：字高 * 每行字数
  \dim_set:Nn \l__zhvt_text_height_dim {
    \l__zhvt_font_size_dim * \l__zhvt_line_chars_int
  }
  % 右边距，即横排上边距：（ 2 倍书宽 - 筒子叶文本净宽度 ） / 2
  \dim_set:Nn \l__zhvt_right_margin_dim {
    ( \l__zhvt_book_width_dim * 2 - \l__zhvt_text_width_dim ) / 2
  }
  % 顶边距（横排左边距）
  \dim_set:Nn \l__zhvt_top_margin_dim {
    \fp_to_dim:n {
      ( \l__zhvt_book_height_dim - \l__zhvt_text_height_dim )
      * \l__zhvt_top_bottom_ratio_fp / ( \l__zhvt_top_bottom_ratio_fp + 1 )
    }
  }
  % 水平位置微调距离，向右为正
  \dim_set:Nn \l__zhvt_adjust_dim {
    \fp_to_dim:n { \l__zhvt_font_size_dim * \l__zhvt_adjust_ratio_fp }
  }
  % 书口标题高度：字高 * 书口标题字数
  \dim_set:Nn \l__zhvt_shukou_title_height_dim {
    \l__zhvt_font_size_dim * \l__zhvt_shukou_title_chars_int
  }
  % 书口页码高度：字高 * 书口页码字数
  \dim_set:Nn \l__zhvt_shukou_page_number_height_dim {
    \l__zhvt_font_size_dim * \l__zhvt_shukou_page_number_chars_int
  }
  % 书口章节标题高度：字高 * （每行字数 - 书口标题字数 - 书口页码字数 - 3）
  % 扣除鱼口部件所占 3 个字符间距
  \dim_set:Nn \l__zhvt_shukou_chapter_title_height_dim {
    \l__zhvt_font_size_dim * (
      \l__zhvt_line_chars_int - \l__zhvt_shukou_title_chars_int
        - \l__zhvt_shukou_page_number_chars_int - 3
    )
  }
  % 书口章节标题垂直位置，上部保留 2 个字高鱼尾空间
  \dim_set:Nn \l__zhvt_shukou_chapter_title_start_dim {
    \l__zhvt_shukou_title_height_dim + \l__zhvt_font_size_dim * 2
  }
  % 书口页码位置：上部留 1 个字高空白
  \dim_set:Nn \l__zhvt_shukou_page_number_start_dim {
    \l__zhvt_shukou_chapter_title_start_dim
      + \l__zhvt_shukou_chapter_title_height_dim
  }
}

% 设置正文字体
\cs_new_protected:Nn \__zhvt_set_main_font: {
  % 字体直排旋转
  \defaultCJKfontfeatures { RawFeature= { vertical:+vert:+vhal } }
  % 正文字体
  \setCJKmainfont { \l__zhvt_main_font_str }
  \xeCJKDeclareSubCJKBlock { MARK } { "2588 }
}
\cs_new_protected:Nn \__zhvt_vphantom: { \vphantom { \symbol { "2588 } } }

% 设置夹注选项
\cs_new_protected:Nn \__zhvt_set_jiazhu_option: {
  \bool_if:NTF \l__zhvt_jiazhu_half_size_bool
    { % 半高夹注
      %---------------------------------
      % 半高夹注 Hack
      % 当半高夹注高度为夹注字体高度的奇数倍时，在夹注后面添加
      % 一个夹注字体的高度
      \cs_set_protected:Npn \__jiazhu_processing:
        {
            \__jiazhu_split_lines:
            \__jiazhu_put_closing_box:
            \__jiazhu_good_break:
            \__jiazhu_hskip:N \l__jiazhu_after_skip_tl
            %\__zhvt_vphantom:
            \int_set:Nn \l_tmpa_int {
              \dim_ratio:nn
                { \l__jiazhu_max_dim } { \l__jiazhu_unit_dim }
            }
            \int_if_odd:nT \l_tmpa_int {
              \skip_horizontal:n { \l__jiazhu_unit_dim }
            }
          \group_end:
          \tex_ignorespaces:D
        }
      %---------------------------------
      \newCJKfontfamily { \jiazhufont } { \l__zhvt_jiazhu_font_str }
      % 夹注行距比例 linespread，与正文行距比例相同
      \fp_set:Nn \l_tmpa_fp {
        ( \l__zhvt_baseline_skip_dim - \l__zhvt_grid_line_width_dim )
          / \l__zhvt_font_size_dim
      }
      % 夹注字号比例 ratio，正文字号一半
      \fp_set:Nn \l_tmpb_fp { 0.5 }
    }
    { % 全高夹注，相当于缩小字号，垂直拉伸至正文字体等高。
      % 字体设置时的缩放比例是宽度缩放比例参数的倒数
      \newCJKfontfamily { \jiazhufont } { \l__zhvt_jiazhu_font_str }
        [ FakeStretch = \fp_eval:n { 1 / \l__zhvt_jiazhu_font_stretch_fp } ]
      % 夹注行距比例 linespread
      \fp_set:Nn \l_tmpa_fp {
        ( \l__zhvt_baseline_skip_dim - \l__zhvt_grid_line_width_dim )
          / 2 / \l__zhvt_font_size_dim / \l__zhvt_jiazhu_font_stretch_fp
%        0.5 * \l__zhvt_baseline_skip_ratio_fp / \l__zhvt_jiazhu_font_stretch_fp * 0.95
      }
      % 字号比例，为宽度缩放比例参数
      \fp_set_eq:NN \l_tmpb_fp \l__zhvt_jiazhu_font_stretch_fp
    }
  % 夹注参数
  \jiazhuset {
    format = \linespread { \fp_use:N \l_tmpa_fp } \jiazhufont,
    ratio = \l_tmpb_fp,
    beforeskip = 0pt plus 0.0001em, % \c_zero_dim,
    afterskip = 0pt plus 0.0001em, % 避免夹注后正文单字无法换行
    % 夹注快捷符号
    shortcut=【】
  }
}

% 设置页面布局尺寸
\cs_new_protected:Nn \__zhvt_set_layout_size: {
  \dim_set_eq:NN \headheight \c_zero_dim
  \dim_set_eq:NN \headsep \c_zero_dim
  \dim_set_eq:NN \footskip \c_zero_dim
  \dim_set_eq:NN \marginparwidth \c_zero_dim
  \dim_set_eq:NN \marginparsep \c_zero_dim
  \dim_set_eq:NN \marginparpush \c_zero_dim
  \dim_set_eq:NN \paperwidth \l__zhvt_book_height_dim
  \dim_set:Nn \paperheight { \l__zhvt_book_width_dim * 2}
  \dim_set:Nn \textwidth {\l__zhvt_text_height_dim + 0.5em}
  \dim_set:Nn \textheight { \l__zhvt_text_width_dim + \l__zhvt_line_sep_dim }
  \dim_set_eq:NN \voffset \l__zhvt_right_margin_dim
  \dim_set_eq:NN \hoffset \l__zhvt_top_margin_dim
  \dim_set:Nn \topmargin { - \l__zhvt_adjust_dim - 1in }
  \dim_set:Nn \oddsidemargin { - 1in }
  \dim_set:Nn \evensidemargin \oddsidemargin
}


%=================================
% 页面布局
%=================================

% 设置页面布局
\cs_new_protected:Nn \__zhvt_set_layout: {
  % 高度（横排宽度），宽度（横排高度）
  % 距顶部位置（横排距左侧位置），左侧位置（横排距底部高度）
  % 盒子标签
  % 正面
  \newflowframe
    { \l__zhvt_text_height_dim }
    { \l__zhvt_page_text_width_dim }
    { \c_zero_dim }
    {
      \dim_eval:n
        { \l__zhvt_baseline_skip_dim * ( \l__zhvt_page_lines_int + 1 ) }
    }
    [ front ]
  % 反面
  \newflowframe
    { \l__zhvt_text_height_dim }
    { \l__zhvt_page_text_width_dim }
    { \c_zero_dim }
    { \c_zero_dim }
    [ back ]
  % 书口标题
  \newstaticframe
    { \l__zhvt_shukou_title_height_dim }
    { \l__zhvt_baseline_skip_dim }
    { \c_zero_dim }
    { \l__zhvt_page_text_width_dim }
    [ title ]
  % 书口标题
  \newdynamicframe
    { \l__zhvt_shukou_chapter_title_height_dim }
    { \l__zhvt_baseline_skip_dim }
    { \l__zhvt_shukou_chapter_title_start_dim }
    { \l__zhvt_page_text_width_dim }
    [ chapter ]
  % 书口页码
  \newdynamicframe
    { \l__zhvt_shukou_page_number_height_dim }
    { \l__zhvt_baseline_skip_dim }
    { \l__zhvt_shukou_page_number_start_dim }
    { \l__zhvt_page_text_width_dim }
    [ page~number ]
  \setallstaticframes { valign = t }
  \setalldynamicframes { valign = t }
}
% 设置书口内容
% 书口章标题
\tl_new:N \l__zhvt_chapter_title_tl
\cs_new_protected:Nn \__zhvt_set_shukou_content: {
  \setstaticcontents * { title }{ \l__zhvt_title_str }
  \setdynamiccontents * { chapter }{ \quad\l__zhvt_chapter_title_tl }
  \setdynamiccontents * { page~number }{ \quad \zhnum { page } }
}

% 标题叶
% 参数：正面界栏，反面界栏
\cs_new_protected:Nn \__zhvt_make_title_page: {
    \nointerlineskip
    % 作者
    \hbox_set:Nn \l_tmpa_box {
      \box_move_down:nn
        { \l__zhvt_font_size_dim + \l__zhvt_line_sep_dim / 2 }
        {
          \hbox_to_wd:nn { \l__zhvt_text_height_dim - \l__zhvt_font_size_dim }
            {
              \skip_horizontal:n { \l__zhvt_font_size_dim }
              \__zhvt_vphantom: \l__zhvt_author_str \hss
            }
        }
    }
    \box_use_drop:N \l_tmpa_box
    % 对齐空白
    \vfill
    % 标题
    \dim_set:Nn \l_tmpa_dim {
      \fp_to_dim:n
        { \l__zhvt_font_size_dim * \l__zhvt_title_display_ratio_fp }
    }
    \dim_set:Nn \l_tmpb_dim {
       \l_tmpa_dim - \l__zhvt_line_sep_dim * 3 / 2
         - \l__zhvt_adjust_dim
    }
    \hbox_set:Nn \l_tmpa_box {
      \box_move_up:nn { \l_tmpb_dim }
        {
          \hbox_to_wd:nn { \l__zhvt_text_height_dim } {
            \fontsize { \l_tmpa_dim } { \c_zero_skip }
            \selectfont
            \hss \__zhvt_vphantom: \l__zhvt_title_display_tl \hss
        }
      }
    }
    \box_use_drop:N \l_tmpa_box
    % 对齐空白
    \vfill
    % 制作者
    \hbox_set:Nn \l_tmpa_box {
      \box_move_up:nn { \l__zhvt_font_size_dim + \l__zhvt_adjust_dim }
      {
        \hbox_to_wd:nn { \l__zhvt_text_height_dim }
          {
            \hss
            \__zhvt_vphantom: \l__zhvt_maker_str
            \skip_horizontal:n { \l__zhvt_font_size_dim }
          }
      }
    }
    \box_use_drop:N \l_tmpa_box
    \clearpage
    \gridall
}

% ================================
% 绘制框线
% ================================

% 内框
% --------------------------------
% 顶部偏移
\dim_new:N \l__zhvt_grid_top_offset_dim
% 右侧偏移
\dim_new:N \l__zhvt_grid_right_offset_dim
% 外框高度
\dim_new:N \l__zhvt_grid_height_dim
% 外框宽度
\dim_new:N \l__zhvt_grid_width_dim
% 鱼尾顶部偏移
\dim_new:N \l__zhvt_yuwei_top_offset_dim
% 鱼尾右侧偏移
\dim_new:N \l__zhvt_yuwei_right_offset_dim
% 鱼尾下分割线垂直方向间距
\dim_new:N \l__zhvt_yuwei_lower_line_sep_dim
% 计算内框相关长度
\cs_new_protected:Nn \__zhvt_calculate_grid_dimensions: {
  % 向上为负
  \dim_set:Nn \l__zhvt_grid_top_offset_dim {
    - \l__zhvt_line_sep_dim / 2 - \l__zhvt_grid_line_width_dim / 2
  }
  % 向左为负
  \dim_set:Nn \l__zhvt_grid_right_offset_dim {
    - \l__zhvt_text_width_dim + \l__zhvt_grid_top_offset_dim
  }
  \dim_set:Nn \l__zhvt_grid_height_dim {
    \l__zhvt_text_height_dim + \l__zhvt_line_sep_dim
  }
  \dim_set:Nn \l__zhvt_grid_width_dim {
    \l__zhvt_text_width_dim + \l__zhvt_line_sep_dim
  }
  \dim_set:Nn \l__zhvt_yuwei_top_offset_dim {
    \l__zhvt_shukou_title_height_dim + \l__zhvt_line_sep_dim / 2
      - \l__zhvt_grid_line_width_dim / 2
  }
  \dim_set:Nn \l__zhvt_yuwei_right_offset_dim {
    - \l__zhvt_baseline_skip_dim * ( \l__zhvt_page_lines_int + 1 )
      + \l__zhvt_line_sep_dim / 2 - \l__zhvt_grid_line_width_dim / 2
  }
  \dim_set:Nn \l__zhvt_yuwei_lower_line_sep_dim {
    \fp_to_dim:n {
      \l__zhvt_line_sep_dim / 2
        * sqrt ( 1 + \l__zhvt_baseline_skip_ratio_fp ^ 2 )
        / \l__zhvt_baseline_skip_ratio_fp
    }
  }
}
% 绘制内框、书口侧栏、鱼尾
\cs_new_protected:Nn \__zhvt_draw_grid: {
  % 内框
  \put ( \l__zhvt_grid_top_offset_dim, \l__zhvt_grid_right_offset_dim )
    {
      \draw_begin:
        \exp_args:Ne \color_stroke:n { \l__zhvt_grid_color_str }
        \exp_args:Ne \color_fill:n { \l__zhvt_grid_color_str }
        \draw_linewidth:n { \l__zhvt_grid_line_width_dim }
        % 内框
        \draw_path_rectangle:nn
          { 0 , 0 }
          { \l__zhvt_grid_height_dim , \l__zhvt_grid_width_dim }
        % 书口侧栏
        % 左侧栏
        \draw_path_moveto:n
          { 0 , \l__zhvt_page_text_width_dim}
        \draw_path_lineto:n
          { \l__zhvt_grid_height_dim , \l__zhvt_page_text_width_dim }
        % 右侧栏
        \draw_path_moveto:n
          { 0 , \l__zhvt_page_text_width_dim + \l__zhvt_baseline_skip_dim }
        \draw_path_lineto:n
          {
            \l__zhvt_grid_height_dim ,
            \l__zhvt_page_text_width_dim + \l__zhvt_baseline_skip_dim
          }
        \draw_path_use_clear:n { stroke }
      \draw_end:
    }
  % 鱼尾
  \put ( \l__zhvt_yuwei_top_offset_dim, \l__zhvt_yuwei_right_offset_dim )
    {
      \draw_begin:
        \exp_args:Ne \color_stroke:n { \l__zhvt_grid_color_str }
        \exp_args:Ne \color_fill:n { \l__zhvt_grid_color_str }
        \draw_linewidth:n { \l__zhvt_grid_line_width_dim }
        % 鱼尾上分割线
        \draw_path_moveto:n
          { 0 , 0 }
        \draw_path_lineto:n
          { 0 , \l__zhvt_baseline_skip_dim }
        \draw_path_use_clear:n { stroke }
        % 鱼尾
        \draw_transform_shift:n { \l__zhvt_line_sep_dim / 2 , 0}
        \draw_path_moveto:n
          { 0 , 0 }
        \draw_path_lineto:n
          { 0 , \l__zhvt_baseline_skip_dim }
        \draw_path_lineto:n
          { \l__zhvt_font_size_dim , \l__zhvt_baseline_skip_dim }
        \draw_path_lineto:n
          { \l__zhvt_font_size_dim / 2 , \l__zhvt_baseline_skip_dim / 2 }
        \draw_path_lineto:n
          { \l__zhvt_font_size_dim , 0 }
        \draw_path_close:
        \draw_path_use_clear:n { fill , stroke }
        % 鱼尾下分割线
        \draw_transform_shift:n
          { \l__zhvt_font_size_dim + \l__zhvt_yuwei_lower_line_sep_dim , 0}
        \draw_path_moveto:n
          { 0 , 0 }
        \draw_path_lineto:n
          { - \l__zhvt_font_size_dim / 2 , \l__zhvt_baseline_skip_dim / 2 }
        \draw_path_lineto:n
          { 0 , \l__zhvt_baseline_skip_dim }
        \draw_path_use_clear:n { stroke }
      \draw_end:
    }
    % 页码分割线
  \put
    (
      \l__zhvt_shukou_page_number_start_dim
        - \l__zhvt_line_sep_dim / 2 - \l__zhvt_grid_line_width_dim / 2,
      \l__zhvt_yuwei_right_offset_dim
    )
    {
      \draw_begin:
        \exp_args:Ne \color_stroke:n { \l__zhvt_grid_color_str }
        \draw_linewidth:n { \l__zhvt_grid_line_width_dim }
        \draw_path_moveto:n
          { 0 , 0 }
        \draw_path_lineto:n
          { 0 , \l__zhvt_baseline_skip_dim }
        \draw_path_use_clear:n { stroke }
      \draw_end:
    }
}

% 外框
% --------------------------------
% 顶部偏移
\dim_new:N \l__zhvt_frame_top_offset_dim
% 右侧偏移
\dim_new:N \l__zhvt_frame_right_offset_dim
% 外框高度
\dim_new:N \l__zhvt_frame_height_dim
% 外框宽度
\dim_new:N \l__zhvt_frame_width_dim
% 计算外框相关长度
\cs_new_protected:Nn \__zhvt_calculate_frame_dimensions: {
  \dim_set:Nn \l__zhvt_frame_top_offset_dim {
    \l__zhvt_grid_top_offset_dim - \l__zhvt_frame_sep_dim
      - \l__zhvt_frame_line_width_dim
  }
  \dim_set:Nn \l__zhvt_frame_right_offset_dim {
    \l__zhvt_grid_right_offset_dim - \l__zhvt_frame_sep_dim
      - \l__zhvt_frame_line_width_dim
  }
  \dim_set:Nn \l__zhvt_frame_height_dim {
    \l__zhvt_grid_height_dim + \l__zhvt_frame_sep_dim * 2
      + \l__zhvt_frame_line_width_dim + \l__zhvt_grid_line_width_dim
  }
  \dim_set:Nn \l__zhvt_frame_width_dim {
    \l__zhvt_grid_width_dim + \l__zhvt_frame_sep_dim * 2
      + \l__zhvt_frame_line_width_dim + \l__zhvt_grid_line_width_dim
  }
}
% 绘制外框
\cs_new_protected:Nn \__zhvt_draw_frame: {
  \put ( \l__zhvt_frame_top_offset_dim, \l__zhvt_frame_right_offset_dim )
    {
      \draw_begin:
        \exp_args:Ne \color_stroke:n { \l__zhvt_grid_color_str }
        \draw_linewidth:n { \l__zhvt_frame_line_width_dim }
        \draw_path_rectangle:nn
          { 0 , 0 }
          { \l__zhvt_frame_height_dim , \l__zhvt_frame_width_dim }
        \draw_path_use_clear:n { stroke }
      \draw_end:
    }
}
% 绘制单面界栏
\cs_new_protected:Npn \__zhvt_draw_page_grid_lines:N #1 {
  \clist_if_empty:NF #1 {
    \draw_begin:
      \exp_args:Ne \color_stroke:n { \l__zhvt_grid_color_str }
      \draw_linewidth:n { \l__zhvt_grid_line_width_dim }
      \clist_map_inline:Nn #1
        {
          \dim_set:Nn \l_tmpa_dim {
            \l__zhvt_baseline_skip_dim * ( \l__zhvt_page_lines_int - ##1 )
          }
          \draw_path_moveto:n
            { 0 , \l_tmpa_dim }
          \draw_path_lineto:n
            { \l__zhvt_grid_height_dim, \l_tmpa_dim }
        }
      \draw_path_use_clear:n { stroke }
      % 丑陋
      \draw_path_moveto:n { 0 , 0 }
  %    \draw_path_lineto:n { 0 , 0 }
    \draw_end:
  }
}
% 绘制界栏
% 设置界栏位置
\clist_new:N \l__zhvt_all_grid_steps_clist
\clist_new:N \l__zhvt_front_grid_steps_clist
\clist_new:N \l__zhvt_back_grid_steps_clist
% 全部界栏
\int_step_inline:nnn { 1 } { \l__zhvt_page_lines_int } {
  \clist_put_right:Nn \l__zhvt_all_grid_steps_clist { #1 }
}
% 设置单页界栏
% #1： all - 全部界栏，none - 无界栏，其他定制界栏 ：
\cs_new_protected:Npn \__zhvt_set_page_grid_steps:Nn #1#2 {
  \str_compare:nNnTF { #2 } = { all }
    { \clist_set_eq:NN #1 \l__zhvt_all_grid_steps_clist }
    {
      \str_compare:nNnTF { #2 } = { none }
        { \clist_clear:N #1 }
        {
          \clist_if_empty:nF { #2 }
            { \clist_set:Nn #1 { #2 } }
        }
    }
%  TeXLive 2024
%  \bool_case:n {
%    { \str_compare_p:nNn { #2 } = { all } }
%      { \clist_set_eq:NN #1 \l__zhvt_all_grid_steps_clist }
%    { \str_compare_p:nNn { #2 } = { none } }
%      { \clist_clear:N #1 }
%    { ! \clist_if_empty_p:n { #2 } }
%      { \clist_set:Nn #1 { #2 } }
%  }
}
% 设置筒子叶所有界栏
\cs_new_protected:Npn \__zhvt_set_grid_steps:nn #1#2 {
  \__zhvt_set_page_grid_steps:Nn \l__zhvt_front_grid_steps_clist { #1 }
  \__zhvt_set_page_grid_steps:Nn \l__zhvt_back_grid_steps_clist { #2 }
}
% 绘制界栏
\cs_new_protected:Nn \__zhvt_draw_grid_lines: {
  % 右侧界栏
  \put
    (
      \l__zhvt_grid_top_offset_dim ,
      \l__zhvt_grid_right_offset_dim + \l__zhvt_page_text_width_dim
        + \l__zhvt_baseline_skip_dim
    )
    { \__zhvt_draw_page_grid_lines:N \l__zhvt_front_grid_steps_clist }
  % 左侧界栏
  \put ( \l__zhvt_grid_top_offset_dim , \l__zhvt_grid_right_offset_dim )
    { \__zhvt_draw_page_grid_lines:N \l__zhvt_back_grid_steps_clist }
}


%=================================
% 文档构建的相关钩子
%=================================

% 设置钩子顺序，避免冲突
\hook_gset_rule:nnnn { begindocument / before }
  { zhvt } { before } { xeCJK }
% 导言尾部
\hook_gput_code:nnn { begindocument / before } { zhvt } {
  \__zhvt_calculate_dimensions:
  \__zhvt_calculate_grid_dimensions:
  \__zhvt_calculate_frame_dimensions:
  \__zhvt_set_layout_size:
  \__zhvt_set_layout:
  \__zhvt_set_main_font:
  \__zhvt_set_jiazhu_option:
  \dim_set:Nn \parindent { \c_zero_dim }
  \pagestyle { empty }
}
% 设置字体、标题盒子
%\bool_new:N \l__zhvt_make_title_bool
%\bool_set_false:N \l__zhvt_make_title_bool
\hook_gput_code:nnn { begindocument } { zhvt } {
  \fontsize { \l__zhvt_font_size_dim } { \l__zhvt_baseline_skip_dim }
  \selectfont
  \__zhvt_set_shukou_content:
  \__zhvt_set_grid_steps:nn { all } { all }
}

\hook_gput_code:nnn { shipout / foreground } { zhvt } {
  \__zhvt_draw_grid:
  \__zhvt_draw_frame:
  \__zhvt_draw_grid_lines:
}

\hook_gput_code:nnn { shipout / firstpage } { zhvt }
  { \special { pdf: ~ put ~ @pages <</Rotate ~ 90>> } }

%=================================
% 用户接口
%=================================

% 设置选项
\NewDocumentCommand { \zhvtset } { }
{ \keys_set:nn { zhvt } }

% 设置标题
\DeclareDocumentCommand { \title } { m o O { 3 } } {
  % 标题
  \str_set:Nn \l__zhvt_title_str { #1 }
  % 标题叶标题
  \IfNoValueTF{ #2 }
    { \tl_set:Nn \l__zhvt_title_display_tl { #1 } }
    { \tl_set:Nn \l__zhvt_title_display_tl { #2 } }
  % 标题叶标题尺寸倍数
  \fp_set:Nn \l__zhvt_title_display_ratio_fp { #3 }
}
% 设置作者
\DeclareDocumentCommand { \author } { m } {
  \str_set:Nn \l__zhvt_author_str { #1 }
}
% 设置制作者
\NewDocumentCommand { \maker } { m } {
  \str_set:Nn \l__zhvt_maker_str { #1 }
}

\DeclareDocumentCommand{ \maketitle }
  { O { 2, \int_eval:n { \l__zhvt_page_lines_int - 2} } O { none } }
  {
    %\bool_set_true:N \l__zhvt_make_title_bool
    \grid { #1 } { #2 }
    \__zhvt_make_title_page:
    \clearpage
    \gridall
  }

% 重定义目录
\RenewDocumentCommand \tableofcontents { }
  {
    \clearpage
%    \skip_horizontal:n
%      { \l__zhvt_font_size_dim * \l__zhvt_chapter_indent_int }
    目錄
    \@starttoc { toc }
    \clearpage
  }

% 重定义章、节
% 参数： 是否不编号；书口标题；标题；夹注
\RenewDocumentCommand \chapter { s o m o } {%
    \clearpage
    \tl_set:Nn \l_tmpa_tl { #3 }
    \IfValueTF { #2 }
      { \tl_set:Nn \l__zhvt_chapter_title_tl { #2 } }
      { \tl_set_eq:NN \l__zhvt_chapter_title_tl \l_tmpa_tl }
    \IfBooleanF { #1 }
      {
        \refstepcounter { chapter }
        \tl_put_right:Nn \l_tmpa_tl { 第\zhnum { chapter } }
        \tl_if_blank:nTF { #2 } { }
          {
            \tl_put_right:Nn \l__zhvt_chapter_title_tl
              { 第\zhnum { chapter } }
          }
      }
    \tl_set:Nn \l_tmpb_tl {%
        \par \hspace { \int_use:N \l__zhvt_chapter_indent_int em}
        \l_tmpa_tl
    }%
    \addtocontents { toc } { \l_tmpb_tl }%
    \skip_horizontal:n
      { \l__zhvt_font_size_dim * \l__zhvt_chapter_indent_int }
    \l_tmpa_tl
    \IfNoValueF { #4 } { \jiazhu { #4 } }
    \par
}
\RenewDocumentCommand { \section } { m o } {
    \refstepcounter { section }
    \tl_set:Nn \l_tmpa_tl {
        \par\hspace{\int_use:N \l__zhvt_section_indent_int em} #1
    }
    \addtocontents{toc}{\l_tmpa_tl}
    \skip_horizontal:n
      { \l__zhvt_font_size_dim * \l__zhvt_section_indent_int }
    #1
    \IfNoValueF{#2}{\jiazhu{#2}}
    \par
}

% 图像
\NewDocumentCommand \insertgraphic { O { } m }
  {
    \vbox_to_ht:nn { \l__zhvt_page_text_width_dim }
    {
      \vss
      \hbox_to_wd:nn { \l__zhvt_text_height_dim }
        { \hss \includegraphics [#1] {#2} \hss }
      \vss
    }
  }

% 小序环境
\NewDocumentEnvironment { preface } { O { \l__zhvt_preface_margin_int } }
  {%
    \begin { list } { }
      {
        \dim_set_eq:NN \topsep \c_zero_dim
        \dim_set_eq:NN \parskip \c_zero_dim
        \dim_set_eq:NN \parsep \c_zero_dim
        \dim_set_eq:NN \partopsep \c_zero_dim
        \dim_set:Nn \leftmargin { \int_use:N #1 em }
    } \item [ ]
  }
  { \end { list } }

\NewDocumentCommand{ \pf } { m } {
  \begin{preface}
  #1
  \end{preface}
}

% 句
\NewDocumentCommand{\ju}{}{
  \hbox_overlap_left:n {
    \draw_begin:
    \draw_path_moveto:n { 0 , 0 }
    \draw_linewidth:n { 0.03em}
    \draw_path_circle:nn { 0em , 0.5em } { 0.12em }
    \draw_path_use_clear:n { stroke }
    \draw_end:
  }
  \CJKglue
}

% 读
\NewDocumentCommand { \dou } { } {
  \hbox_overlap_left:n {
    \draw_begin:
      \draw_path_moveto:n { 0 , 0 }
      \draw_transform_shift:n { 0 , 0.4em }
      \draw_transform_rotate:n { 90 }
      \draw_transform_scale:n {
        0.25 * \dim_ratio:nn { \l__zhvt_font_size_dim } { 10pt }
      }
      \draw_path_moveto:n { 8.16 , 0}
      \draw_path_curveto:nnn
        {7.34 , 0 } {6.66 , 0.6 } { 6.12 , 1.8 }
      \draw_path_curveto:nnn
        {4.76 , 4.6 } { 2.72 , 7.13 }{ 0, 9.4 }
      \draw_path_lineto:n { 0.4 , 10 }
      \draw_path_curveto:nnn
        { 4.88 , 8.69 } { 7.83 , 6.88 } { 9.24 , 4.56}
      \draw_path_curveto:nnn
        { 9.86 , 3.6 } { 10 , 2.61 } { 9.96 , 1.6 }
      \draw_path_curveto:nnn
        { 9.75 , 0.53 } { 9.15 , 0 } { 8.16 , 0 }
      \draw_path_close:
      \draw_path_use_clear:n { fill }
    \draw_end:
  }\CJKglue
}

% 句读快捷方式
\char_set_catcode_active:N 。
\char_set_catcode_active:N 、
\char_set_active_eq:NN 。\ju
\char_set_active_eq:NN 、\dou

% 界栏设置
\NewDocumentCommand { \gridall } { } {
  \__zhvt_set_grid_steps:nn { all } { all }
}

\NewDocumentCommand { \gridnone } { } {
  \__zhvt_set_grid_steps:nn { none } { none }
}

\NewDocumentCommand { \grid } { m m } {
  \__zhvt_set_grid_steps:nn { #1 } { #2 }
}

\NewDocumentCommand{ \zhvph } { } { \__zhvt_vphantom: }

\ExplSyntaxOff

from pathlib import Path
import tempfile
import fitz


def splice_pages(pdf_file):
    temp_pdf = tempfile.TemporaryFile()
    pdf_file = Path(pdf_file)
    dest_file = f'{pdf_file.parent / pdf_file.stem}-拼版.pdf'

    # 取消源文件页面旋转
    with fitz.open(pdf_file) as pdf:
        for page in pdf:
            page.set_rotation(0)
        pdf.save(temp_pdf)

    # 拼接页面
    with fitz.open() as dest_pdf, fitz.open(temp_pdf) as pdf:
        for i in range(pdf.page_count // 2):
            _, _, width, height = pdf[i].rect
            page = dest_pdf.new_page(width=width, height=height * 2)
            left_rect = fitz.Rect(0, 0, width, height)
            right_rect = fitz.Rect(0, height, width, height * 2)
            page.show_pdf_page(left_rect, pdf, i * 2)
            page.show_pdf_page(right_rect, pdf, i * 2 + 1)
            # 输出页面旋转 90°
            page.set_rotation(90)
        dest_pdf.save(dest_file)
    temp_pdf.close()
    print(f'输出 PDF: {dest_file}')


if __name__ == '__main__':
    import sys
    splice_pages(sys.argv[1])

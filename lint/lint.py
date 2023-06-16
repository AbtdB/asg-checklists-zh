import sys
import os.path
import logging
import xml.etree.ElementTree as ET
from PIL import ImageFont

target_filepath = os.path.abspath(sys.argv[1])
curdir = os.path.dirname(os.path.abspath(__file__))
namespace = {
    'xlf': 'urn:oasis:names:tc:xliff:document:1.2',
    'its': 'http://www.w3.org/2005/11/its',
}

logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("lint.log", mode='w'),
        logging.StreamHandler()
    ]
)

tree = ET.parse(target_filepath)
root = tree.getroot()

# 检查并修正 Note 每行长度
# 为保证精度，字号选择 100，长度上限相应为 2193
line_len_max = 2193
line_break = '|'
bol_blacklist = [
    '。', '.',
    '？', '?',
    '！', '!',
    '，', ',',
    '、',
    '；', ';',
    '：', ':',
]
font = ImageFont.truetype(
    os.path.join(curdir, 'calibri-yahei-seguisym.ttf'),
    100
)
for note in root.findall('.//xlf:trans-unit[@its:locNote="Note"]/xlf:target', namespace):
    ok = True
    linted = []
    bol = 0
    for ch in note.text:
        linted.append(ch)
        if ch == line_break:
            bol = len(linted)
            continue
        line_len = font.getlength(''.join(linted[bol:]))
        if line_len > line_len_max:
            ok = False
            new_bol = len(linted) - 1
            while linted[new_bol] in bol_blacklist:
                new_bol -= 1
                assert new_bol > bol
            linted.insert(new_bol, line_break)
            bol = new_bol + 1
    if not ok:
        linted_text = ''.join(linted)
        logging.info(f'添加折行\n{note.text}\n↓\n{linted_text}')
        note.text = linted_text

tree.write(target_filepath, encoding='utf-8')

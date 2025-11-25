import sys
import re

def reg(x):
    assert x[0]=='x'
    return int(x[1:])

def parse_line(line):
    line=line.split('#')[0].strip()
    if not line: return None
    parts = re.split(r'[\s,()]+', line)
    parts = [p for p in parts if p!='']
    return parts

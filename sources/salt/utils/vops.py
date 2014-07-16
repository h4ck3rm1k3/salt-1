# VisualOps salt Utils
# @author: Thibault BRONCHAIN
# (c) 2014 - MadeiraCloud

# Defines
PRINT_NOT=["stream"]

def string_to_print(s, level, acc):
    return acc+("  "*level)+s.encode('ascii','ignore').strip()+"\n"

def list_to_print(l, level, acc):
    for item in l:
        acc += obj_to_print(item,level+1)
    return acc

def dict_to_print(d, level, acc):
    for key in d:
        if key not in PRINT_NOT:
            acc += string_to_print("%s:\n"%key,level)
        acc += obj_to_print(d[key],level+1)
    return acc

def obj_to_print(o, level=0, acc=""):
    if type(o) is dict:
        acc += dict_to_print(o,level,acc)
    elif type(o) is list:
        acc += list_to_print(o,level,acc)
    else:
        acc += string_to_print(("%s"%o),level,acc)
    return acc

def stream_to_print(s):
    ls = []
    if s and s.startswith('{') and s.endswith('}'):
        delim = 0
        buf = ''
        for char in s:
            buf += char
            if char == '{':
                delim += 1
            if char == '}':
                delim -= 1
            if delim == 0:
                try:
                    buf = json.loads(buf)
                except Exception:
                    pass
                ls.append(buf)
                buf = ''
    return obj_to_print(ls)

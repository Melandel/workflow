import os.path
import uuid
import textwrap
from datetime import datetime

def today():
 return datetime.today().strftime('%Y-%m-%d')

def rnd():
 return str(uuid.uuid4())

def path_to_namespace(path):
 return os.path.dirname(path).replace('src\\', '').replace('\\', '.')

def basename_to_classname(basename):
 return basename.replace('Archetypes', 'Archetype').replace('TestDoubles', 'TestDouble').replace('Extension', '').replace('Methods', '').replace('.', '')

def pascal_case(value):
 return "".join(value.title().split())

def newline_if_content(visual_text, placeholder):
 if visual_text != "":
  return "\n"
 elif placeholder == "":
  return ""
 else:
  return "\n"

def space_or_newline_depending_on_content(visual_text, placeholder):
 if visual_text != "":
  return "" if visual_text.endswith("\n") else "\n"
 elif placeholder == "":
  return " "
 else:
  return "\n"

def add_indent(text, indent="\t", nb=1):
 return textwrap.indent(text, nb*indent)


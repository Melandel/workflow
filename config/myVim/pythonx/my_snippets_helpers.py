import os.path
import uuid

def rnd():
 return str(uuid.uuid4())

def path_to_namespace(path):
 return os.path.dirname(path).replace('src\\', '').replace('\\', '.')


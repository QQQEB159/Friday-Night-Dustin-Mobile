import sys
import os

# Set your directory path here
directory = sys.path[0]

# Loop through all files in the directory
for a in os.listdir(sys.path[0]):
    if a.endswith('.xml'):
        path = os.path.join(sys.path[0], a)
        
        with open(path, 'r', encoding='utf-8') as file:
            yea = file.read()

        newyea = yea
        for z in (' x="0"', ' y="0"', ' loop="false"', ' fps="24"', '\n', '	', '	', ' isGF="false"', ' icon="' + a.replace('.xml', '') + '"', ' sprite="' + a.replace('.xml', '') + '"'):
            newyea = newyea.replace(z, '')
        
        if newyea != yea:
            with open(path, 'w', encoding='utf-8') as file:
                file.write(newyea)

            print(f'Compressed: {a}')
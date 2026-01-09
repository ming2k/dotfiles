import os

for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".qml"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
                if "Colors" in content:
                    print(f"Found 'Colors' in {path}")
                    # print snippet
                    lines = content.splitlines()
                    for i, line in enumerate(lines):
                        if "Colors" in line:
                            print(f"  Line {i+1}: {line.strip()}")

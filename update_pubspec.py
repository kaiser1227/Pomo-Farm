with open("pubspec.yaml", "r") as f:
    lines = f.readlines()

out = []
for line in lines:
    if line.strip() == "# fonts:":
        out.append("  assets:\n    - assets/images/\n")
    out.append(line)

with open("pubspec.yaml", "w") as f:
    f.writelines(out)

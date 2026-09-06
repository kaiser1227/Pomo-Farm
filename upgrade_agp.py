import os
import re

# 1. Update gradle-wrapper.properties
wrapper_path = "android/gradle/wrapper/gradle-wrapper.properties"
with open(wrapper_path, "r") as f:
    content = f.read()
content = re.sub(r'gradle-.*-all\.zip', 'gradle-8.4-all.zip', content)
with open(wrapper_path, "w") as f:
    f.write(content)

# 2. Update android/build.gradle
build_ext_path = "android/build.gradle"
with open(build_ext_path, "r") as f:
    content = f.read()
content = re.sub(r'classpath\s+[\'"]com\.android\.tools\.build:gradle:.*[\'"]', "classpath 'com.android.tools.build:gradle:8.3.2'", content)
with open(build_ext_path, "w") as f:
    f.write(content)

# 3. Update android/app/build.gradle
app_build_path = "android/app/build.gradle"
with open(app_build_path, "r") as f:
    content = f.read()

content = content.replace("JavaVersion.VERSION_1_8", "JavaVersion.VERSION_17")
content = content.replace("jvmTarget = '1.8'", "jvmTarget = '17'")

if "namespace " not in content:
    content = content.replace("android {\n", "android {\n    namespace \"com.barolabs.pomofarm\"\n")

with open(app_build_path, "w") as f:
    f.write(content)

print("Upgrade complete.")

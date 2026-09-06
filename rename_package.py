import os
import shutil

# 1. Update file contents
files_to_update = [
    "android/app/src/debug/AndroidManifest.xml",
    "android/app/src/main/AndroidManifest.xml",
    "android/app/src/profile/AndroidManifest.xml",
    "android/app/build.gradle",
    "lib/ui/features/focus_timer/views/active_timer_view.dart",
    "android/app/src/main/kotlin/com/example/focus_pact/MainActivity.kt",
    "android/app/src/main/kotlin/com/example/focus_pact/DummyActivity.kt"
]

old_package = "com.example.focus_pact"
new_package = "com.barolabs.pomofarm"

for filepath in files_to_update:
    if os.path.exists(filepath):
        with open(filepath, "r") as f:
            content = f.read()
        
        updated_content = content.replace(old_package, new_package)
        
        with open(filepath, "w") as f:
            f.write(updated_content)
        print(f"Updated {filepath}")

# 2. Move Kotlin files
old_dir = "android/app/src/main/kotlin/com/example/focus_pact"
new_dir = "android/app/src/main/kotlin/com/barolabs/pomofarm"

os.makedirs(new_dir, exist_ok=True)

if os.path.exists(old_dir):
    for filename in os.listdir(old_dir):
        if filename.endswith(".kt"):
            src = os.path.join(old_dir, filename)
            dst = os.path.join(new_dir, filename)
            shutil.move(src, dst)
            print(f"Moved {src} to {dst}")
    
    # Try removing old dir if empty
    try:
        os.rmdir(old_dir)
        os.rmdir("android/app/src/main/kotlin/com/example")
    except OSError:
        pass

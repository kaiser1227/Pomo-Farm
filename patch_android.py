import os
import re

manifest_path = "android/app/src/main/AndroidManifest.xml"
with open(manifest_path, 'r') as f:
    manifest_content = f.read()

# Add DummyActivity
if "DummyActivity" not in manifest_content:
    dummy_activity = """
        <activity
            android:name=".DummyActivity"
            android:theme="@android:style/Theme.Translucent.NoTitleBar"
            android:exported="false" />
"""
    manifest_content = manifest_content.replace("</application>", dummy_activity + "</application>")
    with open(manifest_path, 'w') as f:
        f.write(manifest_content)

dummy_activity_path = "android/app/src/main/kotlin/com/example/focus_pact/DummyActivity.kt"
with open(dummy_activity_path, 'w') as f:
    f.write("""package com.example.focus_pact

import android.app.Activity
import android.os.Bundle

class DummyActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        finish()
        overridePendingTransition(0, 0)
    }
}
""")

main_activity_path = "android/app/src/main/kotlin/com/example/focus_pact/MainActivity.kt"
with open(main_activity_path, 'r') as f:
    main_content = f.read()

if "DummyActivity" not in main_content:
    replacement = """
                        stopLockTask()
                        val intent = android.content.Intent(this@MainActivity, DummyActivity::class.java)
                        intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NO_ANIMATION)
                        startActivity(intent)
                        result.success(true)"""
    main_content = re.sub(r"stopLockTask\(\)\s*result\.success\(true\)", replacement, main_content)
    with open(main_activity_path, 'w') as f:
        f.write(main_content)

print("Patch applied")

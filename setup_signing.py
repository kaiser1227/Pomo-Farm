import re

build_gradle_path = 'android/app/build.gradle'
with open(build_gradle_path, 'r') as f:
    content = f.read()

keystore_properties_snippet = """
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
"""
if "def keystoreProperties" not in content:
    content = content.replace("apply plugin: 'kotlin-android'", keystoreProperties_snippet + "\napply plugin: 'kotlin-android'")

signing_config_snippet = """
    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }
"""

if "signingConfigs {" not in content:
    content = content.replace("buildTypes {", signing_config_snippet + "\n    buildTypes {")

content = re.sub(r'signingConfig signingConfigs\.debug', 'signingConfig signingConfigs.release', content)

with open(build_gradle_path, 'w') as f:
    f.write(content)
print("Updated build.gradle for release signing")

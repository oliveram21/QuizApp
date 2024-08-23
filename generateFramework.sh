# A shell script for creating an XCFramework for iOS.

WORKSPACE_NAME="QuizApp.xcworkspace"
FRAMEWORK_SCHEME="QuizEngine1"

# Starting from a clean slate
# Removing the build and output folders
rm -rf ./build &&\
rm -rf ./output &&\
echo $WORKSPACE_NAME
# Cleaning the workspace cache
xcodebuild \
    clean \
    -workspace $WORKSPACE_NAME \
    -scheme $FRAMEWORK_SCHEME

# Create an archive for iOS devices
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace $WORKSPACE_NAME \
        -scheme $FRAMEWORK_SCHEME \
        -configuration Release \
        -destination "generic/platform=iOS" \
        -archivePath build/$FRAMEWORK_SCHEME-iOS.xcarchive

# Create an archive for iOS simulators
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace $WORKSPACE_NAME \
        -scheme $FRAMEWORK_SCHEME \
        -configuration Release \
        -destination "generic/platform=iOS Simulator" \
        -archivePath build/$FRAMEWORK_SCHEME-iOS_Simulator.xcarchive
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace $WORKSPACE_NAME \
        -scheme $FRAMEWORK_SCHEME \
        -configuration Release \
        -destination "generic/platform=macOS" \
        -archivePath build/$FRAMEWORK_SCHEME-macOS.xcarchive
# Convert the archives to .framework
# and package them both into one xcframework
xcodebuild \
    -create-xcframework \
    -archive build/$FRAMEWORK_SCHEME-iOS.xcarchive -framework $FRAMEWORK_SCHEME.framework \
    -archive build/$FRAMEWORK_SCHEME-iOS_Simulator.xcarchive -framework $FRAMEWORK_SCHEME.framework \
    -archive build/$FRAMEWORK_SCHEME-macOS.xcarchive -framework $FRAMEWORK_SCHEME.framework \
    -output output/$FRAMEWORK_SCHEME.xcframework &&\
    rm -rf build
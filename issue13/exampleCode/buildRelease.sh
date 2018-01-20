rm -rf build
xcrun xcodebuild -sdk iphoneos -configuration Release
rm -rf ~/Desktop/output/
mkdir ~/Desktop/output
cp -r build/Release-iphoneos/swift-weekly.app ~/Desktop/output/
cp -r build/Release-iphoneos/swift-weekly.app.dSYM ~/Desktop/output/
open ~/Desktop/output/


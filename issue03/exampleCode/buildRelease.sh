rm -rf build
xcrun xcodebuild -sdk iphonesimulator -configuration Release -arch x86_64
rm -rf ~/Desktop/output/
mkdir ~/Desktop/output
cp -r build/Release-iphonesimulator/swift-weekly.app ~/Desktop/output/
cp -r build/Release-iphonesimulator/swift-weekly.app.dSYM ~/Desktop/output/


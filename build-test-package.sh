
/usr/local/bin/xctool -reporter pretty clean
#/usr/local/bin/xctool -workspace ${WORKSPACE}/sources/eXo_Platform.xcworkspace -scheme eXoCI -reporter pretty clean
#/usr/local/bin/xctool -workspace ${WORKSPACE}/sources/eXo_Platform.xcworkspace -scheme eXoCI -reporter pretty build

/usr/local/bin/xctool \
-reporter pretty \
-reporter junit:${WORKSPACE}/test-reports/junit.xml \
test -resetSimulator

## Archive process
# Unlock required configuration
security unlock-keychain -p $MACMINI_PASSWORD ~/Library/Keychains/login.keychain

# Create generic archive
xcodebuild archive -workspace eXo_Platform.xcworkspace -scheme eXo -archivePath eXo.xcarchive

# Remove the potential old archive
[ -f "${WORKSPACE}/eXo.ipa" ] && rm "${WORKSPACE}/eXo.ipa"

# Create the final archive with credentials...
xcodebuild -exportArchive -archivePath eXo.xcarchive -exportPath eXo -exportFormat ipa -exportProvisioningProfile "XC Ad Hoc: com.exoplatform.mob.eXoPlatformiPHone"


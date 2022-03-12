platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'WeatherDemo' do
  use_frameworks!

  pod 'MJExtension'
  pod 'SDWebImage'
  pod 'MBProgressHUD'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end

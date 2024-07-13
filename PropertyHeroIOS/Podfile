platform :ios, '14.0'

def pods
    # Clean Architecture
    pod 'MGArchitecture', '~> 2.0.1'
    pod 'MGAPIService', '~> 3.0.0'
    pod 'MGLoadMore', '~> 3.0.2'
    pod 'Dto'

    # Rx
    pod 'RxViewController'

    # Core
    pod 'Reusable', '~> 4.1'
    pod 'Then', '~> 2.7'

    # Others
    pod 'MBProgressHUD', '~> 1.2'
    pod 'SDWebImage', '~> 5.8.3'

    #ImageSlideshow
    pod "ImageSlideshow", '~> 1.9.2'
    pod "ImageSlideshow/SDWebImage"
    
    # Google Maps
    pod 'GoogleMaps', '~>7.3.0'
    pod 'Google-Maps-iOS-Utils', '~>4.2.2'
    pod 'GoogleSignIn'
    
    pod 'FlexibleTable'
    pod 'DLRadioButton', '~> 1.4'
    pod 'RSKImageCropper'
    pod 'DatePickerDialog'
end

target 'PropertyHero' do
    use_frameworks!
    inhibit_all_warnings!
    pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 14.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end
end

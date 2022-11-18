# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'HongikTimer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'RxViewController'
 	pod 'RxGesture'

  pod 'SwiftLint'
  
  pod 'URLNavigator'
  pod 'FSCalendar'

  pod 'Firebase/Database'

  pod 'FirebaseAuth'
  pod 'GoogleSignIn'
  pod 'KakaoSDK'
  pod 'naveridlogin-sdk-ios'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
  end

  pod 'Toast-Swift', '~> 5.0.1'



  # Pods for HongikTimer

  target 'HongikTimerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HongikTimerUITests' do
    # Pods for testing
  end

end

#
# Be sure to run `pod lib lint SSUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSUIKit'
  s.version          = '0.1.1'
  s.summary          = 'Sheng Sheng Huitouche UIKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wudi890520/SSUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wudi890520' => '593154883@qq.com' }
  s.source           = { :git => 'https://github.com/wudi890520/SSUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SSUIKit/Classes/Extensions/**/*.{h,m,swift}', 'SSUIKit/Classes/Components/**/**/*.{h,m,swift}'
  
  s.resource = 'SSUIKit/Assets/*.*'
  
  s.ios.frameworks = 'UIKit', 'Foundation', 'CoreLocation'
  
  #https://qmuiteam.com/ios
  s.dependency 'QMUIKit', '~> 4.0.3'
  
  # https://github.com/ibireme/YYKit
  s.dependency 'YYCategories', '~> 1.0.4'
  
  #https://github.com/ibireme/YYKit
  s.dependency 'YYText', '~> 1.0.7'
  
  # https://github.com/SwiftKickMobile/SwiftMessages
  s.dependency 'SwiftMessages', '~> 7.0.1'
  
  # 空数据 https://github.com/dzenbot/DZNEmptyDataSet
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
  
  # 图片下载 https://github.com/onevcat/Kingfisher
  s.dependency 'Kingfisher', '~> 5.7.1'
  
  # 弹出视图，类似微信首页右上角“+” https://github.com/liufengting/FTPopOverMenu_Swift
  s.dependency 'FTPopOverMenu_Swift', '~> 0.2.1'
  
  # 显示器 https://github.com/search?q=NVActivityIndicatorView
  s.dependency 'NVActivityIndicatorView', '~> 4.8.0'
  
  # 提示 https://github.com/scalessec/Toast-Swift
  s.dependency 'Toast-Swift', '~> 5.0.0'
  
  # 警示框（alertViewController）https://github.com/HJaycee/JCAlertController
  s.dependency 'JCAlertController', '~> 3.0.4'
  
  # 下拉刷新 https://github.com/CoderMJLee/MJRefresh
  s.dependency 'MJRefresh', '~> 3.1.15.7'
  
  # 广告视图 https://github.com/WenchaoD/FSPagerView
  s.dependency 'FSPagerView', '~> 0.8.2'
  
  # 获取设备信息 https://github.com/devicekit/DeviceKit
  s.dependency 'DeviceKit', '~> 2.3.0'
  
end

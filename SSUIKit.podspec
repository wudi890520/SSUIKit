#
#  Be sure to run `pod spec lint SSUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SSUIKit"
  s.version      = "0.3.7"
  s.summary      = "Sheng Sheng Huitouche UIKit"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                      SSUIKit是一个UIKit的扩展
                      DESC

  s.homepage     = "https://github.com/wudi890520/SSUIKit"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "wudi" => "593154883@qq.com" }
  # Or just: spec.author    = "wudi"
  # spec.authors            = { "wudi" => "593154883@qq.com" }
  # spec.social_media_url   = "https://twitter.com/wudi"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => 'https://github.com/wudi890520/SSUIKit.git', :tag => s.version.to_s }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  s.swift_version    = '5.0'
  s.platform         = :ios, '10.0'

  s.source_files  = 'SSUIKit/Classes/Extensions/*.{h,m,swift}', 'SSUIKit/Classes/Components/**/*.{h,m,swift}', 'SSUIKit/Classes/SVProgressHUD/*.{h,m,swift}', 'SSUIKit/Classes/*.*'
  

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #
  s.resource = 'SSUIKit/Assets/*.*'
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #
  s.ios.frameworks = 'UIKit', 'Foundation', 'CoreLocation', 'AVFoundation'
  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"
  # https://qmuiteam.com/ios
  s.dependency 'QMUIKit', '~> 4.0.4'
  
  # https://github.com/BlocksKit/BlocksKit
  s.dependency 'BlocksKit', '~> 2.2.5'
   
  # https://github.com/SnapKit/SnapKit
  s.dependency 'SnapKit', '~> 5.0.1'
   
  # https://github.com/ReactiveX/RxSwift
  s.dependency 'RxSwift', '~> 5.0.1'
  s.dependency 'RxCocoa', '~> 5.0.1'
  s.dependency 'RxGesture', '~> 3.0.0'
  s.dependency 'RxKeyboard', '~> 1.0.0'
  s.dependency 'RxOptional', '~> 4.1.0'
  s.dependency 'RxViewController', '~> 1.0.0'
  
  # https://github.com/ibireme/YYKit
  s.dependency 'YYCategories', '~> 1.0.4'
   
  # https://github.com/ibireme/YYKit
  s.dependency 'YYText', '~> 1.0.7'
   
  # 相册选择（仿微信）https://github.com/banchichen/TZImagePickerController
  s.dependency 'TZImagePickerController', '~> 3.2.6'
   
  # 空数据 https://github.com/dzenbot/DZNEmptyDataSet
  s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
   
  # 图片下载 https://github.com/onevcat/Kingfisher
  s.dependency 'Kingfisher', '~> 5.11.0'
   
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

#  # 日期管理 https://github.com/malcommac/SwiftDate
#  s.dependency 'SwiftDate', '~> 6.1.0'

end

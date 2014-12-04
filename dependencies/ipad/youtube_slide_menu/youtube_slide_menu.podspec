
Pod::Spec.new do |s|
  s.name     = 'youtube_slide_menu'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'youtube_slide_menu aims to be a drop-in replacement for UITabBarController with the intention of letting developers easily customise its appearance.' 
  s.description = 'youtube_slide_menu aims to be a drop-in replacement of UITabBarController with the intention of letting developers easily customise its appearance. JBTabBar uses .'
  s.homepage = 'http://jinthagerman.github.com/youtube_slide_menu'
  s.author   = { 'Jin Budelmann' => 'jin@bitcrank.com' }
  s.source   = { :git => 'https://github.com/jinthagerman/youtube_slide_menu.git', :tag => '0.1.0' }
  s.platform = :ios

  #s.source_files = 'Pod/Classes/*/*.{h,m}'

  s.resources = "Pod/Assets/*/*.*"
  s.requires_arc = true


  s.subspec 'leftmenu' do |sub|
    sub.source_files = 'Pod/Classes/leftmenu/*.{h,m}'
  end

  s.subspec 'leftviews' do |sub|
    sub.source_files = 'Pod/Classes/leftviews/*.{h,m}'
  end

  s.subspec 'AsynLeftRowNode' do |sub|
    sub.source_files = 'Pod/Classes/AsynLeftRowNode/*.{h,m}'
  end


end


#
# Be sure to run `pod lib lint SineWaveView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SineWaveView'
  s.version          = '0.1.0'
  s.summary          = 'An UIView that shows sine waves.'

  s.description      = <<-DESC
Provides an UIView that shows sine waves.
                       DESC

  s.homepage         = 'https://github.com/Hugal31/SineWaveView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hugal31' => 'hugo.laloge@gmail.com' }
  s.source           = { :git => 'https://github.com/Hugal31/SineWaveView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SineWaveView/**/*'

  s.frameworks = 'UIKit'
end

Pod::Spec.new do |s|
  s.name         = "ReactiveFormlets"
  s.version      = "1.01"
  s.summary      = "A framework for building iOS forms compositionally and reactively."
  s.homepage     = "https://github.com/jonsterling/ReactiveFormlets"
  s.author       = { "Jon Sterling" => "jonsterling@me.com" }
  s.source       = { :git => "https://github.com/jonsterling/ReactiveFormlets.git", :tag => "v#{s.version}" }
  s.license      = 'Simplified BSD License'
  s.description  = "ReactiveFormlets is an API for building forms compositionally with an Applicative-style interface."

  s.requires_arc = true
  s.platform = :ios, '6.0'
  s.compiler_flags = '-DOS_OBJECT_USE_OBJC=0'

  s.source_files = 'ReactiveFormlets/*.{h,m}'
  s.public_header_files = 'ReactiveFormlets/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'ReactiveCocoa', '~> 1.8.0'
end

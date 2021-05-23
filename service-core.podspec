Pod::Spec.new do |spec|
  spec.name          = 'service-core'
  spec.module_name   = 'ServiceCore'
  spec.version       = '0.0.1'
  spec.license       = 'MIT'
  spec.authors       = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage      = "https://github.com/Incetro/service-core.git"
  spec.summary       = 'Base classes in Incetro to implement services business logic'
  spec.platform      = :ios, "12.0"
  spec.swift_version = '5.3'
  spec.source        = { git: "https://github.com/Incetro/service-core.git", tag: "#{spec.version}" }
  spec.source_files  = "Sources/ServiceCore/**/*.{h,swift}"
  spec.dependency "Codex"
  spec.dependency "incetro-http-transport"
end
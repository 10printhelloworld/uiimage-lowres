# This spec is the bare minimum for including from github or local repo
# It won't work for the official cocoapods repo

Pod::Spec.new do |s|
  s.name = "lowres"
  s.platform = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/*'
  s.public_header_files = 'Pod/Classes/*.h'
end

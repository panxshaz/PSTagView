Pod::Spec.new do |spec|
  spec.name = "PSTagView"
  spec.version = "1.0.0"
  spec.summary = "Simple, easy to use control for using tags in Swift UITableViewCell"
  spec.homepage = "https://github.com/panxshazm/PSTagView"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Pankaj Sharma" => 'pankaj@marijuanaincstudios.com' }
  spec.social_media_url = "https://www.facebook.com/appigizer"

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/panxshazm/PSTagView.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = 'PSTagView/PSTagTableCell.swift', 'PSTagView/PSTagTableCell.xib'
end

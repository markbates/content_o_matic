# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{content_o_matic}
  s.version = "0.0.1.20090720170922"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["markbates"]
  s.date = %q{2009-07-20}
  s.description = %q{content_o_matic was developed by: markbates}
  s.email = %q{}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["lib/content_o_matic/content_cache.rb", "lib/content_o_matic/content_o_matic.rb", "lib/content_o_matic/errors.rb", "lib/content_o_matic/response.rb", "lib/content_o_matic/text_helper.rb", "lib/content_o_matic.rb", "README", "LICENSE"]
  s.homepage = %q{}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{magrathea}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{content_o_matic}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<configatron>, [">= 0"])
      s.add_runtime_dependency(%q<cachetastic>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<configatron>, [">= 0"])
      s.add_dependency(%q<cachetastic>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<configatron>, [">= 0"])
    s.add_dependency(%q<cachetastic>, [">= 0"])
  end
end

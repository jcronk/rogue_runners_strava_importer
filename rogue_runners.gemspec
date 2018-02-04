
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rogue_runners/version'

Gem::Specification.new do |spec|
  spec.name          = 'rogue_runners'
  spec.version       = RogueRunners::VERSION
  spec.authors       = ['Jeremy Cronk']
  spec.email         = ['philipmarlow@gmail.com']

  spec.summary       = %q(
    Take a list of recent activities from the Rogue Runners
    Strava club and place them in a spreadsheet
  )
  spec.description = %q(
    This is intended for the monthly mileage logs for the group.  If this is
    run at least weekly, the members of the Facebook group who are also on
    Strava will have their public activities picked up and placed in a Google
    spreadsheet to be pulled into the regular mileage log.
  )
  spec.homepage      = 'https://github.com/jcronk/rogue_runners_strava_importer'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'google_drive', '2.1.8'
  spec.add_dependency 'strava-api-v3', '0.7.0'
end

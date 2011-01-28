require 'rubygems'
require 'betabuilder'

BetaBuilder::Tasks.new do |config|
  # your Xcode target name
  config.target = "Bellwinters"

  # the Xcode configuration profile
  config.configuration = "Release"

  config.deploy_using(:testflight) do |tf|
    tf.api_token  = "88c7b160801cc2c3759a295454154477_MTM3ODk"
    tf.team_token = "e9cab8a2fde91f07563194b4b28f5369_MzgwNA"
  end
end
